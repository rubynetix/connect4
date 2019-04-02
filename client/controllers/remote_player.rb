require_relative 'player'
require_relative 'client'

class RemotePlayer < Player

  attr_accessor :op_counters, :my_win

  def initialize(name, counters, game_id, client=nil)
    super name, counters
    @game_id = game_id

    if client.nil?
      @client = Client.new
    end
  end

  def take_turn(board, ui, state)
    ui.set_turn(self)
    @board = board
    @waiting = true
    update_remote_board(board, state)
    get_action ui, board
  end

  # Send updated board to remote server
  def update_remote_board(board, state)
    @client.put_game(@game_id, board.board, @name, state)
    # TODO: Handle fail response
  end

  def get_action(ui, board)
    # Wait for remote player to take their turn
    while true
      result = @client.get_game(@game_id)
      if result['turn'] != @name
        break
      end
      sleep(0.5)
    end

    parse_response(result)
  end

  # Parse the result from the server and create the corresponding event
  def parse_response(result)
    return forfeit if result['state'] == PlayerAction::FORFEIT
    update_board(result['board'])
  end

  def update_board(board)
    @board.board = board
    # TODO: Might have to do something (eg reset) board.last_location_pos
    PlayerAction::REMOTE_UPDATE_BOARD
  end


end
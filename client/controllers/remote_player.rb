require_relative 'player'
require_relative 'client'

class RemotePlayer < Player

  attr_accessor :op_counters, :op_win

  def initialize(name, local_user, counters, game_id, op_win, client)
    super name, counters
    @local_user = local_user
    @game_id = game_id
    @op_win = op_win # either 'w1' or 'w2' depending on player #
    @client = client
  end

  def take_turn(board, ui, state)
    ui.set_turn(self)
    @board = board
    @waiting = true
    update_remote_board(board, @name)
    get_action ui, board
  end

  # Send updated board to remote server
  def update_remote_board(board, player)
    # TODO: Handle fail response
    @client.put_game(@game_id, board, player)
  end

  def get_action(ui, board)
    # Wait for remote player to take their turn
    while true
      result = @client.get_game(@game_id)
      if result[:turn] == @local_user
        parse_response(result)
        break
      end
      sleep(0.5)
    end
  end

  # Parse the result from the server and create the corresponding event
  def parse_response(result)
    return forfeit if result[:state] == @op_win
    update_board(result[:board])
  end

  def update_board(board)
    @board.board = board
    # TODO: Might have to do something (eg reset) board.last_location_pos
    PlayerAction::REMOTE_UPDATE_BOARD
  end


end
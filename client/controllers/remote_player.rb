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

  def take_turn(board, ui)
    ui.set_turn(self)
    @board = board
    @waiting = true
    update_remote_board(board)
    get_action ui, board
  end

  # Send updated board to remote server
  def update_remote_board(board, player: @local_user)
    begin
      @client.put_game(@game_id, board, player)
    rescue InvalidTurn
      # Throws when continuing game as remoteplayer -- no need to overwrite remote board in this case
    end
  end

  def get_action(ui, board)
    ui.register(self)
    @cancelled = Queue.new

    while @cancelled.empty?
      # TODO: CURRENTLY WHERE THE GAME FAILS
      result = @client.get_game(@game_id)
      if result[:state] != 'active'
        ui.unregister(self)
        return PlayerAction::REMOTE_UPDATE
      elsif result[:turn] == @local_user
        ui.unregister(self)
        return parse_response(result)
      end
      sleep(4)
    end

    ui.unregister(self)
    PlayerAction::EXIT_ONLINE_GAME
  end

  def notify(event)
    @cancelled << true if event.id == UIEvent::EXIT_ONLINE_GAME
  end

  # Parse the result from the server and create the corresponding event
  def parse_response(result)
    return forfeit if result[:state] == @op_win
    update_board(result[:board])
  end

  def update_board(board)
    @board.board = board.board
    PlayerAction::REMOTE_UPDATE
  end
end
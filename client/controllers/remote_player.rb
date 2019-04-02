require_relative 'player'

class RemotePlayer < Player

  attr_accessor :op_counters, :my_win

  def initialize(name, counters, game_id, xml_client)
    super name, counters
    @game_id = game_id

    @xml_client = xml_client
  end

  def take_turn(board, ui)
    ui.set_turn(self)
    @board = board
    @waiting = true
    update_remote_board(board)
    get_action ui, board
  end

  # Send updated board to remote server
  def update_remote_board(board)
    # TODO: Need to rework current architecture to pass in game state. Currently just passing in NEUTRAL as a placeholder
    @xml_client.call("game.put", @game_id, board.board, @name, WinEnum::NEUTRAL)
  end

  def get_action(ui, board)
    # Wait for server to update
    while true
      result = @xml_client.call( "game.get", [@game_id])
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

    # TODO: Set the state as a class attribute of the board
    PlayerAction::REMOTE_UPDATE_BOARD
  end


end
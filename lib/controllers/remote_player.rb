require_relative 'player'

class RemotePlayer < Player

  attr_accessor :op_counters, :my_win

  def initialize(name, counters, game_id)
    super name, counters
    @game_id = game_id

    # TODO: Pass this in rather than init here
    @xml_client = XMLRPC::Client.new('localhost', '/', 8080)
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
    # Test and update this - change this to the proper name
    @xml_client.call("game.put", @game_id, board, @name)
  end

  def get_action(ui, board)
    # Wait for server to update
    while true
      result = @xml_client.call( "game.get", [@game_id])
      if result['player_turn'] != @name
        break
      end
      sleep(0.5)
    end

    parse_response(result)
  end

  # Parse the result from the server and create the corresponding event
  def parse_response(result)
    return forfeit if result['game_state'] == PlayerAction::FORFEIT
    update_board(result['board'])
  end

  def update_board(board)
    @board = board
    PlayerAction::PLACE_COUNTER
  end

end
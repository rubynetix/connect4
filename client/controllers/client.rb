class Client

  def initialize(host: 'localhost', path: '/', port: 8080)
    @xml_client = XMLRPC::Client.new(host, path, port)
  end

  def create_user(username)
    result = @xml_client.call("user.create", username)
    result["create"]
  end

  def user_games(username)
    result = @xml_client.call("user.games", username)
    result['games']
  end

  def list_users()
    result = @xml_client.call("user.list")
    result['list']
  end

  def create_game(username1, username2)
    result = @xml_client.call("game.create", username1, username2)
    result['id']
  end

  def get_game(gid)
    result = @xml_client.call("game.get", gid)
    [result['board'], result['turn'], result['state']]
  end

  def put_game(gid, board_array, player_turn, game_state)
    result = @xml_client.call("put.game", [gid, board_array, player_turn, game_state])
    result['put']
  end

  def get_league_standings(username)
    result = @xml_client.call("league.standings", username)
    [result['wins'], result['loses']]
  end

end
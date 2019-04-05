require 'xmlrpc/client'

class Client

  def initialize(host: 'localhost', path: '/', port: 8080)
    @xml_client = XMLRPC::Client.new(host, path, port)
  end

  def create_user(username)
    @xml_client.call("user.create", username)
  end

  def user_games(username)
    @xml_client.call("user.games", username)
  end

  def list_users()
    @xml_client.call("user.list")
  end

  def create_game(username1, username2)
    @xml_client.call("game.create", username1, username2)
  end

  def get_game(gid)
    @xml_client.call("game.get", gid)
  end

  def put_game(gid, board_array, player_turn, game_state)
    @xml_client.call("put.game", [gid, board_array, player_turn, game_state])
  end

  def get_league_standings(username)
    @xml_client.call("league.standings", username)
  end

  def get_league(username)
    @xml_client.call("league.league")
  end

end

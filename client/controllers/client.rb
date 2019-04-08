require 'xmlrpc/client'
require_relative '../../client/models/game_board'
require_relative '../../server/server_error'


def symbolize_keys(hash)
  sym_hash = {}
  hash.each do |k, v|
    sym_hash[k.to_sym] = v
  end
  sym_hash
end


class Client

  def initialize(host: 'localhost', path: '/', port: 8080)
    @xml_client = XMLRPC::Client.new(host, path, port)
  end

  def create_user(username)
    call("user.create", username)
  end

  def user_games(username)
    call("user.games", username)[:games].map(&method(:symbolize_keys))
  end

  def list_users()
    call("user.list")
  end

  def create_game(username1, username2, game_type, game_board)
    gb = encode(game_board)
    call("game.create", username1, username2, game_type, gb)
  end

  def get_game(gid)
    game = call("game.get", gid)
    game[:board] = decode(game[:board])
    game
  end

  def put_game(gid, board_array, player_turn, game_state)
    call("put.game", [gid, board_array, player_turn, game_state])
  end

  def get_league_standings(username)
    call("league.standings", username)
  end

  def get_league(username)
    @xml_client.call("league.league")
  end

  private

  def call(method, *args)
    res = symbolize_keys(@xml_client.call(method, *args))
    if res.key?(:exception)
      raise Marshal.load(res[:exception])
    end
    res
  end

  def encode(obj)
    Marshal.dump(obj)
  end

  def decode(bytes)
    Marshal.load(bytes)
  end

end
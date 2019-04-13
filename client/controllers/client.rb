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

  def login(username)
    call("user.login", username)[:success]
  end

  def user_games(username)
    call("user.games", username)[:games].map(&method(:symbolize_keys))
  end

  def user_list
    call("user.list")[:list]
  end

  def create_game(username1, username2, game_type, game_board)
    gb = encode(game_board)
    call("game.create", username1, username2, game_type, gb)[:game_id]
  end

  def get_game(gid)
    game = call("game.get", gid)
    game[:board] = decode(game[:board])
    game
  end

  def put_game(gid, game_board, player_turn)
    # Shouldn't update the board if no turn has been taken
    return if game_board.last_counter_pos.nil? or game_board.last_counter_pos?

    begin
      gb = encode(game_board)
      counter = encode(game_board.last_counter_pos)
      call("game.put", gid, gb, player_turn, counter)
    rescue => exception
      puts "-------- DEBUG ---------"
      puts "GID: #{gid}"
      puts "GAME_BOARD: #{game_board}"
      puts "PLAYER TURN: #{player_turn}"
      puts "LAST COUNTER: #{game_board.last_counter_pos}"
      puts exception.backtrace
      raise
    end
  end

  def forfeit_game(gid, player_name)
    call("game.forfeit", gid, player_name)
  end

  def get_league_standings(username)
    call("league.standings", username)
  end

  def get_league
    call("league.league")[:league].map(&method(:symbolize_keys))
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

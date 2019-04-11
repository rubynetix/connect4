require 'mysql2'
require 'uuid'
require_relative '../../server/base_handler'
require_relative '../../client/models/game_board'



class TestDBHandler < BaseHandler

  def initialize
    super
    @uuid = UUID.new
    @game_uuids = []
    query("DELETE from games;")
    query("DELETE from users;")
    load_users
    load_games
  end

  def load_users
    File.open(Dir.pwd + '/test/db_test/queries/create_test_db_users.sql').each do |line|
      query(line)
    end
  end

  def load_games
    File.open(Dir.pwd + '/test/db_test/queries/create_test_db_games.sql').each do |line|
      game_id = @uuid.generate
      @game_uuids.append(game_id)
      query(line, game_id)
    end
  end
end


tdbh = TestDBHandler.new
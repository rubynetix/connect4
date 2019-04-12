require 'mysql2'
require 'uuid'
require_relative '../../server/base_handler'
require_relative '../../client/models/game_board'



class TestDBHandler < BaseHandler

  attr_reader :users

  def initialize
    super
    @uuid = UUID.new
    @game_uuids = []
    @users = ['conservative', 'ndp', 'green', 'rhinoceros', 'liberal']
    query("DELETE from games;")
    query("DELETE from users;")
    load_users
    load_games
  end

  def rand_board(fill_factor: rand(1..100))
    board = GameBoard.connect4
    counters = ([fill_factor.abs.to_f, 1.0].min * board.rows * board.cols).floor

    while counters > 0
      c = rand(0...board.cols)
      unless board.col_full?(c)
        board.place(@default_counter, c)
        counters -= 1
      end
    end

    board
  end

  def load_users
    @users.each do |user|
      query('INSERT INTO users (username) VALUES (?);', user)
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
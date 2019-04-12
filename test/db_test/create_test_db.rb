require 'mysql2'
require 'uuid'
require_relative '../../server/base_handler'
require_relative '../../client/models/game_board'
require_relative '../../client/models/counter'

class TestDBHandler < BaseHandler

  attr_reader :users, :no_game_user, :boards

  def initialize(opts = {})
    super(opts)
    @uuid = UUID.new
    @game_uuids = []
    @users = ['conservative', 'ndp', 'green', 'rhinoceros', 'liberal']
    @no_game_user = 'libertarian'
    @boards = {}
    query("DELETE from games;")
    query("DELETE from users;")
    load_users
    load_games
    load_gameboards
  end

  def rand_board(fill_factor: rand)
    board = GameBoard.connect4
    counters = ([fill_factor.abs.to_f, 0.75].min * board.rows * board.cols).floor

    while counters > 0
      c = rand(0...board.cols)
      unless board.col_full?(c)
        board.place(RedCounter.instance, c)
        counters -= 1
      end
    end

    board
  end

  private

  def load_users
    @users.each do |user|
      query('INSERT INTO users (username) VALUES (?);', user)
    end
    query('INSERT INTO users (username) VALUES (?);', @no_game_user)
  end

  def load_games
    File.open(Dir.pwd + '/test/db_test/queries/create_test_db_games.sql').each do |line|
      game_id = @uuid.generate
      @game_uuids.append(game_id)
      query(line, game_id)
    end
  end

  def load_gameboards
    @game_uuids.each do |gid|
      board = rand_board
      @boards[gid] = board
      query 'INSERT INTO game_boards (game_id, board) VALUES (UUID_TO_BIN(?), ?);', gid, Marshal.dump(board)
    end
  end
end

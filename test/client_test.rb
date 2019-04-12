require_relative 'helper'
require_relative '../server/server'
require_relative '../client/models/game_board'
require_relative 'db_test/create_test_db'
require_relative '../client/controllers/client'

class ClientTest < Helper

  class << self
    def startup
      @server_thread = Thread.new do
        serve
      end
    end
    def shutdown
      #
    end
  end

  def setup_db
    @tdbh = TestDBHandler.new
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

  def setup
    setup_db
    @client = Client.new
  end

  def teardown
    #
  end

  def test_user_games
    user = @tdbh.users.sample
    length = 3

    gids = @client.user_games user

    begin
      assert_equal gids.length, length
    end
  end

  def test_create_game
    user1 = @tdbh.users.sample
    user2 = @tdbh.no_game_user
    gids1 = @client.user_games user1
    gids2 = @client.user_games user1


    gid = @client.create_game user1, user2, 'connect4', rand_board

    new_gids1 = @client.user_games user1
    new_gids2 = @client.user_games user1

    begin
      assert_equal gids1.length+1, new_gids1.length
      assert_equal gids2.length+1, new_gids2.length
      assert_not_include gids1, gid
      assert_not_include gids2, gid
      assert_include new_gids1, gid
      assert_include new_gids2, gid
    end

  end

  def test_get_game
    user = @tdbh.users.sample

  end

  def test_put_game
    user = @tdbh.users.sample

  end
end
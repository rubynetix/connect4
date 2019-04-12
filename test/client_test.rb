require_relative 'helper'
require 'xmlrpc/server'
require_relative '../client/models/game_board'
require_relative 'db_test/create_test_db'
require_relative '../client/controllers/client'
require_relative '../server/server_error'

class ClientTest < Helper
  HOST = "162.246.157.188"
  PORT = '8080'

  class << self
    def test_db
      c = Mysql2::Client.new(
          :host => HOST,
          :database => "test",
          :port => 3306,
          :username => "test",
          :password => "test")
      {db_client: c}
    end

    def serve
      puts HOST
      s = XMLRPC::Server.new(PORT)
      db_client = test_db
      s.add_handler('user', UserHandler.new(db_client))
      s.add_handler('game', GameHandler.new(db_client))
      s.add_handler('league', LeagueHandler.new(db_client))
      s.serve
    end
    def startup
      @server_thread = Thread.new(&method(:serve))
    end
    def shutdown
      #
    end
  end

  def setup_db
    @tdbh = TestDBHandler.new self.class.test_db
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

  def setup
    setup_db
    @client = Client.new
  end

  def teardown
    #
  end

  def test_login_success
    1..3.times do
      user = @tdbh.users.sample
      res = @client.login(user)
      assert_true(res)
    end
  end

  def test_login_fail
    non_users = ['republican', 'democrat', 'Communist Party of China']
    non_users.each do |name|
      res = @client.login(name)
      assert_false(res)
    end
  end

  def test_create_user_valid
    new_users = ['republican', 'democrat', 'CommunistPartyofChina']
    new_users.each do |user|
      res = @client.create_user(user)
      assert_true(res[:success])
    end
  end

  def test_create_user_invalid
    new_users = ['republican!!!!', 'Communist Party of China']
    new_users.each do |user|
      assert_raise(InvalidUsername) {@client.create_user(user)}
    end
  end

  def test_create_user_duplicate
    1..3.times do
      user = @tdbh.users.sample
      assert_raise(DuplicateUsers) {@client.create_user(user)}
    end
  end

  def test_user_list
    expected = @tdbh.users.append(@tdbh.no_game_user)
    assert_true(expected.sort.uniq == @client.user_list[:list].sort.uniq)
  end

  def test_user_games
    user = @tdbh.users.sample
    length = 4

    gids = @client.user_games user

    begin
      assert_equal gids.length, length
    end
  end

  def test_create_game
    user1 = @tdbh.users.sample
    user2 = @tdbh.no_game_user
    gids1 = @client.user_games(user1).map {|e| e[:game_id]}
    gids2 = @client.user_games(user2).map {|e| e[:game_id]}


    gid = @client.create_game user1, user2, 'connect4', rand_board

    new_gids1 = @client.user_games(user1).map {|e| e[:game_id]}
    new_gids2 = @client.user_games(user2).map {|e| e[:game_id]}

    begin
      assert_equal gids1.length+1, new_gids1.length, "One game should have been added for user1"
      assert_equal gids2.length+1, new_gids2.length, "One game should have been added for user2"
      assert_not_include gids1, gid, "The created game id must be new for user1"
      assert_not_include gids2, gid, "The created game id must be new for user2"
      assert_include new_gids1, gid, "The created game id must be user1's game ids"
      assert_include new_gids2, gid, "The created game id must be user2's game ids"
    end

  end

  def test_get_game
    user = @tdbh.users.sample

    @client.user_games(user).map {|e| e[:game_id]}.each do |gid|
     game = @client.get_game gid

      begin
        assert_true game.key?(:game_id), 'result must contain an id'
        assert_true game.key?(:state), 'result must contain a state'
        assert_true game.key?(:turn), 'result must contain a turn'
        assert_true game.key?(:board), 'result must contain a board'
        assert_equal game[:game_id], gid
        assert_equal game[:board].to_s, @tdbh.boards[gid].to_s, 'the board must be the same as the board put into the db'
      end
    end

  end

  def test_put_game
    user = @tdbh.users.sample
    gids = @client.user_games(user).map {|e| e[:game_id]}
    rand_gid = gids.sample
    turn = @client.get_game(rand_gid)[:turn]

    board = rand_board
    res = @client.put_game rand_gid, board, turn
    exp_res = { success: true }

    begin
      assert_equal exp_res, res, 'Put game response not success'
      gids.each do |gid|
        game = @client.get_game gid
        if gid.equal?rand_gid
          assert_equal board.to_s, game[:board].to_s, 'the board must be the same as the board put into the db'
        else
          assert_equal @tdbh.boards[gid].to_s, game[:board].to_s, 'other boards must not have changed'
        end
      end
    end

  end
end
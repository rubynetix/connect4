require_relative 'handler_test_helper'
require_relative '../client/models/game_board'
require_relative '../server/server'
require_relative '../server/user_handler'
require_relative '../server/server_error'
require_relative 'mock/mock_db'


class UserHandlerTest < HandlerTestHelper
  TEST_ITER = 10

  class Empty
    def count
      0
    end
  end

  def setup; end

  def teardown; end

  def test_user_create_new_user
    new_user = 'newuser'
    db = MockDB.new([],[],[{:username => new_user}])
    handler = UserHandler.new(:db_client => db)

    # Preconditions
    begin
    end

    res = handler.create(new_user)

    # Postconditions
    begin
      assert_true(res[:success])
    end
  end

  def test_user_create_existing_user
    existing_user = 'already_exists'
    db = MockDB.one_result({ :username => existing_user })
    handler = UserHandler.new(:db_client => db)

    # Preconditions
    begin
      users = db.query("SELECT * from users;")
      assert_equal(1, users.count)
      assert_equal(users[0][:username], existing_user)
    end

    res = handler.create(existing_user)

    # Postconditions
    begin
      assert_res_exception(res, DuplicateUsers)
    end
  end

  def test_user_create_bad_user
    bad_user = 'add?meplz'
    db = MockDB.no_result
    handler = UserHandler.new(:db_client => db)

    # Preconditions
    begin
    end

    res = handler.create(bad_user)

    # Postconditions
    begin
      assert_res_exception(res, InvalidUsername)
    end
  end

  def test_user_games
    name = 'tester'
    games = [1, 2, 3]
    db = MockDB.new(['tester'], [
        {:game_id => 1, game_type: 'connect4' },
        {:game_id => 2, game_type: 'connect4' },
        {:game_id => 3, game_type: 'toototto'}])
    handler = UserHandler.new(:db_client => db)

    # Preconditions
    begin
    end

    result = handler.games(name)

    # Postconditions
    begin
      gids = result[:games].map { |g| g[:game_id] }
      assert_equal(games, gids, 'result not equal to games')
    end
  end

  def test_user_list
    user_list = %w[tester john kanye]
    db = MockDB.new([{ :username => 'tester' }, { :username => 'john' }, { :username => 'kanye' }])
    handler = UserHandler.new(:db_client => db)
    # Preconditions
    begin
    end

    result = handler.list

    # Postconditions
    begin
      assert_equal(user_list, result[:list], 'result not equal to user_list')
    end
  end

  def test_league_standings
    name = 'kanye'
    expected_wins = 1
    expected_losses = 500
    expected_draws = 0
    expected = {'Wins'=> "#{expected_wins}", 'Losses'=> "#{expected_losses}", 'Draws'=> "#{expected_draws}"}
    db = MockDB.one_result(expected)
    handler = LeagueHandler.new(:db_client => db)

    # Preconditions
    begin
    end

    result = handler.standings name
    wins = result['Wins'].to_i
    losses = result['Losses'].to_i
    draws = result['Draws'].to_i
    # Postconditions
    begin
      assert_equal(expected_wins, wins)
      assert_equal(expected_losses, losses)
      assert_equal(expected_draws, draws)
    end

    db2 = MockDB.new Empty.new
    handler2 = LeagueHandler.new(:db_client => db2)

    assert_raise UserDoesNotExist do
      handler2.standings (name + 'e')
    end
  end

  def test_league_league
    name = 'kanye'
    expected_result = {:league => [nil]}
    db = MockDB.one_result(nil)
    handler = LeagueHandler.new(:db_client => db)

    # Preconditions
    begin
    end

    result = handler.league
    # Postconditions
    begin
      assert_equal(expected_result, result)
    end
  end
end

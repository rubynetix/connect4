require 'test/unit'
require_relative '../lib/server/server'
require_relative '../lib/models/game_board'

class ServerTest < Test::Unit::TestCase
  TEST_ITER = 10

  def setup
    @server = XMLRPC::Client.new('localhost', '/', 8080)
  end

  def teardown; end

  def tst_user_create
    name_success = 'doesnt_exist'
    name_failed = 'already_exists'
    # Preconditions
    begin
      # TODO: Assert name_failed is in DB
    end

    result_success = @server.call("user.create", name_success)

    result_failed = @server.call("user.create", name_failed)

    # Postconditions
    begin
      # TODO: Assert name_success in db
      # TODO: Assert name_failed in db
      assert('success', result_success, "Result not equal to 'success'")
      assert('failed', result_failed, "Result not equal to 'failed'")
    end
  end

  def tst_user_games
    name = 'tester'
    games = ['game1', 'second_game']
    # Preconditions
    begin
      # TODO: assert that name is in the db
      # TODO: assert that name's games are in the db
    end

    result = @server.call('user.games', name)

    # Postconditions
    begin
      assert_equal(games, result, 'result not equal to games')
    end
  end

  def test_user_list
    user_list = %w[tester john kanye]
    # Preconditions
    begin
      # TODO: assert user_list is in db
    end

    result = @server.call('user.list')

    # Postconditions
    begin
      assert_equal(user_list, result, 'result not equal to user_list')
    end
  end

  def tst_game_create
    username1 = 'john'
    username2 = 'kanye'
    # Preconditions
    begin
      # TODO: assert than username 1 and 2 are in db
    end

    result = @server.call('game.create', username1, username2)

    # Postconditions
    begin
      assert_true(result.is_a?(Integer), 'result is not an integer')
    end
  end

  def tst_game_get
    game_id = 12345
    # TODO: make these match the game saved in db
    game_board = GameBoard.new
    player_turn = 1
    game_state = 1
    # Preconditions
    begin
      # TODO: assert a game with id 12345 is in the db
    end

    result = @server.call('game.get', game_id)

    # Postconditions
    begin
      assert_equal(game_board, result['game_board'])
      assert_equal(player_turn, result['player_turn'])
      assert_equal(game_state_enum, result['game_state'])
    end
  end

  def tst_game_put
    game_id = 6789
    game_board = GameBoard.new
    player_turn = 1
    other_turn = 2
    # Preconditions
    begin
      # TODO: assert that there is a game with id 6789 in db
    end

    result = @server.call('game.put', game_id, game_board, player_turn)

    # Postconditions
    begin
      # TODO: assert that game_board is in the db as id 6789
      # TODO: assert that game 6789 is on other_turn
    end
  end

  def tst_league_standings
    name = 'kanye'
    standings = 1 # TODO: update this with actual standings
    # Preconditions
    begin
    end

    result = @server.call('league.standings', name)

    # Postconditions
    begin
      # TODO: assert that standings match
    end
  end

end
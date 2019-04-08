require 'uuid'
require_relative 'handler_test_helper'
require_relative '../server/game_handler'
require_relative '../client/models/game_board'
require_relative 'mock/mock_db'

class GameHandlerTest < HandlerTestHelper

  def initialize(*args)
    super(*args)
    @uuid = UUID.new
  end

  def setup
    @u1 = 'john'
    @u2 = 'kanye'
  end

  def users
    db_users(@u1, @u2)
  end

  def one_game_create_test(db, p1, p2, type, gb)
    handler = GameHandler.new(:db_client => db)

    # Preconditions
    begin
    end

    handler.create(p1, p2, type, gb)
  end

  def test_game_create_no_user
    db = MockDB.no_result

    res = one_game_create_test(db, @u1, @u2, 'c', GameBoard.connect4)

    # Postconditions
    begin
      assert_res_exception(res, UserDoesNotExist)
    end
  end

  def test_game_create_self_game
    db = MockDB.one_result({ username: @u1 })
    res = one_game_create_test(db, @u1, @u1, 'c', GameBoard.connect4)

    # Postconditions
    begin
      assert_res_exception(res, ArgumentError)
    end
  end

  def test_game_create_active_game
    db = MockDB.new(*users, [{ game_id: 'something' }])

    res = one_game_create_test(db, @u1, @u2, 'c', GameBoard.connect4)

    # Postconditions
    begin
      assert_res_exception(res, GameAlreadyInProgress)
    end
  end

  def test_game_create
    db = MockDB.new(*users, [])

    res = one_game_create_test(db, @u1, @u2, 'c', GameBoard.connect4)

    # Postconditions
    begin
      assert_uuid(res[:game_id])
    end
  end

  def test_game_get
    game_id = @uuid.generate
    game_board = GameBoard.connect4
    player_turn = @u1

    db = MockDB.one_result({
       game_id: game_id,
       state: 'active',
       turn: player_turn,
       board: game_board
     })

    handler = GameHandler.new(:db_client => db)

    # Preconditions
    begin
      assert_uuid(game_id)
    end

    res = handler.get(game_id)

    # Postconditions
    begin
      assert_uuid(res[:game_id])
      assert_equal(game_board, res[:board])
      assert_equal(player_turn, res[:turn])
      assert_equal('active', res[:state])
    end
  end
end

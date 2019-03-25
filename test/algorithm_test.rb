# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/models/game_board'
require_relative '../lib/models/counter'
require_relative '../lib/controllers/computer_player'
require_relative '../lib/controllers/algorithms/mcts'
require_relative '../lib/controllers/algorithms/alpha_beta_pruning'
require_relative '../lib/controllers/algorithms/random'

class GameBoardTest < Test::Unit::TestCase
  TEST_ITER = 100
  MIN_SIZE = 3
  MAX_SIZE = 10
  STRAT = [:AlphaBetaPruning]


  def empty_board
    GameBoard.connect4
  end

  def make_game
    if rand(0..1) > 0.5
      @near_win_squence = [YellowCounter.instance, YellowCounter.instance, YellowCounter.instance]
      @near_loss_squence = [RedCounter.instance, RedCounter.instance, RedCounter.instance]
      @my_tokens = [YellowCounter.instance]
      @op_tokens = [RedCounter.instance]
      @win_squence = "YYYY"
      return GameBoard.connect4
    end
    @near_win_squence = [OCounter.instance, OCounter.instance, TCounter.instance]
    @near_loss_squence = [TCounter.instance, TCounter.instance, OCounter.instance]
    @my_tokens = [TCounter.instance, OCounter.instance]
    @op_tokens = [TCounter.instance, OCounter.instance]
    @win_squence = "TOOT"
    GameBoard.toot_otto
  end


  def test_random
    TEST_ITER.times do
      board = make_game
      player = ComputerPlayer.new('p2',
                                  @my_tokens,
                                  "YYYY",
                                  @op_tokens).extend RandomAction

      possible_moves = board.possible_cols.dup

      token, move = player.get_move board

      # Postconditions
      begin
        assert_include possible_moves, move, 'Move must be in the set of possible moves'
      end
    end
  end


  def test_strat
    TEST_ITER.times do
      board = make_game
      player = ComputerPlayer.new('p2',
                                  @my_tokens,
                                  @win_squence,
                                  @op_tokens)

      player.algorithm = STRAT.sample

      starting_board = board.to_s.dup

      token, move = player.get_move board

      # Postconditions
      begin
        assert_equal board.to_s, starting_board, 'The board should not be modified.'
        assert_include board.possible_cols, move, 'Move must be in the set of possible moves.'
      end
    end
  end

  def test_alg_loss_col
    TEST_ITER.times do
      board = make_game
      rand_col = rand(0..board.cols-1)
      player = ComputerPlayer.new('p2',
                                  @my_tokens,
                                  @win_squence,
                                  @op_tokens)
      player.algorithm = STRAT.sample
      board.place(@near_loss_squence.pop, rand_col)
      board.place(@near_loss_squence.pop, rand_col)
      board.place(@near_loss_squence.pop, rand_col)

      assert_equal player.get_move(board)[1], rand_col

    end
  end

  def test_alg_win_precedence
    TEST_ITER.times do
      board = make_game
      rand_col = rand(0..board.cols-4)
      player = ComputerPlayer.new('p2',
                                  @my_tokens,
                                  @win_squence,
                                  @op_tokens)
      player.algorithm = STRAT.sample
      board.place(@near_loss_squence.pop, rand_col + 1)
      board.place(@near_loss_squence.pop, rand_col + 2)
      board.place(@near_loss_squence.pop, rand_col + 3)
      board.place(@near_win_squence.pop, rand_col)
      board.place(@near_win_squence.pop, rand_col)
      board.place(@near_win_squence.pop, rand_col)

      assert_equal player.get_move(board)[1], rand_col

    end
  end

end

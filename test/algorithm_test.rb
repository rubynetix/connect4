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

  def setup
    @default_counter = RedCounter.instance
  end

  def teardown;
  end

  def empty_board
    GameBoard.connect4
  end

  def place_rand(board, counters: (MIN_SIZE..MAX_SIZE))
    while counters > 0
      c = rand(0...board.cols)
      unless board.col_full?(c)
        board.place(@default_counter, c)
        counters -= 1
      end
    end
    board
  end


  def test_random
    TEST_ITER.times do
      board = empty_board
      player = ComputerPlayer.new('p2',
                                  [YellowCounter.instance],
                                  "YYYY",
                                  [RedCounter.instance]).extend RandomAction

      possible_moves = board.possible_cols.dup

      token, move = player.get_move board

      # Postconditions
      begin
        assert_include possible_moves, move, 'Move must be in the set of possible moves'
      end
    end
  end


  def tst_mcts
    TEST_ITER.times do
      board = empty_board
      player = ComputerPlayer.new('p2',
                                  [YellowCounter.instance],
                                  "YYYY",
                                  [RedCounter.instance]).extend MCTS

      starting_board = board.to_s.dup

      token, move = player.get_move board

      # Postconditions
      begin
        assert_equal board.to_s, starting_board, 'The board should not be modified.'
        assert_include board.possible_cols, move, 'Move must be in the set of possible moves.'
      end
    end
  end


  def test_alpha_beta_pruning
    TEST_ITER.times do
      board = empty_board
      player = ComputerPlayer.new('p2',
                                  [YellowCounter.instance],
                                  "YYYY",
                                  [RedCounter.instance]).extend AlphaBetaPruning

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
      board = empty_board
      rand_col = rand(0..board.cols-1)
      player = ComputerPlayer.new('p2',
                                  [YellowCounter.instance],
                                  "YYYY",
                                  [RedCounter.instance]).extend AlphaBetaPruning
      board.place(RedCounter.instance, rand_col)
      board.place(RedCounter.instance, rand_col)
      board.place(RedCounter.instance, rand_col)

      assert_equal player.get_move(board)[1], rand_col

    end
  end

  def test_alg_win_precedence
    TEST_ITER.times do
      board = empty_board
      rand_col = rand(0..board.cols - 4)
      player = ComputerPlayer.new('p2',
                                  [YellowCounter.instance],
                                  "YYYY",
                                  [RedCounter.instance]).extend AlphaBetaPruning
      board.place(RedCounter.instance, rand_col + 1)
      board.place(RedCounter.instance, rand_col + 2)
      board.place(RedCounter.instance, rand_col + 3)
      board.place(YellowCounter.instance, rand_col)
      board.place(YellowCounter.instance, rand_col)
      board.place(YellowCounter.instance, rand_col)

      assert_equal player.get_move(board)[1], rand_col

    end
  end

end

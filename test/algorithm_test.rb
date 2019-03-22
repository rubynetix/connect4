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

  def empty_board(size: rand(MIN_SIZE..MAX_SIZE))
    GameBoard.new(size)
  end

  def rand_board(size: rand(MIN_SIZE..MAX_SIZE), fill_factor: rand(1..100))
    board = empty_board(size: size)
    counters = ([fill_factor.abs.to_f, 1.0].min * board.size * board.size).floor

    while counters > 0
      c = rand(0...board.size)
      unless board.col_full?(c)
        board.place(@default_counter, c)
        counters -= 1
      end
    end

    board
  end


  def test_random
    TEST_ITER.times do
      board = rand_board(size: 5, fill_factor: 0.5)
      player = ComputerPlayer.new('name').extend RandomAction

      possible_moves = board.possible_moves.dup

      move = player.get_move board

      # Postconditions
      begin
        assert_include possible_moves, move, 'Move must be in the set of possible moves'
      end
    end
  end


  def tst_mcts
    TEST_ITER.times do
      board = rand_board(size: 5, fill_factor: 0.5)
      player = ComputerPlayer.new('name').extend MCTS

      possible_moves = board.possible_moves.dup

      move = player.get_move board

      # Postconditions
      begin
        assert_include possible_moves, move, 'Move must be in the set of possible moves'
      end
    end
  end


  def test_alpha_beta_pruning
    TEST_ITER.times do
      board = rand_board(size: 5, fill_factor: 0.5)
      player = ComputerPlayer.new('name').extend AlphaBetaPruning

      starting_board = board.to_s.dup
      puts 'Before:', board

      move = player.get_move board, RedCounter.instance
      puts 'After:', board

      # Postconditions
      begin
        assert_equal board.to_s, starting_board, 'The board should not be modified.'
        assert_include board.possible_moves, move, 'Move must be in the set of possible moves.'
      end
    end
  end
end

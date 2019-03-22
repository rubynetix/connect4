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

  def empty_board(rows: rand(MIN_SIZE..MAX_SIZE), cols: rand(MIN_SIZE..MAX_SIZE))
    GameBoard.new(rows, cols)
  end


  def test_random
    TEST_ITER.times do
      board = empty_board
      player = ComputerPlayer.new('name', RedCounter.instance).extend RandomAction

      possible_moves = board.possible_moves.dup

      move = player.get_move board

      # Postconditions
      begin
        assert_include possible_moves, move, 'Move must be in the set of possible moves'
      end
    end
  end


  def test_mcts
    TEST_ITER.times do
      board = empty_board
      player = ComputerPlayer.new('name', RedCounter.instance).extend AlphaBetaPruning

      starting_board = board.to_s.dup

      move = player.get_move board

      # Postconditions
      begin
        assert_equal board.to_s, starting_board, 'The board should not be modified.'
        assert_include board.possible_moves, move, 'Move must be in the set of possible moves.'
      end
    end
  end


  def test_alpha_beta_pruning
    TEST_ITER.times do
      board = empty_board
      player = ComputerPlayer.new('name', RedCounter.instance).extend AlphaBetaPruning

      starting_board = board.to_s.dup

      move = player.get_move board

      # Postconditions
      begin
        assert_equal board.to_s, starting_board, 'The board should not be modified.'
        assert_include board.possible_moves, move, 'Move must be in the set of possible moves.'
      end
    end
  end
end

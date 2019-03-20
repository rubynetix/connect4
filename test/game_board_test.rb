require 'test/unit'
require_relative '../lib/models/game_board'
require_relative '../lib/models/counter'

class GameBoardTest < Test::Unit::TestCase
  TEST_ITER = 10
  MIN_SIZE = 4
  MAX_SIZE = 10

  def setup; end

  def teardown; end

  def rand_empty_board
    raise NotImplementedError
  end

  def rand_board(size: rand(MIN_SIZE..MAX_SIZE))
    raise NotImplementedError
  end

  def test_smoke
    puts "Smoke test..."
    board = GameBoard.new(5)

    puts board.to_s

    board.place(YellowCounter, 1)

    puts board.to_s

    board.clear

    puts board.to_s

    puts "Ok"
  end

  def tst_clear
    TEST_ITER.times do
      board = rand_board

      # Preconditions
      begin
      end

      board.clear

      # Postconditions
      begin
        # All locations must be empty
        board.iter {|_, _, counter| assert_true(counter.nil?, "Game-board not cleared.")}
      end
    end
  end

  def tst_place
    TEST_ITER.times do
      board = rand_empty_board
      c = rand(0...board.size)
      counter = Counter.new("O", "../TODO/")

      # Preconditions
      begin
        assert_true(c >= 0)
        assert_true(c < board.size)
      end

      board.place(counter, c)

      # Postconditions
      begin
        # Assert that piece has been placed correctly
        assert_equal(board.at(board.size, c), counter)
      end
    end
  end

  def tst_map
    TEST_ITER.times do
      board = rand_board

      # Preconditions
      begin
      end

      board.map {|_, _, _| nil}

      # Postconditions
      begin
        # Check that all counters have been set to nil
        board.iter {|_, _, counter| assert_equal(counter, nil)}
      end
    end
  end
end

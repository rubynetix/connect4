require 'test/unit'
require_relative '../lib/models/game_board'
require_relative '../lib/models/counter'

class GameBoardTest < Test::Unit::TestCase
  TEST_ITER = 100
  MIN_SIZE = 3
  MAX_SIZE = 10

  def setup;
    @default_counter = RedCounter.instance
  end

  def teardown;
  end

  def empty_board(rows: rand(MIN_SIZE..MAX_SIZE), cols: rand(MIN_SIZE..MAX_SIZE))
    GameBoard.new(rows, cols)
  end

  def rand_board(rows: rand(MIN_SIZE..MAX_SIZE), cols: rand(MIN_SIZE..MAX_SIZE), fill_factor: rand(1..100))
    board = empty_board(rows: rows, cols: cols)
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

  def test_clear
    TEST_ITER.times do
      board = rand_board(fill_factor: 0.5)

      # Preconditions
      begin
      end

      board.clear

      # Postconditions
      begin
        # All locations must be empty
        board.iter {|_, _, counter| assert_true(counter == EmptyCounter.instance, "Game-board not cleared.")}
      end
    end
  end

  def test_place_non_full
    TEST_ITER.times do
      board = rand_board(fill_factor: 0.5)
      c = rand(0...board.cols)

      # Find a non-full column for this test
      c = rand(0...board.cols) while board.col_full?(c)
      height_og = board.send(:row, c)

      # Preconditions
      begin
        assert_true(c >= 0)
        assert_true(c < board.cols)
        assert_false(board.col_full?(c))
      end

      board.place(@default_counter, c)

      # Postconditions
      begin
        height_new = board.send(:row, c)

        unless board.col_full?(c)
          assert_true(height_new < height_og || board.col_full?(c), "Column height")
          assert_equal(board.send(:at, height_og, c), @default_counter)
        end
      end
    end
  end

  def test_place_full
    TEST_ITER.times do
      board = rand_board(fill_factor: 1.0)
      c = rand(0...board.cols)

      # Preconditions
      begin
        assert_true(c >= 0)
        assert_true(c < board.cols)
      end

      # Cannot place counter if the board is full
      assert_raise ColumnFullError do
        board.place(@default_counter, c)
      end

      # Postconditions
      begin
      end
    end
  end
end

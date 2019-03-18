require 'test/unit'

class GameBoardTest < Test::Unit::TestCase
  TEST_ITER = 10
  MIN_SIZE = 4
  MAX_SIZE = 10

  def setup; end

  def teardown; end

  def rand_board(size: rand(MIN_SIZE..MAX_SIZE))
    raise NotImplementedError
  end

  def tst_clear
    TEST_ITER.times do
      board = rand_board

      # Preconditions
      begin
        board.instance_of?(GameBoard)
      end

      # Postconditions
      begin
        board.iter {|_, _, counter| assert_true(counter.nil?, "Game-board not cleared.")}
      end
    end
  end

  def tst_place
    TEST_ITER.times do
      board = rand_board
      c = rand(0...board.size)

      # Preconditions
      begin
      end

      # Postconditions
      begin
      end
    end
  end

  def tst_map
    TEST_ITER.times do
      # Preconditions
      begin
      end

      # Postconditions
      begin
      end
    end
  end

  def tst_iter
    TEST_ITER.times do
      # Preconditions
      begin
      end

      # Postconditions
      begin
      end
    end
  end
end

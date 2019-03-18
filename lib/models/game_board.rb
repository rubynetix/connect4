class GameBoard
  INVALID_ROW = -1

  def initialize(size)
    @size = size
    @board = Array.new(@size, Array.new(@size, nil))
  end

  def place(counter, col)
    # Preconditions
    raise InvalidColumnError if col < 0 || col > @size
    raise ColumnFullError if row(col) == INVALID_ROW

    @board[row(col)][col] = counter
  end

  def clear
    # Preconditions
    # None
    map {|_, _, _| nil}
  end

  def map
    # Preconditions
    # None
    iter do |r, c, counter|
      @board[r][c] = yield(r, c, counter)
    end

    # Postconditions
    # TODO
  end

  def iter
    # Preconditions
    # None
    @board.each do |r|
      r.each do |c|
        yield(r, c, @board[r][c])
      end
    end

    # Postconditions
    # - all elements should be unchanged
  end

  private

  def row(col)
    height = INVALID_ROW
    iter do |r, c, counter|
      if c == col && counter.nil?
        height = [height, r].max
      end
    end

    height
  end
end

class ColumnFullError < StandardError; end
class InvalidColumnError < StandardError; end

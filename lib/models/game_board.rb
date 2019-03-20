require_relative '../../lib/models/counter'

class GameBoard
  INVALID_ROW = -1

  def initialize(size)
    @size = size
    @board = Array.new(@size) {Array.new(@size, EmptyCounter)}
  end

  def place(counter, col)
    raise InvalidColumnError unless col >= 0 && col < @size
    raise ColumnFullError if col_full?(col)

    @board[row(col)][col] = counter
  end

  def clear
    map {|_, _, _| EmptyCounter}
  end

  def map
    iter {|r, c, counter| @board[r][c] = yield(r, c, counter)}
  end

  def iter
    @board.each_with_index do |arr, r|
      arr.each_with_index {|counter, c| yield(r, c, counter)}
    end
  end

  # Useful for testing only
  def at(r, c)
    @board[r][c]
  end

  def to_s
    s = ''
    @board.each do |r|
      r.each {|c| s += "| #{c} "}
      s += "|\n"
    end
    s
  end

  private

  def col_full?(col)
    row(col) == INVALID_ROW
  end

  # Get the row the counter will fall to if placed in column col
  def row(col)
    height = INVALID_ROW
    iter do |r, c, counter|
      if c == col && counter == EmptyCounter
        height = [height, r].max
      end
    end

    height
  end
end

class ColumnFullError < StandardError; end
class InvalidColumnError < StandardError; end

require_relative '../../lib/models/counter'

class GameBoard
  INVALID_ROW = -1

  attr_accessor :size

  def initialize(size, board = nil)
    @size = size
    @board = if board.nil?
               Array.new(@size) {Array.new(@size, EmptyCounter.instance)}
             else
               board
             end
  end

  def initialize_copy(orig)

    self.class.new @size.dup, @board.dup

  end




  def remove(col)
    raise InvalidColumnError unless col >= 0 && col < @size
    row = row(col)
    row = @size unless row.positive?

    puts 'Col: ', col, 'Row: ', row - 1
    @board[row - 1][col] = EmptyCounter.instance
  end

  def place(counter, col)
    raise InvalidColumnError unless col >= 0 && col < @size
    raise ColumnFullError if col_full?(col)

    @board[row(col)][col] = counter
  end

  def clear
    map {|_, _, _| EmptyCounter.instance}
  end

  def col_full?(col)
    row(col) == INVALID_ROW
  end

  def possible_moves
    moves = []
    (0..@size - 1).each {|col| moves.push(col) unless col_full? col}
    moves
  end

  def ended?
    return true if possible_moves.size.zero?

    false
  end

  def winner?
    #
  end

  def map
    iter {|r, c, counter| @board[r][c] = yield(r, c, counter)}
  end

  def iter
    @board.each_with_index do |arr, r|
      arr.each_with_index {|counter, c| yield(r, c, counter)}
    end
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

  # Get the row the counter will fall to if placed in column col
  def row(col)
    height = INVALID_ROW
    iter do |r, c, counter|
      if c == col && counter == EmptyCounter.instance
        height = [height, r].max
      end
    end
    height
  end

  # For testing only
  def at(r, c)
    @board[r][c]
  end
end

class ColumnFullError < StandardError;
end
class InvalidColumnError < StandardError;
end

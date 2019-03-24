require_relative '../../lib/models/counter'

class GameBoard
  INVALID_ROW = -1

  attr_accessor :rows, :cols
  attr_reader :last_counter_pos

  class << self
      def connect4
        GameBoard.new
      end

      def toot_otto
        GameBoard.new(rows: 6, cols: 6)
      end
  end

  def initialize(rows = 6, cols = 7)
    @rows = rows
    @cols = cols
    @board = Array.new(@rows) {Array.new(@cols, EmptyCounter.instance)}
    @last_counter_pos = nil
  end

  def place(counter, col)
    raise InvalidColumnError unless col >= 0 && col < @cols
    raise ColumnFullError if col_full?(col)

    row = row(col)
    @board[row][col] = counter
    @last_counter_pos = [row, col]
  end

  def clear
    map {|_, _, _| EmptyCounter.instance}
  end

  def col_full?(col)
    row(col) == INVALID_ROW
  end

  def full?
    (0...@cols).each do |col|
      if row(col) != INVALID_ROW
        return false
      end
    end
    true
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

  def at(r, c)
    @board[r][c]
  end

  def get_row(r)
    @board[r]
  end

  def get_col(c)
    col = []
    @board.each do |r|
      col.push(r[c])
    end
    col
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

end

class ColumnFullError < StandardError; end
class InvalidColumnError < StandardError; end

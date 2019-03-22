require_relative '../../lib/models/counter'

class GameBoard
  INVALID_ROW = -1

  attr_accessor :rows, :cols

  def initialize(rows = 6, cols = 7)
    @rows = rows
    @cols = cols
    @board = Array.new(@rows) {Array.new(@cols, EmptyCounter.instance)}
  end

  def place(counter, col)
    raise InvalidColumnError unless col >= 0 && col < @cols
    raise ColumnFullError if col_full?(col)

    @board[row(col)][col] = counter
  end

  def clear
    map {|_, _, _| EmptyCounter.instance}
  end

  def col_full?(col)
    row(col) == INVALID_ROW
  end

  def map
    iter {|r, c, counter| @board[r][c] = yield(r, c, counter)}
  end

  def iter
    @board.each_with_index do |arr, r|
      arr.each_with_index {|counter, c| yield(r, c, counter)}
    end
  end

  # def rows
  #   @board.each do |r|
  #     yield r
  #   end
  # end

  # def cols
  #   (0...@size).each do |c|
  #     col = []
  #     (0...@size).each do |r|
  #       col.append(@board[r][c])
  #     end
  #     yield col
  #   end
  # end

  # def left_diags
  #   (0...2*@size-1).each do |d|
  #     diag = []
  #     r_top = [0, d - @size + 1].max
  #     r_bot = [d, @size - 1].min
  #     (r_top..r_bot).each do |r|
  #       diag.append(@board[r][d - r])
  #     end
  #     yield diag
  #   end
  # end
  
  # def right_diags
  #   (0...2*@size-1).each do |d|
  #     diag = []
  #     r_top = [0, d - @size + 1].max
  #     r_bot = [d, @size - 1].min
  #     r_bot.downto(r_top).each {|r| diag.append(@board[r][d - r])}
  #     yield diag
  #   end
  # end

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

class ColumnFullError < StandardError; end
class InvalidColumnError < StandardError; end

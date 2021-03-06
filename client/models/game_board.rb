require_relative '../models/counter'
require_relative '../models/win_check'

class GameBoard
  INVALID_ROW = -1

  attr_accessor :rows, :cols, :board
  attr_accessor :last_counter_pos, :win_check

  class << self
    def connect4
      GameBoard.new
    end

    def toot_otto
      GameBoard.new(rows: 4, cols: 6, win_check: WinCheck.toot_otto)
    end
  end

  def initialize(rows: 6, cols: 7, board: nil, win_check: WinCheck.connect4, last_move: [-1,-1])
    @rows = rows
    @cols = cols
    @board = board || Array.new(@rows) {Array.new(@cols, EmptyCounter.instance)}
    @last_counter_pos = last_move
    @win_check = win_check
  end

  def dup(*)
    initialize_copy
  end

  def initialize_copy(*)

    board = Array.new(@rows) {Array.new(@cols, EmptyCounter.instance)}
    iter {|r, c, counter| board[r][c] = counter}
    self.class.new rows: @rows.dup, cols: @cols.dup, board: board.dup,
                   last_move: @last_counter_pos.dup, win_check: @win_check.dup

  end

  def last_counter_pos?
    last_counter_pos == [-1, -1]
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
    self
  end

  def col_full?(col)
    row(col) == INVALID_ROW
  end

  def possible_cols
    moves = []
    (0..@cols - 1).each {|col| moves.push(col) unless col_full? col}
    moves
  end


  def check
    @win_check.check self
  end

  def over?
    full? || (check != WinEnum::NEUTRAL)
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

  def _dump level
    s = [@rows, @cols].join(':') + "$"
    @board.each do |r|
      r.each do |c|
        s += "#{c}"
      end
      s += ":"
    end
    s
  end

  def self._load args
    params, board_str = args.split("$")
    rows, cols = params.split(":")

    board = board_str.split(':')
    board = board.map do |row_str|
      row = []
      row_str.each_char do |c|
        row.append(CounterUtil::symbol_to_counter(c))
      end
      row
    end

    new(rows: rows.to_i, cols: cols.to_i, board: board)
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

class ColumnFullError < StandardError;
end
class InvalidColumnError < StandardError;
end

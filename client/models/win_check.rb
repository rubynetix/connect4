require 'singleton'

module WinEnum
  NEUTRAL = 0
  WIN1 = 1
  WIN2 = 2
  DRAW = 3
end

class WinCheck

  class << self
    def connect4
      WinCheck.new("RRRR", "YYYY")
    end

    def toot_otto
      WinCheck.new("TOOT", "OTTO")
    end
  end

  def initialize(win_string1, win_string2)
    @win1_string = win_string1
    @win2_string = win_string2
  end

  def wins
    [@win1_string, @win2_string]
  end

  def winner?(board, playerString)
    win1, win2 = check_for_wins(board)
    return win1 if @win1_string == playerString
    win2
  end

  def check_for_wins(board)
    win1 = false
    win2 = false

    create_strings(board).each do |string|
      win1 = (win1 or string.include? @win1_string)
      win2 = (win2 or string.include? @win2_string)
    end

    [win1, win2]
  end


  def check(board)
    if board.last_counter_pos?
      return WinEnum::NEUTRAL
    end

    win1, win2 = check_for_wins(board)

    if (win1 and win2) or board.full?
      result = WinEnum::DRAW
    elsif win1
      result = WinEnum::WIN1
    elsif win2
      result = WinEnum::WIN2
    else
      result = WinEnum::NEUTRAL
    end

    result
  end

  private

  def create_strings(board)
    strings = []

    row = board.last_counter_pos[0]
    col = board.last_counter_pos[1]

    strings.push(row_string(board, row))
    strings.push(vert_string(board, col))
    strings.push(right_diag_string(board, row, col))
    strings.push(left_diag_string(board, row, col))

    strings
  end

  def row_string(board, row)
    s = ''
    board.get_row(row).each {|c| s += "#{c}"}
    s
  end

  def vert_string(board, col)
    s = ''
    board.get_col(col).each {|c| s += "#{c}"}
    s
  end

  def right_diag_string(board, row, col)
    s = ''
    current_row = row - [row, col].min
    current_col = col - [row, col].min

    while current_row < board.rows and current_col < board.cols
      s += "#{board.at(current_row, current_col)}"
      current_row += 1
      current_col += 1
    end
    s
  end

  def left_diag_string(board, row, col)
    s = ''
    current_row = [board.rows - 1, row + col].min
    current_col = (row + col) - current_row

    while current_row >= 0 and current_col < board.cols
      s += "#{board.at(current_row, current_col)}"
      current_row -= 1
      current_col += 1
    end
    s
  end

end
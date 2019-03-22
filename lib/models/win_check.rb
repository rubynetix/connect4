require 'singleton'

module WinEnum
  NEUTRAL = 0
  OTTO_WIN = 1
  TOOT_WIN = 2
  DRAW = 3
end

class WinCheck

  def initialize(substring1, substring2)
    @win1_substring = substring1
    @win2_substring = substring2
  end


  def check_win(row, column, board)
    win1 = false
    win2 = false

    create_strings(row, column, board).each do | string |
      win1 = win1 or string.include? @win1_substring
      win2 = win2 or string.include? @win2_substring
    end

    if win1 and win2 #or board.full?
      result = WinEnum::DRAW
    elsif win1
      result = WinEnum::WIN1
    elsif win2
      result = WinEnum::WIN2
    else
      result = WinEnum::NEUTRAL
    end

    return result
  end

  private

  def create_strings(row, column, board)
    return []
  end

end
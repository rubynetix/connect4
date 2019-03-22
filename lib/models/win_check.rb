require 'singleton'

module WinEnum
  NEUTRAL = 0
  WIN1 = 1
  WIN2 = 2
  DRAW = 3
end

class WinCheck

  def initialize(win_string1, win_string2)
    @win1_string = win_string1
    @win2_string = win_string2
  end


  def check(board, position)
    win1 = false
    win2 = false

    create_strings(board, position).each do | string |
      win1 = win1 or string.include? @win1_string
      win2 = win2 or string.include? @win2_string
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

  def create_strings(board, position)
    row = position[0]
    col = position[1]
    return []
  end

end
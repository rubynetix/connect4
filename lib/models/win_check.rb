# frozen_string_literal: true

require 'singleton'

module WinEnum
  NEUTRAL = 0
  WIN1 = 1
  WIN2 = 2
  DRAW = 3
end

class WinCheck
  def initialize(win_string1, win_string2)
    @win_strings = [win_string1, win_string2]
    @win1_string = win_string1
    @win2_string = win_string2
  end

  def check(board)
    winners = []

    create_strings(board).each do |string|
      @win_strings.each do |player|
        winners.push(player) if string.include? player
      end
    end

    result = if winners.size > 1
               WinEnum::DRAW
             elsif winners.size.zero? # or board.full?
               WinEnum::NEUTRAL
             elsif winners[0] == @win1_string
               WinEnum::WIN1
             else
               WinEnum::WIN2
             end

    result
  end

  private

  def col_string(board, x, y1, y2)
    s = ''
    (y1..y2).each { |y| s += board.at(x, y) }
    s
  end

  def row_string(board, y, x1, x2)
    s = ''
    (x1..x2).each { |x| s += board.at(x, y) }
    s
  end

  def dia_string(board, min_x, center_x, max_x, max_y, xy_diff)
    up = ''
    (min_x..center_x).each { |x| up += board.at(x, x - xy_diff) if x - xy_diff >= 0 }
    (center_x + 1..max_x).each { |x| up += board.at(x, x - xy_diff) if x - xy_diff <= max_y }
    down = ''
    (min_x..center_x).each do |x|
      y = center_x * 2 - x - xy_diff
      down += board.at(x, y) if y >= 0
    end
    (center_x + 1..max_x).each do |x|
      y = center_x * 2 - x - xy_diff
      down += board.at(x, y) if y <= max_y
    end
    [up, down]
  end

  def create_strings(board)
    x, y = board.last_counter_pos

    max_offset = @win_strings.map(&:size).max
    min_x = [x - max_offset, 0].max
    min_y = [y - max_offset, 0].max
    max_x = [x + max_offset, board.rows].max
    max_y = [y + max_offset, board.cols].max

    possible_win_area = []
    possible_win_area.push(col_string(board, x, min_y, max_y))
    possible_win_area.push(row_string(board, y, min_x, max_x))
    dia_string(board, min_x, x, max_x, max_y, x - y).each do |string|
      possible_win_area.push(string)
    end
    possible_win_area
  end
end

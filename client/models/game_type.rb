require 'singleton'
require_relative 'counter'
require_relative 'win_check'

module GameType

  def id
    self.class.class_variable_get(:@@id)
  end

  def name
    self.class.class_variable_get(:@@name)
  end

  def p1_counters
    self.class.class_variable_get(:@@p1_counters)
  end

  def p2_counters
    self.class.class_variable_get(:@@p2_counters)
  end

  def win_check
    self.class.class_variable_get(:@@win_check)
  end

  def p1_win
    win_check.wins[0]
  end

  def p2_win
    win_check.wins[1]
  end

end

class Connect4GameType
  include Singleton
  include GameType

  @@id = 'connect4'
  @@name = 'Connect 4'
  @@p1_counters = [RedCounter.instance]
  @@p2_counters = [YellowCounter.instance]
  @@win_check = WinCheck.connect4

  def new_board
    GameBoard.connect4
  end
end

class TootOttoGameType
  include Singleton
  include GameType

  @@id = 'toototto'
  @@name = 'TOOT OTTO'
  @@p1_counters = [TCounter.instance, OCounter.instance]
  @@p2_counters = [TCounter.instance, OCounter.instance]
  @@win_check = WinCheck.toot_otto

  def new_board
    GameBoard.toot_otto
  end
end

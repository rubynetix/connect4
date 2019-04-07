# Base class for a UI Event
class UIEvent
  attr_reader :id

  COUNTER_SELECTED = 1
  MENU_CLICK = 2
  CELL_CLICK = 3
  FORFEIT_CLICK = 4
  WINDOW_CHANGE = 5
  SERVER_CONN = 6
  LIST_USER_GAMES = 7
  LIST_LEAGUE_STATS = 8

  def initialize(id)
    @id = id
  end
end
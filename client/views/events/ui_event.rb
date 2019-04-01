# Base class for a UI Event
class UIEvent

  attr_reader :id

  COUNTER_SELECTED = 1
  MENU_CLICK = 2
  CELL_CLICK = 3
  FORFEIT_CLICK = 4
  WINDOW_CHANGE = 5

  def initialize(id)
    @id = id
  end
end
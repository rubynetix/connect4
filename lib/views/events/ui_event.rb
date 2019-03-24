# Base class for a UI Event
class UIEvent

  attr_reader :id

  COUNTER_SELECTED = 1
  MENU_CLICKED = 2

  def initialize(id)
    @id = id
  end
end
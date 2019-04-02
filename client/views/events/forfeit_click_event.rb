require_relative 'ui_event'

# Event for when the forfeit button is clicked
class ForfeitClickEvent < UIEvent
  def initialize
    super UIEvent::FORFEIT_CLICK
  end
end

require_relative '../../views/events/ui_event'

class WindowChangeEvent < UIEvent
  attr_reader :new_wid

  def initialize(wid)
    super UIEvent::WINDOW_CHANGE
    @new_wid = wid
  end
end

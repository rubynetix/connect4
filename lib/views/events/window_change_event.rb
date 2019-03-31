require_relative '../../views/events/ui_event'

class WindowChangeEvent < UIEvent
  attr_reader :wid

  def initialize(wid)
    super UIEvent::WINDOW_CHANGE
    @wid = wid
  end
end

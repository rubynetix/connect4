require_relative '../../views/events/ui_event'

class WindowChangeEvent < UIEvent
  attr_reader :to_wid, :from_wid

  def initialize(to_wid, from_wid)
    super UIEvent::WINDOW_CHANGE
    @to_wid = to_wid
    @from_wid = from_wid
  end
end

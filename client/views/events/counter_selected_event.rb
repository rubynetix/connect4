require_relative 'ui_event'

class CounterSelectedEvent < UIEvent

  attr_accessor :index

  def initialize(index)
    super UIEvent::COUNTER_SELECTED
    @index = index
  end

end
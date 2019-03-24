require_relative 'ui_event'

class CounterSelectedEvent < UIEvent

  attr_accessor :counter

  def initialize(counter)
    super UIEvent::COUNTER_SELECTED
    @counter = counter
  end

end
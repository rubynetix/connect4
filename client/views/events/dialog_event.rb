require_relative 'ui_event'

class DialogEvent < UIEvent
  attr_reader :msg

  def initialize(msg, msg_type=UIEvent::MSG_HELP)
    super(msg_type)
    @msg = msg
  end
end

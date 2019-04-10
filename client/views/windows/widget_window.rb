require_relative '../events/ui_event'
require_relative '../events/dialog_event'

module WidgetWindow
  def id
    self.class.class_variable_get(:@@wid)
  end

  # Override in windows that need to prepare before
  # being displayed in the application window stack
  def prepare; end

  # Hook to provide window specific help
  def window_help
    "Help is not available for this window."
  end

  def display_help
    notify_all(DialogEvent.new(window_help, UIEvent::MSG_HELP))
  end

  def display_error(msg: "Something went wrong!")
    notify_all(DialogEvent.new(msg, UIEvent::MSG_HELP))
  end
end
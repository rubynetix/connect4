module WidgetWindow
  def id
    self.class.class_variable_get(:@@wid)
  end

  # Override in windows that need to prepare before
  # being displayed in the application window stack
  def display; end

  def display_error(title: "Error", msg: "Request could not be completed.")
    # TODO: Generic error dialog
  end
end
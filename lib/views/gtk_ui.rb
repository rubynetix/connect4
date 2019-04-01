require_relative 'observable'

# Wrapper class that knows about the GTK windows involved
# in the presenting the application and presents a UI
# interface consistent with our previous UI class' interface
class GtkUI
  include PassthroughObservable

  def initialize(app)
    @app = app

    # Listen for any events in the GTK application and bubble
    # them up the observable chain to listening controllers
    @app.register(self)
  end

  def method_missing(m, *args, &block)
    @app.ui.active_window.send(m, *args, &block)
  end

  def shutdown
    @app.unregister(self)
  end
end

require_relative '../../../lib/views/observable'

module C4
  class MainWindow < Gtk::ApplicationWindow
    include PassthroughObservable

    attr_reader :active_window

    type_register

    class << self
      def init
        # Bind the associated resource file (i.e. gresource-prefix + resource-path-name)
        set_template(:resource => "/com/rubynetix/connect4/ui/main_window.ui")

        bind_template_child("window_stack")
      end
    end

    def initialize(application, active_wid, windows = [])
      super application: application
      set_title 'Rubynetix Games'

      @window_stack = window_stack
      @active_window = nil

      windows.each(&method(:add_window))
      display_window(active_wid)
    end

    # Load an observable window
    def add_window(window)
      window.register(self)
      wid = window.class.class_variable_get(:@@WID)
      @window_stack.add_named(window, wid)
    end

    def display_window(wid)
      window = @window_stack.get_child_by_name(wid)

      if window.nil?
        raise StandardError("WINDOW NOT FOUND!")
        return
      end

      @window_stack.set_visible_child(window)
      @active_window = window
      window.display
    end

    def notify(event)
      # Pass the event along unless it's a window change event
      if event.id != UIEvent::WINDOW_CHANGE
        notify_all(event)
        return
      end

      display_window(event.new_wid)
    end
  end
end
require_relative '../../../lib/views/observable'

module C4
  class StackWindow < Gtk::ApplicationWindow
    include PassthroughObservable

    type_register

    class << self
      def init
        # Bind the associated resource file (i.e. gresource-prefix + resource-path-name)
        set_template(:resource => "/com/rubynetix/connect4/ui/stack_window.ui")

        bind_template_child("window_stack")
      end
    end

    def initialize(application, windows = [])
      super application: application
      set_title 'STACK @ Rubynetix'

      @window_stack = window_stack

      windows.each(&method(:add_window))
    end

    # Load an observable window
    def add_window(window)
      window.register(self)
      wid = window.class.class_variable_get(:@@WID)
      @window_stack.add_named(window, wid)
    end

    def display_window(wid)
      @window_stack.set_visible_child_name(wid)
    end

    def notify(event)
      # Only interested in window change events
      return if event.id != UIEvent::WINDOW_CHANGE

      puts "RESPONDING by showing #{event.new_wid}"
      display_window(event.new_wid)
    end
  end
end

require_relative '../../../client/views/observable'

module C4
  class AppWindow < Gtk::ApplicationWindow
    include Observable

    attr_reader :active_window

    type_register

    class << self
      def init
        # Bind the associated resource file (i.e. gresource-prefix + resource-path-name)
        set_template(:resource => "/com/rubynetix/connect4/ui/app_window.ui")

        bind_template_child("window_stack")
        bind_template_child("help_menu_item")
      end
    end

    def initialize(application, active_wid, windows = [])
      super application: application
      set_title 'Rubynetix Games'

      @window_stack = window_stack
      @help_menu_item = help_menu_item
      @help_menu_item.signal_connect("activate") {@active_window.display_help}
      @active_window = nil

      windows.each(&method(:add_window))
      display_window(active_wid)
    end

    # Load an observable window
    def add_window(window)
      window.register(self)
      wid = window.id
      @window_stack.add_named(window, wid)
    end

    def display_window(wid)
      window = @window_stack.get_child_by_name(wid)

      if window.nil?
        raise StandardError("----- WINDOW NOT FOUND ----- wid=#{wid}")
      end

      @window_stack.set_visible_child(window)
      @active_window = window
      window.prepare
    end

    def notify(event)
      case event.id
      when UIEvent::WINDOW_CHANGE
        display_window(event.to_wid)
      when UIEvent::MSG_ERR
        display_error(event.msg)
      when UIEvent::MSG_HELP
        display_help(event.msg)
      else
        notify_all(event)
      end
    end

    def display_help(msg)
      display_dialog(:info, msg, :ok)
    end

    def display_error(msg)
      display_dialog(:error, msg, :close)
    end

    def display_dialog(type, msg, btn)
      dialog = Gtk::MessageDialog.new(
          :parent => self,
          :flags => :destroy_with_parent,
          :type => type,
          :buttons => btn,
          :message => msg
      )

      dialog.run
      dialog.destroy
    end
  end
end
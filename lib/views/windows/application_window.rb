module C4
  class ApplicationWindow < Gtk::ApplicationWindow
    # Register the class in the GLib world
    type_register

    class << self
      def init
        # Bind the associated resource file (i.e. gresource-prefix + resource-path-name)
        set_template(:resource => "/com/rubynetix/connect4/ui/application_window.ui")

        # Add method to access the widget with id 'launch_app_btn'
        bind_template_child("launch_app_btn")
      end
    end

    def initialize(application)
      super application: application

      set_title 'Connect4'

      launch_app_btn.signal_connect 'clicked' do |btn, app|
        game_window = C4::GameWindow.new(application)
        game_window.present
      end
    end
  end
end
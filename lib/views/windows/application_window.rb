require_relative '../../../lib/views/observable'

module C4
  class ApplicationWindow < Gtk::ApplicationWindow
    include PassthroughObservable

    type_register

    attr_reader :game_window, :stats_window, :active_window

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

      set_title 'Rubynetix Games'

      # Possible spawned child windows
      @game_window = nil
      @stats_window = nil
      @new_window = nil

      launch_app_btn.signal_connect 'clicked' do |btn, app|
        @game_window = C4::GameWindow.new(application)

        # Listen for events in all spawned child windows and pass them up the
        # observable chain to the listening application
        @game_window.register(self)
        @game_window.present

        @new_window = @game_window
      end
    end
  end
end

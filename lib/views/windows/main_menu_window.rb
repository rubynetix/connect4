require_relative '../../../lib/views/events/window_change_event'
require_relative '../../../lib/views/observable'
require_relative 'game_window'

module C4
  class MainMenuWindow < Gtk::Box
    include PassthroughObservable

    @@WID = "main_menu"

    type_register

    class << self
      def init
        set_template(:resource => "/com/rubynetix/connect4/ui/main_menu_window.ui")

        bind_template_child("launch_app_btn")
      end
    end

    def initialize
      super(:orientation => Gtk::Orientation::VERTICAL)
      launch_app_btn.signal_connect('clicked') {notify_all(WindowChangeEvent.new(GameWindow.class_variable_get(:@@WID)))}
    end

    def display; end

    def id
      @@WID
    end
  end
end

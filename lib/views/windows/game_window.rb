module C4
  class GameWindow < Gtk::Window
    type_register

    class << self
      def init
        set_template(:resource => "/com/rubynetix/connect4/ui/game_window.ui")
      end
    end

    def initialize(application)
      super application: application
    end
  end
end
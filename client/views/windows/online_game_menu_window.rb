require_relative '../../../client/views/events/window_change_event'
require_relative '../../../client/views/observable'
require_relative '../../../client/views/windows/main_menu_window'
require_relative 'widget_window'

module C4
  class OnlineGameMenuWindow < Gtk::Box
    include PassthroughObservable
    include WidgetWindow

    @@wid = "online_game_menu"

    type_register

    class << self
      def init
        set_template(:resource => "/com/rubynetix/connect4/ui/online_game_menu_window.ui")

        bind_template_child("opponent_entry")
        bind_template_child("current_games_list")
        bind_template_child("start_btn")
        bind_template_child("continue_game_btn")
        bind_template_child("back_btn")
      end
    end

    def initialize
      super(:orientation => Gtk::Orientation::VERTICAL)

      @opponent_entry = opponent_entry
      @games_list = current_games_list
      @start_btn = start_btn
      @continue_btn = continue_game_btn
      @back_btn = back_btn

      # Signals
      @start_btn.signal_connect('clicked') {try_new_game}
      @continue_btn.signal_connect('clicked') {try_continue_game}
      @back_btn.signal_connect('clicked') {notify_all(WindowChangeEvent.new(MainMenuWindow.class_variable_get(:@@wid)))}
    end

    private

    def try_new_game
      opp = @opponent_entry.text

      puts "----- STARTING NEW GAME AGAINST #{opp} -----"
    end

    def try_continue_game
      puts "----- CONTINUING GAME  -------"
    end

    def valid_username?(username)
      true
    end
  end
end

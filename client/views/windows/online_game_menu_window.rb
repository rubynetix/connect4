require_relative '../../../client/views/events/window_change_event'
require_relative '../../../client/views/observable'
require_relative '../../../client/views/windows/main_menu_window'
require_relative 'online_game_window'
require_relative '../components/game_list_row'
require_relative '../events/ui_event'
require_relative 'widget_window'
require_relative 'stats_window'

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
        bind_template_child("back_btn")
        bind_template_child("stats_btn")
      end
    end

    def initialize
      super(:orientation => Gtk::Orientation::VERTICAL)

      @opponent_entry = opponent_entry
      @games_list = current_games_list
      @start_btn = start_btn
      @back_btn = back_btn
      @stats_btn = stats_btn

      # Signals
      @start_btn.signal_connect('clicked') {try_new_game}
      @back_btn.signal_connect('clicked') {notify_all(WindowChangeEvent.new(MainMenuWindow.class_variable_get(:@@wid)))}
      @stats_btn.signal_connect('clicked') {notify_all(WindowChangeEvent.new(StatsWindow.class_variable_get(:@@wid)))}
    end

    def add_current_game(game)
      row = GameListRow.new(game)
      # Listen for continue game clicks in list
      row.register(self)
      @games_list.add(row)
    end

    def display
      # Clear any existing games and request the most recent games list
      clear_games_list
      notify_all(UIEvent.new(UIEvent::LIST_USER_GAMES))
    end

    private

    def clear_games_list
      @games_list.children.each { |game| game.unregister(self); @games_list.remove(game) }
    end

    def try_new_game
      opp = @opponent_entry.text

      puts "----- STARTING NEW GAME AGAINST #{opp} -----"
      notify_all(WindowChangeEvent.new(OnlineGameWindow.class_variable_get(:@@wid)))
    end

    def valid_username?(username)
      true
    end
  end
end

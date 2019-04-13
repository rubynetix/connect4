require_relative '../observable'
require_relative 'main_menu_window'
require_relative 'online_game_window'
require_relative '../../../client/models/game_type'
require_relative '../components/game_list_row'
require_relative '../events/ui_event'
require_relative '../events/menu_click_event'
require_relative '../events/window_change_event'
require_relative '../events/new_online_game_event'
require_relative 'widget_window'
require_relative 'stats_window'
require_relative 'app_window_id'
require_relative '../../../client/models/game_type'


module C4
  class OnlineGameMenuWindow < Gtk::Box
    include PassthroughObservable
    include WidgetWindow

    type_register

    class << self
      def init
        set_template(:resource => "/com/rubynetix/connect4/ui/online_game_menu_window.ui")

        bind_template_child("opponent_entry")
        bind_template_child("current_games_list")
        bind_template_child("connect4_btn")
        bind_template_child("connect4_btn_widget")
        bind_template_child("toot_otto_btn")
        bind_template_child("toot_otto_btn_widget")
        bind_template_child("start_btn")
        bind_template_child("back_btn")
        bind_template_child("stats_btn")
      end
    end

    def initialize
      super(:orientation => Gtk::Orientation::VERTICAL)
      @id = AppWindowId::ONLINE_GAME_MENU_WINDOW

      @opponent_entry = opponent_entry
      @games_list = current_games_list
      @c4_btn = connect4_btn
      @to_btn = toot_otto_btn
      @start_btn = start_btn
      @back_btn = back_btn
      @stats_btn = stats_btn

      # Styled radio buttons
      c4_btn = connect4_btn_widget
      c4_btn.pack_start(load_image(RedCounter.instance.icon))
      c4_btn.pack_start(load_image(YellowCounter.instance.icon))

      to_btn = toot_otto_btn_widget
      to_btn.pack_start(load_image(TCounter.instance.icon))
      to_btn.pack_start(load_image(OCounter.instance.icon))

      # Signals
      @start_btn.signal_connect('clicked') {try_new_game}
      # @c4_btn.signal_connect('clicked') {notify_all(MenuClickEvent.new(MenuClickEvent::CONNECT4))}
      # @to_btn.signal_connect('clicked') {notify_all(MenuClickEvent.new(MenuClickEvent::TOOT_OTTO))}
      @back_btn.signal_connect('clicked') {notify_all(WindowChangeEvent.new(AppWindowId::MAIN_MENU_WINDOW, @id))}
      @stats_btn.signal_connect('clicked') {notify_all(WindowChangeEvent.new(AppWindowId::STATS_WINDOW, @id))}
    end

    def add_current_game(game)
      row = GameListRow.new(game)
      # Listen for continue game clicks in list
      row.register(self)
      @games_list.add(row)
    end

    def clear_games_list
      @games_list.children.each { |game| game.unregister(self); @games_list.remove(game) }
    end

    def prepare
      # Clear any existing games and request the most recent games list
      clear_games_list
      notify_all(UIEvent.new(UIEvent::LIST_USER_GAMES))
    end

    def window_help
      "Continue an existing game or start a new game by entering your opponent's username."
    end

    private

    def try_new_game
      opp = @opponent_entry.text
      notify_all(NewOnlineGameEvent.new(opp, game_type))
    end

    def game_type
      active_btn = connect4_btn.group.detect(&:active?)
      if active_btn.eql?(connect4_btn)
        Connect4GameType.instance.id
      else
        TootOttoGameType.instance.id
      end
    end

    def start_new_game
      notify_all(WindowChangeEvent.new(AppWindowId::ONLINE_GAME_WINDOW, @id))
    end

    def valid_username?(username)
      true
    end

    def load_image(path)
      img = Gtk::Image.new(:file => path)
      img.visible = true
      img
    end
  end
end

require_relative '../../../client/views/events/window_change_event'
require_relative '../../../client/views/observable'
require_relative '../../../client/views/windows/main_menu_window'
require_relative 'offline_game_window'
require_relative 'widget_window'

module C4
  class MainMenuWindow < Gtk::Box
    include PassthroughObservable
    include WidgetWindow

    @@wid = "main_menu"

    type_register

    class << self
      def init
        set_template(:resource => "/com/rubynetix/connect4/ui/main_menu_window.ui")

        bind_template_child("username_entry")
        bind_template_child("server_url_entry")
        bind_template_child("connect_btn")
        bind_template_child("offline_btn")
      end
    end

    def initialize
      super(:orientation => Gtk::Orientation::VERTICAL)

      @username_input = username_entry
      @server_input = server_url_entry
      @connect_btn = connect_btn
      @offline_btn = offline_btn

      @connect_btn.signal_connect('clicked') {try_connect}
      @offline_btn.signal_connect('clicked') {notify_all(WindowChangeEvent.new(OfflineGameMenuWindow.class_variable_get(:@@wid)))}
    end

    def window_help
      "Connect to a game server or play offline."
    end

    private

    def try_connect
      username, url = @username_input.text, @server_input.text

      if !valid_username?(username)
        display_error(msg: "Username is invalid")
        return
      elsif !valid_server?(url)
        display_error(msg: "Game server URL is invalid")
        return
      end

      notify_all(ServerConnectEvent.new(username, url))
    end

    def valid_username?(username)
      true
    end

    def valid_server?(server_url)
      true
    end
  end
end

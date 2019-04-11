require_relative '../../client/views/observable'
require_relative '../../client/views/windows/app_window'
require_relative '../../client/views/windows/main_menu_window'
require_relative '../../client/views/windows/offline_game_window'
require_relative '../../client/views/windows/offline_game_menu_window'
require_relative '../../client/views/windows/online_game_menu_window'
require_relative '../../client/views/windows/online_game_window'

module C4
  class Application < Gtk::Application
    include PassthroughObservable

    attr_reader :ui, :main_menu_window, :online_menu_window, :offline_menu_window, :game_window, :online_game_window, :stats_window

    GTK_PENDING_BLOCKS = []
    GTK_PENDING_BLOCKS_LOCK = Monitor.new

    def initialize
      super 'com.rubynetix.connect4', Gio::ApplicationFlags::FLAGS_NONE

      signal_connect :activate do |application|

        @main_menu_window = MainMenuWindow.new
        @online_menu_window = OnlineGameMenuWindow.new
        @offline_menu_window = OfflineGameMenuWindow.new
        @game_window = OfflineGameWindow.new
        @online_game_window = OnlineGameWindow.new
        @stats_window = StatsWindow.new

        windows = [
            # Menu windows
            @main_menu_window,
            @online_menu_window,
            @offline_menu_window,
            # League Statistics
            @stats_window,
            # Gameplay window
            @game_window,
            @online_game_window
        ]

        @ui = C4::AppWindow.new(application, @main_menu_window.id, windows)

        # Listen for events in spawned windows and bubble them up the observable
        # chain to the wrapping GtkUI instance
        @ui.register(self)
        @ui.present
      end
    end

    def queue &block
      if Thread.current == Thread.main
        block.call
      else
        GTK_PENDING_BLOCKS_LOCK.synchronize do
          GTK_PENDING_BLOCKS << block
        end
      end
    end
  end
end
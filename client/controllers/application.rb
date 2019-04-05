require_relative '../../client/views/observable'
require_relative '../../client/views/windows/app_window'
require_relative '../../client/views/windows/main_menu_window'
require_relative '../../client/views/windows/game_window'
require_relative '../../client/views/windows/game_menu_window'

module C4
  class Application < Gtk::Application
    include PassthroughObservable

    attr_reader :ui

    def initialize
      super 'com.rubynetix.connect4', Gio::ApplicationFlags::FLAGS_NONE

      signal_connect :activate do |application|
        windows = [MainMenuWindow.new, GameMenuWindow.new, GameWindow.new]
        @ui = C4::AppWindow.new(application, windows[0].id, windows)

        # Listen for events in spawned windows and bubble them up the observable
        # chain to the wrapping GtkUI instance
        @ui.register(self)
        @ui.present
      end
    end
  end
end
require_relative '../../lib/views/observable'
require_relative '../../lib/views/windows/main_window'
require_relative '../../lib/views/windows/main_menu_window'
require_relative '../../lib/views/windows/game_window_widget'

module C4
  class Application < Gtk::Application
    include PassthroughObservable

    attr_reader :ui

    def initialize
      super 'com.rubynetix.connect4', Gio::ApplicationFlags::FLAGS_NONE

      signal_connect :activate do |application|
        windows = [MainMenuWindow.new, GameWindowWidget.new]
        @ui = C4::MainWindow.new(application, windows[0].id, windows)

        # Listen for events in spawned windows and bubble them up the observable
        # chain to the wrapping GtkUI instance
        @ui.register(self)
        @ui.present
      end
    end
  end
end
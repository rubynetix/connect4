module C4
  class Application < Gtk::Application
    def initialize
      super 'com.rubynetix.connect4', Gio::ApplicationFlags::FLAGS_NONE

      signal_connect :activate do |application|
        # Create a new app window
        window = C4::ApplicationWindow.new(application)
        window.present
      end
    end
  end
end
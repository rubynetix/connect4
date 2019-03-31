require_relative '../../lib/views/observable'

module C4
  class Application < Gtk::Application
    include PassthroughObservable

    attr_reader :ui

    def initialize
      super 'com.rubynetix.connect4', Gio::ApplicationFlags::FLAGS_NONE

      signal_connect :activate do |application|
        # @ui = C4::ApplicationWindow.new(application)
        @ui = C4::StackWindow.new(application,  [Window1.new, Window2.new])

        # Listen for events in spawned windows and bubble them up the observable
        # chain to the wrapping GtkUI instance
        @ui.register(self)
        @ui.present
      end
    end
  end
end
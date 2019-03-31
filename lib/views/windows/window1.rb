require_relative '../../../lib/views/events/window_change_event'
require_relative '../../../lib/views/observable'
require_relative 'window2'

module C4
  class Window1 < Gtk::Box
    include PassthroughObservable

    @@WID = "window1"

    type_register

    class << self
      def init
        set_template(:resource => "/com/rubynetix/connect4/ui/window1_widget.ui")

        bind_template_child("window1_btn")
      end
    end

    def initialize
      super(:orientation => Gtk::Orientation::VERTICAL)
      window1_btn.signal_connect('clicked') {notify_all(WindowChangeEvent.new(Window2.class_variable_get(:@@WID)))}
    end
  end
end

require_relative '../../../lib/views/events/ui_event'
require_relative '../../../lib/views/observable'
require_relative 'window1'

module C4
  class Window2 < Gtk::Box
    include PassthroughObservable

    @@WID = "window2"

    type_register

    class << self
      def init
        set_template(:resource => "/com/rubynetix/connect4/ui/window2_widget.ui")

        bind_template_child("window2_btn")
      end
    end

    def initialize
      super(:orientation => Gtk::Orientation::VERTICAL)
      window2_btn.signal_connect('clicked') {notify_all(WindowChangeEvent.new(Window1.class_variable_get(:@@WID)))}
    end
  end
end

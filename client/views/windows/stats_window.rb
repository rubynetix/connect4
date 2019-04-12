require_relative '../../../client/views/events/window_change_event'
require_relative '../../../client/views/observable'
require_relative '../events/ui_event'
require_relative 'online_game_menu_window'
require_relative 'widget_window'
require_relative '../components/stats_list_row'

module C4
  class StatsWindow < Gtk::Box
    include PassthroughObservable
    include WidgetWindow

    @@wid = "stats_window"

    type_register

    class << self
      def init
        set_template(:resource => "/com/rubynetix/connect4/ui/stats_window.ui")

        bind_template_child("stats_list")
        bind_template_child("back_btn")
      end
    end

    def initialize
      super(:orientation => Gtk::Orientation::VERTICAL)

      @stats_list = stats_list
      @back_btn = back_btn
      @back_btn.signal_connect('clicked') {notify_all(WindowChangeEvent.new(OnlineGameMenuWindow.class_variable_get(:@@wid), @@wid))}
    end

    def add_user_stat(user_stat)
      stat = StatsListRow.new(user_stat)
      # Listen for continue game clicks in list
      @stats_list.add(stat)
    end

    def prepare
      # Clear any existing user statistics and request the most up to date version
      clear_stats
      notify_all(UIEvent.new(UIEvent::LIST_LEAGUE_STATS))
    end

    def window_help
      "Scroll to view player stats."
    end

    private

    def clear_stats
      @stats_list.children.each { |stat| @stats_list.remove(stat) }
    end
  end
end

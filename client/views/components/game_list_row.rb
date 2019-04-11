require_relative '../observable'
require_relative '../events/continue_game_event'

module C4
  class GameListRow < Gtk::ListBoxRow
    include Observable

    type_register

    class << self
      def init
        set_template(:resource => "/com/rubynetix/connect4/ui/game_list_row.ui")

        bind_template_child("game_type_lbl")
        bind_template_child("continue_game_btn")
        bind_template_child("opponent_lbl")
      end
    end

    def initialize(game)
      super()
      @game = game

      game_type_lbl.text = game[:game_type] || ""
      opponent_lbl.text = game[:opponent] || ""

      continue_game_btn.signal_connect('clicked') {notify_all(ContinueGameEvent.new(@game))}
    end
  end
end

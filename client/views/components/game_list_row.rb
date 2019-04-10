require_relative '../observable'

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

      game_type_lbl.text = game[:game_type] || ""
      opponent_lbl.text = game[:opponent] || ""

      @continue_btn = continue_game_btn
      @continue_btn.signal_connect('clicked') {puts "---- CONTINUE CLICK ----"}
    end
  end
end

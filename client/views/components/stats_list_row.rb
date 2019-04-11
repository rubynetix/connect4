module C4
  class StatsListRow < Gtk::ListBoxRow
    type_register

    class << self
      def init
        set_template(:resource => "/com/rubynetix/connect4/ui/stats_list_row.ui")

        bind_template_child("username_lbl")

        # Connect4 Stats
        bind_template_child("c4_win_lbl")
        bind_template_child("c4_loss_lbl")
        bind_template_child("c4_draw_lbl")
        bind_template_child("c4_gp_lbl")

        # Toot/Otto Stats
        bind_template_child("to_win_lbl")
        bind_template_child("to_loss_lbl")
        bind_template_child("to_draw_lbl")
        bind_template_child("to_gp_lbl")
      end
    end

    def initialize(user_stat)
      super()
      username_lbl.text = user_stat[:username]

      c4_win_lbl.text = user_stat[:c4_wins].to_s
      c4_loss_lbl.text = user_stat[:c4_losses].to_s
      c4_draw_lbl.text = user_stat[:c4_draws].to_s
      c4_gp_lbl.text = user_stat[:c4_games].to_s

      to_win_lbl.text = user_stat[:to_wins].to_s
      to_loss_lbl.text = user_stat[:to_losses].to_s
      to_draw_lbl.text = user_stat[:to_draws].to_s
      to_gp_lbl.text = user_stat[:to_games].to_s
    end
  end
end

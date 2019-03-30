require 'matrix'
require_relative '../../../lib/models/game_board'
require_relative '../../../lib/views/components/counter_cell'

module C4
  class GameWindow < Gtk::Window
    type_register

    class << self
      def init
        set_template(:resource => "/com/rubynetix/connect4/ui/game_window.ui")

        bind_template_child("game_board_grid")
      end
    end

    def initialize(application)
      super application: application

      @counter_width = 50
      @counter_height = 50

      @cells = Matrix.empty(0, 0)
      @game_layout = game_board_grid

      @css = Gtk::CssProvider.new
      @css.load(:path => abs_path("/styles/main.css"))
    end

    def draw_gameboard(gb)
      if gb.rows != @cells.row_count or gb.cols != @cells.column_count
        draw_board(@game_layout, gb.rows, gb.cols)
      end

      gb.iter do |r, c, counter|
        @cells[r, c].set_counter(counter)
      end
    end

    def set_turn(player)
      @lb_turn.set_text("#{player.name}'s turn")

      if player.counters.size > 1
        draw_counter_bar(@counter_bar, player.counters, player.counter_select)
        @counter_bar.visible = true
      else
        @counter_bar.visible = false
      end
    end

    private

    def draw_board(grid_layout, rows, cols)
      grid_layout.children.each do |c|
        grid_layout.remove_child(c)
      end

      @cells = Matrix.build(rows, cols) do |r, c|
        cell = CounterCell.new(r, c, 75, 75, @css)
        # cell.register(self)
        grid_layout.attach(cell.widget, c, r, 1, 1)
        cell
      end
    end
  end
end
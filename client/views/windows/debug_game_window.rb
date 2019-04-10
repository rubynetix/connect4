require_relative '../../../client/views/events/window_change_event'
require_relative '../../../client/views/observable'
require_relative 'main_menu_window'
require_relative 'widget_window'
require_relative '../../models/game_board'

module C4
  class DebugGameWindow < Gtk::Box
    include PassthroughObservable
    include WidgetWindow

    @@wid = "debug_game_window"

    type_register

    class << self
      def init
        set_template(:resource => "/com/rubynetix/connect4/ui/debug_game_window.ui")

        # Game board children
        bind_template_child("game_board_grid")
        bind_template_child("game_board_overlay")
      end
    end

    def initialize
      super(:orientation => Gtk::Orientation::VERTICAL)

      @gb = GameBoard.connect4
      @gb.place(RedCounter.instance, 1)

      init_gameboard
    end

    def prepare
      clear_gameboard
      draw_gameboard(@gb)
    end

    def draw_gameboard(gb)
      if gb.rows != @cells.row_count or gb.cols != @cells.column_count
        draw_board(@game_layout, gb.rows, gb.cols)
      end

      gb.iter do |r, c, counter|
        @cells[r, c].set_counter(counter)
      end
    end

    def clear_gameboard
    end

    private

    def init_gameboard
      @counter_width = 50
      @counter_height = 50
      @cells = Matrix.empty(0, 0)

      # Game widgets
      @game_layout = game_board_grid
      @game_overlay = game_board_overlay

      # Styling
      @css = Gtk::CssProvider.new
      @css.load(:path => abs_path("/styles/main.css"))
    end

    def draw_board(grid_layout, rows, cols)
      grid_layout.children.each do |c|
        grid_layout.remove_child(c)
      end

      @cells = Matrix.build(rows, cols) do |r, c|
        cell = CounterCell.new(r, c, 75, 75, @css)
        cell.register(self)
        grid_layout.attach(cell.widget, c, r, 1, 1)
        cell
      end
    end

    def draw_counter_bar(bar_layout, counters, select_index)
      return if counters.empty?

      bar_layout.children.each do |c|
        bar_layout.remove_child(c)
      end

      root_sel = Gtk::RadioButton.new
      root_sel.mode = false
      root_sel.visible = true
      root_sel.add_child(load_image(counters[0].icon))
      bar_layout.pack_start(root_sel)

      selectors = [root_sel]

      if counters.size > 1
        selectors += counters[1..-1].map do |c|
          c_sel = Gtk::RadioButton.new(:member => root_sel)
          c_sel.mode = false
          c_sel.visible = true
          c_sel.add_child(load_image(c.icon))
          bar_layout.pack_start(c_sel)
          c_sel
        end
      end

      selectors[select_index].active = true

      selectors.each_with_index do |s, i|
        s.signal_connect "toggled" do
          notify_all(CounterSelectedEvent.new(i))
        end
      end
    end

    def load_image(path)
      img = Gtk::Image.new(:file => path)
      img.visible = true
      img
    end
  end
end

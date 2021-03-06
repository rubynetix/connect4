require_relative '../../../client/views/events/window_change_event'
require_relative '../../../client/views/observable'
require_relative '../events/window_change_event'
require_relative 'online_game_menu_window'
require_relative 'main_menu_window'
require_relative 'widget_window'
require_relative 'app_window_id'
require_relative '../events/ui_event'

module C4
  class OnlineGameWindow < Gtk::Box
    include PassthroughObservable
    include WidgetWindow

    type_register

    class << self
      def init
        set_template(:resource => "/com/rubynetix/connect4/ui/online_game_window.ui")

        # Game board children
        bind_template_child("back_btn")
        bind_template_child("player_turn_lbl")
        bind_template_child("forfeit_btn")
        bind_template_child("game_board_grid")
        bind_template_child("counter_bar")
        bind_template_child("game_board_overlay")
      end
    end

    def initialize
      super(:orientation => Gtk::Orientation::VERTICAL)
      @id = AppWindowId::ONLINE_GAME_WINDOW

      init_gameboard
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

    def game_over(winner)
      if !winner.nil?
        @lb_win.set_text("#{winner.name} wins!")
      else
        @lb_win.set_text("Draw")
      end

      @lb_win.visible = true
    end

    def clear_gameboard
      @lb_win.visible = false
    end

    def prepare
      clear_gameboard
    end

    def window_help
      "Click a column to place your counter."
    end

    private

    def init_gameboard
      @counter_width = 50
      @counter_height = 50
      @cells = Matrix.empty(0, 0)

      # Game widgets
      @game_layout = game_board_grid
      @counter_bar = counter_bar
      @lb_turn = player_turn_lbl
      @fft_btn = forfeit_btn
      @game_overlay = game_board_overlay
      @lb_win = Gtk::Label.new("Player wins!")
      @game_overlay.add_overlay(@lb_win)
      @back_btn = back_btn

      # Styling
      @css = Gtk::CssProvider.new
      @css.load(:path => abs_path("/styles/main.css"))
      @game_layout.style_context.add_provider(@css, Gtk::StyleProvider::PRIORITY_USER)
      @fft_btn.add_child(load_image(abs_path("/assets/forfeit.png")))

      # Event signals
      @fft_btn.signal_connect("clicked") {notify_all(ForfeitClickEvent.new)}
      @back_btn.signal_connect("clicked") {exit_game}
    end

    def exit_game
      notify_all(UIEvent.new(UIEvent::EXIT_ONLINE_GAME))
      notify_all(WindowChangeEvent.new(AppWindowId::ONLINE_GAME_MENU_WINDOW, @id))
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

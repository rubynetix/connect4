require_relative '../../../lib/views/events/window_change_event'
require_relative '../../../lib/views/observable'
require_relative 'main_menu_window'

module C4
  class GameWindowWidget < Gtk::Box
    include PassthroughObservable

    @@WID = "game_window"

    type_register

    class << self
      def init
        set_template(:resource => "/com/rubynetix/connect4/ui/game_window_widget.ui")

        # Game board children
        bind_template_child("game_panel")
        bind_template_child("player_turn_lbl")
        bind_template_child("forfeit_btn")
        bind_template_child("game_board_grid")
        bind_template_child("new_game_btn")
        bind_template_child("main_menu_btn")
        bind_template_child("counter_bar")
        bind_template_child("game_board_overlay")

        # Game menu children
        bind_template_child("menu_panel")
        bind_template_child("connect4_btn")
        bind_template_child("connect4_btn_widget")
        bind_template_child("toot_otto_btn")
        bind_template_child("toot_otto_btn_widget")
        bind_template_child("pvp_btn")
        bind_template_child("pvc_btn")
        bind_template_child("pvc_btn_hard")
        bind_template_child("start_btn")
        bind_template_child("back_btn")
      end
    end

    def initialize
      super(:orientation => Gtk::Orientation::VERTICAL)
    end

    def display
      init_gameboard
      init_menu
    end

    def draw_gameboard(gb)
      if gb.rows != @cells.row_count or gb.cols != @cells.column_count
        draw_board(@game_layout, gb.rows, gb.cols)
      end

      gb.iter do |r, c, counter|
        @cells[r, c].set_counter(counter)
      end
    end

    def load_menu
      clear_gameboard
      @menu.visible = true
      @game.visible = false
    end

    def load_game
      @menu.visible = false
      @game.visible = true
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
      @bt_new_game.visible = true
      @main_menu_btn.visible = true
    end

    def clear_gameboard
      @lb_win.visible = false
      @bt_new_game.visible = false
      @main_menu_btn.visible = false
    end

    private

    def init_gameboard
      @counter_width = 50
      @counter_height = 50
      @cells = Matrix.empty(0, 0)

      # Parent of all game widgets
      @game = game_panel

      # Game widgets
      @game_layout = game_board_grid
      @counter_bar = counter_bar
      @bt_new_game = new_game_btn
      @main_menu_btn = main_menu_btn
      @lb_turn = player_turn_lbl
      @fft_btn = forfeit_btn
      @game_overlay = game_board_overlay
      @lb_win = Gtk::Label.new("Player wins!")
      @game_overlay.add_overlay(@lb_win)

      # Styling
      @css = Gtk::CssProvider.new
      @css.load(:path => abs_path("/styles/main.css"))
      @game_layout.style_context.add_provider(@css, Gtk::StyleProvider::PRIORITY_USER)
      @fft_btn.add_child(load_image(abs_path("/assets/forfeit.png")))

      # Event signals
      @main_menu_btn.signal_connect("clicked") {notify_all(MenuClickEvent.new(MenuClickEvent::RETURN_MAIN_MENU))}
      @bt_new_game.signal_connect("clicked") do
        clear_gameboard
        notify_all(MenuClickEvent.new(MenuClickEvent::NEW_GAME))
      end
      @fft_btn.signal_connect("clicked") {notify_all(ForfeitClickEvent.new)}
    end

    def init_menu
      # Parent of all menu widgets
      @menu = menu_panel

      # Config widgets
      @menu_c4 = connect4_btn
      @menu_c4.mode = false
      @menu_to = toot_otto_btn
      @menu_to.mode = false
      @menu_pvp = pvp_btn
      @menu_pvp.mode = false
      @menu_pvc = pvc_btn
      @menu_pvc.mode = false
      @menu_pvc_hard = pvc_btn_hard
      @menu_pvc_hard.mode = false
      @menu_start = start_btn
      @back_btn = back_btn

      # Styled radio buttons
      c4_btn = connect4_btn_widget
      c4_btn.pack_start(load_image(RedCounter.instance.icon))
      c4_btn.pack_start(load_image(YellowCounter.instance.icon))

      to_btn = toot_otto_btn_widget
      to_btn.pack_start(load_image(TCounter.instance.icon))
      to_btn.pack_start(load_image(OCounter.instance.icon))

      # Event signals
      @menu_start.signal_connect("clicked") {notify_all(MenuClickEvent.new(MenuClickEvent::START))}
      @menu_c4.signal_connect("clicked") {notify_all(MenuClickEvent.new(MenuClickEvent::CONNECT4))}
      @menu_to.signal_connect("clicked") {notify_all(MenuClickEvent.new(MenuClickEvent::TOOT_OTTO))}
      @menu_pvp.signal_connect("clicked") {notify_all(MenuClickEvent.new(MenuClickEvent::PVP))}
      @menu_pvc.signal_connect("clicked") {notify_all(MenuClickEvent.new(MenuClickEvent::PVC_EASY))}
      @menu_pvc_hard.signal_connect("clicked") {notify_all(MenuClickEvent.new(MenuClickEvent::PVC_HARD))}
      @back_btn.signal_connect('clicked') {notify_all(WindowChangeEvent.new(MainMenuWindow.class_variable_get(:@@WID)))}
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
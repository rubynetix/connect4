require 'matrix'
require_relative '../../../lib/models/game_board'
require_relative '../../../lib/views/components/counter_cell'

module C4
  class GameWindow < Gtk::Window
    type_register

    class << self
      def init
        set_template(:resource => "/com/rubynetix/connect4/ui/game_window.ui")

        # Game board children
        bind_template_child("game_panel")
        bind_template_child("player_turn_lbl")
        bind_template_child("forfeit_btn")
        bind_template_child("game_board_grid")
        bind_template_child("new_game_btn")
        bind_template_child("main_menu_btn")

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
      end
    end

    def initialize(application)
      super application: application

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

    def show_menu
      clear_gameboard
      @menu.visible = true
      @game.visible = false
    end

    def show_game
      @menu.visible = false
      @game.visible = true
    end

    def set_turn(player)
      @lb_turn.set_text("#{player.name}'s turn")

      # if player.counters.size > 1
      #   draw_counter_bar(@counter_bar, player.counters, player.counter_select)
      #   @counter_bar.visible = true
      # else
      #   @counter_bar.visible = false
      # end
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
      @bt_new_game = new_game_btn
      @main_menu_btn = main_menu_btn
      @lb_turn = player_turn_lbl
      @fft_btn = forfeit_btn

      # Styling
      @css = Gtk::CssProvider.new
      @css.load(:path => abs_path("/styles/main.css"))
      @game_layout.style_context.add_provider(@css, Gtk::StyleProvider::PRIORITY_USER)
      @fft_btn.add_child(load_image(abs_path("/assets/forfeit.png")))

      # Event signals
      @main_menu_btn.signal_connect("clicked") { puts "---------CLICKED! ---------"}
      @bt_new_game.signal_connect("clicked") {puts "---------CLICKED---------"}
      @fft_btn.signal_connect("clicked") { puts "---------CLICKED! ---------"}
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

      # Styled radio buttons
      c4_btn = connect4_btn_widget
      c4_btn.pack_start(load_image(RedCounter.instance.icon))
      c4_btn.pack_start(load_image(YellowCounter.instance.icon))

      to_btn = toot_otto_btn_widget
      to_btn.pack_start(load_image(TCounter.instance.icon))
      to_btn.pack_start(load_image(OCounter.instance.icon))

      # Event signals
      @menu_start.signal_connect("clicked") {puts "--------- CLICKED---------"}
      @menu_c4.signal_connect("clicked") {puts "--------- CLICKED---------"}
      @menu_to.signal_connect("clicked") {puts "--------- CLICKED---------"}
      @menu_pvp.signal_connect("clicked") {puts "--------- CLICKED---------"}
      @menu_pvc.signal_connect("clicked") {puts "--------- CLICKED---------"}
      @menu_pvc_hard.signal_connect("clicked") {puts "--------- CLICKED---------"}
    end

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

    def load_image(path)
      img = Gtk::Image.new(:file => path)
      img.visible = true
      img
    end
  end
end
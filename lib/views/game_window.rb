require 'gtk3'
require 'matrix'
require_relative 'observable'
require_relative 'components/counter_cell'
require_relative 'events/menu_click_event'
require_relative 'events/counter_selected_event'

def abs_path(path)
  "#{File.expand_path(__dir__)}#{path}"
end

class GameWindow
  include PassthroughObservable

  def initialize
    @builder_file = abs_path("/windows/game.ui")
    @counter_width = 50
    @counter_height = 50

    @cells = Matrix.empty(0, 0)
    @lb_turn = nil
    @lb_win = nil
    @counter_bar = nil
    @game_layout = nil

    @css = Gtk::CssProvider.new
    @css.load(:path => abs_path("/styles/main.css"))
  end

  def build
    # Construct a Gtk::Builder instance and load our UI description
    builder = Gtk::Builder.new(:file => @builder_file)

    # Connect signal handlers to the constructed widgets
    window = builder["window"]
    window.signal_connect("destroy") { Gtk.main_quit }
    window.style_context.add_provider(@css, Gtk::StyleProvider::PRIORITY_USER)

    @lb_turn = builder["lb_turn"]

    @game_layout = builder["game_board"]
    @game_layout.style_context.add_provider(@css, Gtk::StyleProvider::PRIORITY_USER)

    game_overlay = builder["game_board_overlay"]
    @lb_win = Gtk::Label.new("Player wins!")
    game_overlay.add_overlay(@lb_win)

    @counter_bar = builder["counter_bar"]
    @bt_new_game = builder["bt_new_game"]
    @main_menu_btn = builder["main_menu_btn"]
    @main_menu_btn.signal_connect("clicked") {notify_all(MenuClickEvent.new(MenuClickEvent::RETURN_MAIN_MENU))}
    @bt_new_game.signal_connect("clicked") do
      clear_gameboard
      notify_all(MenuClickEvent.new(MenuClickEvent::NEW_GAME))
    end

    @game = builder["game_panel"]

    fft_btn = builder["forfeit_btn"]
    fft_btn.add_child(load_image(abs_path("/assets/forfeit.png")))
    fft_btn.signal_connect "clicked" do
      notify_all(ForfeitClickEvent.new)
    end

    # Game configuration items
    @menu = builder["menu_panel"]
    @menu_start = builder["start_btn"]

    @menu_c4 = builder["connect4_btn"]
    @menu_c4.mode = false

    c4_btn = builder["connect4_btn_widget"]
    c4_btn.pack_start(load_image(RedCounter.instance.icon))
    c4_btn.pack_start(load_image(YellowCounter.instance.icon))

    @menu_to = builder["toot_otto_btn"]
    @menu_to.mode = false

    to_btn = builder["toot_otto_btn_widget"]
    to_btn.pack_start(load_image(TCounter.instance.icon))
    to_btn.pack_start(load_image(OCounter.instance.icon))

    @menu_pvp = builder["pvp_btn"]
    @menu_pvp.mode = false
    @menu_pvc = builder["pvc_btn"]
    @menu_pvc.mode = false

    @menu_start.signal_connect("clicked") {notify_all(MenuClickEvent.new(MenuClickEvent::START))}
    @menu_c4.signal_connect("clicked") {notify_all(MenuClickEvent.new(MenuClickEvent::CONNECT4))}
    @menu_to.signal_connect("clicked") {notify_all(MenuClickEvent.new(MenuClickEvent::TOOT_OTTO))}
    @menu_pvp.signal_connect("clicked") {notify_all(MenuClickEvent.new(MenuClickEvent::PVP))}
    @menu_pvc.signal_connect("clicked") {notify_all(MenuClickEvent.new(MenuClickEvent::PVC))}
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
    @bt_new_game.visible = true
    @main_menu_btn.visible = true
  end

  def clear_gameboard
    @lb_win.visible = false
    @bt_new_game.visible = false
    @main_menu_btn.visible = false
  end

  private

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
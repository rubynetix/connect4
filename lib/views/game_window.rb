require 'gtk3'
require 'matrix'
require_relative 'observable'
require_relative 'components/counter_cell'
require_relative 'events/menu_click_event'
require_relative 'events/counter_selected_event'

class GameWindow
  include PassthroughObservable

  def initialize
    @builder_file = "#{File.expand_path(__dir__)}/windows/game.ui"
    @counter_width = 50
    @counter_height = 50

    @cells = nil
    @lb_turn = nil
    @lb_win = nil
    @counter_bar = nil

    @css = Gtk::CssProvider.new
    @css.load(:path => "#{File.expand_path(__dir__)}/styles/main.css")
  end

  def build
    # Construct a Gtk::Builder instance and load our UI description
    builder = Gtk::Builder.new(:file => @builder_file)

    # Connect signal handlers to the constructed widgets
    window = builder["window"]
    window.signal_connect("destroy") { Gtk.main_quit }
    window.style_context.add_provider(@css, Gtk::StyleProvider::PRIORITY_USER)

    @lb_turn = builder["lb_turn"]

    game_layout = builder["game_board"]
    game_layout.style_context.add_provider(@css, Gtk::StyleProvider::PRIORITY_USER)
    draw_board(game_layout)

    game_overlay = builder["game_board_overlay"]
    @lb_win = Gtk::Label.new("Player wins!")
    game_overlay.add_overlay(@lb_win)

    @counter_bar = builder["counter_bar"]
    @bt_new_game = builder["bt_new_game"]

    @game = builder["game_panel"]

    # Game configuration items
    @menu = builder["menu_panel"]
    @menu_start = builder["start_btn"]
    @menu_c4 = builder["connect4_btn"]
    @menu_to = builder["toot_otto_btn"]
    @menu_pvp = builder["pvp_btn"]
    @menu_pvc = builder["pvc_btn"]

    @menu_start.signal_connect("clicked") {notify_all(MenuClickEvent::START)}
    @menu_c4.signal_connect("clicked") {notify_all(MenuClickEvent::CONNECT4)}
    @menu_to.signal_connect("clicked") {notify_all(MenuClickEvent::TOOT_OTTO)}
    @menu_pvp.signal_connect("clicked") {notify_all(MenuClickEvent::PVP)}
    @menu_pvc.signal_connect("clicked") {notify_all(MenuClickEvent::PVC)}
  end

  def show_menu
    @menu.visible = true
    @game.visible = false
  end

  def show_game
    @menu.visible = false
    @game.visible = true
  end

  def draw_gameboard(gb)
    gb.iter do |r, c, counter|
      @cells[r, c].set_counter(counter)
    end
  end

  def set_turn(player)
    @lb_turn.set_text("#{player.name}'s turn")
  end

  def set_counters(counters)
    draw_counter_bar(@counter_bar, counters)
  end

  def game_over(winner)
    if !winner.nil?
      @lb_win.set_text("#{winner.name} wins!")
    else
      @lb_win.set_text("Draw")
    end
    
    @lb_win.visible = true
    @bt_new_game.visible = true
  end

  private

  def draw_board(grid_layout)
    @cells = Matrix.build(6, 7) do |r, c|
      cell = CounterCell.new(r, c, 75, 75, @css)
      cell.register(self)
      grid_layout.attach(cell.widget, c, r, 1, 1)
      cell
    end
  end

  def draw_counter_bar(bar_layout, counters)
    return if counters.empty?

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

    selectors.each do |s, c|
      s.signal_connect "toggled" do
        notify_all(CounterSelectedEvent.new(c))
      end
    end
  end

  def load_image(path)
    img = Gtk::Image.new(:file => path)
    img.visible = true
    img
  end
end
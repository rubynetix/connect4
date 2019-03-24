require 'gtk3'
require 'matrix'
require_relative 'observable'
require_relative 'components/counter_cell'

class GameWindow
  include Observable

  def initialize
    @builder_file = "#{File.expand_path(__dir__)}/windows/game.ui"
    @counter_width = 50
    @counter_height = 50

    @cells = nil
    @lb_turn = nil

    @observers = []
    @css = Gtk::CssProvider.new
    @css.load(:path => "#{File.expand_path(__dir__)}/styles/main.css")


  end

  def build
    # Construct a Gtk::Builder instance and load our UI description
    builder = Gtk::Builder.new(:file => @builder_file)

    # Connect signal handlers to the constructed widgets
    window = builder.get_object("window")
    window.signal_connect("destroy") { Gtk.main_quit }
    window.style_context.add_provider(@css, Gtk::StyleProvider::PRIORITY_USER)

    @lb_turn = builder.get_object("lb_turn")

    game_layout = builder.get_object("game_board")
    game_layout.style_context.add_provider(@css, Gtk::StyleProvider::PRIORITY_USER)
    draw_board(game_layout)
  end

  def draw_game(gb)
    gb.iter do |r, c, counter|
      @cells[r, c].set_counter(counter)
    end
  end

  def set_turn(player)
    @lb_turn.set_text("#{player.name}'s turn")
  end

  def on_click(event)
    notify_all(event)
  end

  def notify(event)
    on_click(event)
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

end
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
    @counter_bar = nil

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

    @counter_bar = builder.get_object("counter_bar")
    # draw_counter_bar(counter_bar, [RedCounter.instance, YellowCounter.instance])

    # TODO: Replace with actual event generated from user button click
    mock_click_events
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

  # Mock UI events from the configuration menu until a menu UI is built
  def mock_click_events
    Thread.new do
      sleep(2)
      notify(MenuClickEvent::START)
    end
  end

  def load_image(path)
    img = Gtk::Image.new(:file => path)
    img.visible = true
    img
  end
end
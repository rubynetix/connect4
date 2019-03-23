require 'gtk3'
require 'matrix'
require_relative 'observable'

class GameWindow
  include Observable

  def initialize
    @builder_file = "#{File.expand_path(__dir__)}/windows/game.ui"
    @counter_width = 50
    @counter_height = 50

    @layout_gb = nil
    @cells = nil

    @observers = []
  end

  def build
    # Construct a Gtk::Builder instance and load our UI description
    builder = Gtk::Builder.new(:file => @builder_file)

    # Connect signal handlers to the constructed widgets
    window = builder.get_object("window")
    window.signal_connect("destroy") { Gtk.main_quit }

    @layout_gb = builder.get_object("game_board")

    draw_board
    # game_board.attach_next_to(piece_button, counter, Gtk::PositionType::RIGHT, 1, 1)

    # lb_turn = builder.get_object("lb_turn")
    # lb_turn.set_text('Hello!')
  end

  def load_image(path)
    Gtk::Image.new(:file => path)
  end

  def r_counter
    load_image("#{File.expand_path(__dir__)}/assets/r_counter.png")
  end

  def y_counter
    load_image("#{File.expand_path(__dir__)}/assets/y_counter.png")
  end

  def draw_game(gb)
    gb.iter do |r, c, counter|
      unless counter.empty?
        @cells[r, c].image = load_image(counter.sprite)
      end
    end
  end

  def on_click(r, c)
    notify_all([r, c])
  end

private

  def draw_board

    @cells = Matrix.build(6, 7) do |r, c|
      b_counter = Gtk::Button.new
      b_counter.set_size_request(150, 150)
      b_counter.visible = true
      @layout_gb.attach(b_counter, c, r, 1, 1)

      b_counter.signal_connect "clicked" do
        on_click(r, c)
      end

      b_counter
    end

    # (0..5).each do |r|
    #   (0..6).each do |c|
    #
    #     # b_counter.height = 50
    #     # case [0, 1, 2].sample
    #     # when 1
    #     #   b_counter.image = r_counter
    #     # when 2
    #     #   b_counter.image = y_counter
    #     # end
    #
    #
    #   end
    # end

  end

end
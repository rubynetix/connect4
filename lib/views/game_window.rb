require 'gtk3'

class GameWindow

  def initialize
    @builder_file = "#{File.expand_path(__dir__)}/windows/game.ui"
    @counter_width = 50
    @counter_height = 50

    @game_board = nil
  end

  def build
    # Construct a Gtk::Builder instance and load our UI description
    builder = Gtk::Builder.new(:file => @builder_file)

    # Connect signal handlers to the constructed widgets
    window = builder.get_object("window")
    window.signal_connect("destroy") { Gtk.main_quit }

    @game_board = builder.get_object("game_board")

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

  end

private

  def draw_board

    (0..5).each do |r|
      (0..6).each do |c|
        b_counter = Gtk::Button.new

        case [0, 1, 2].sample
        when 1
          b_counter.image = r_counter
        when 2
          b_counter.image = y_counter
        end

        b_counter.visible = true
        @game_board.attach(b_counter, c, r, 1, 1)
      end
    end

  end

end
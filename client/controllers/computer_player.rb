require_relative 'player'
require_relative 'algorithms/alpha_beta_pruning'
require_relative 'algorithms/random'

class ComputerPlayer < Player

  attr_accessor :op_counters, :my_win

  def initialize(name, counters, my_win, op_counters)
    super name, counters
    @my_win = my_win
    @op_counters = op_counters
  end

  def algorithm=(algorithm)
    case algorithm
    when :AlphaBetaPruning
      extend AlphaBetaPruning
    else
      extend RandomAction
    end
  end

  def get_action(ui, board)
    do_action( get_move(board))
  end

  def do_action(event)
    return forfeit if event == :FORFEIT

    counter, col = event
    place_counter counter, col
  end

  def place_counter(counter, col)
    begin
      @board.place(counter, col)
      PlayerAction::PLACE_COUNTER
    rescue ColumnFullError, InvalidColumnError => exception
      puts exception
    end
  end
end
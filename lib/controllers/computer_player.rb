require_relative 'player'
require_relative 'algorithms/mcts'
require_relative 'algorithms/alpha_beta_pruning'
require_relative 'algorithms/random'

class ComputerPlayer < Player

  def algorithm=(algorithm)
    case algorithm
    when :AlphaBetaPruning
      extend AlphaBetaPruning
    when :MCTS
      extend MCTS
    else
      extend RandomAction
    end
  end

  def get_action(ui, board)
    return :FORFEIT if board.possible_cols.size.zero?

    get_move board, @my_counter
  end

  def do_action(event)
    forfeit if event == :FORFEIT

    place_counter(event)
  end
end
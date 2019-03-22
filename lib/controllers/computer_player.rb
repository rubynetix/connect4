require_relative 'Player'
require_relative 'algorithms/mcts'
require_relative 'algorithms/alpha_beta_pruning'
require_relative 'algorithms/random'

class ComputerPlayer < Player

  def initialize(name)
    super name
  end

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

  def get_action(board)
    return :FORFEIT if board.possible_moves.size.zero?

    get_move board
  end
end
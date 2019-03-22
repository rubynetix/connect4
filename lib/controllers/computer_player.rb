class ComputerPlayer < Player

  def initialize(name)
    super name
  end

  def set_algorithm(algorithm)
    @algorithm = case algorithm
                 when :AlphaBetaPruning
                   Algorithm.new.extend(AlphaBetaPruning)
                 when :MCTS
                   Algorithm.new.extend(MCTS)
                 else
                   Algorithm.new.extend(RandomAction)
                 end
  end

  def get_action(board)
    return :FORFEIT if board.possible_moves.size.zero?

    get_move board
  end
end
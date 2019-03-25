require_relative '../../../lib/models/game_board'

# Random move if possible, else forfeit
module RandomAction

  def get_move(board)
    return :FORFEIT if board.possible_cols.size.zero?

    [@counters.sample, board.possible_cols.sample]
  end
end

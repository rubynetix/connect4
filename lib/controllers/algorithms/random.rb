require_relative '../../../lib/models/game_board'

# Random move if possible, else forfeit
module RandomAction

  def get_move(board)
    board.possible_moves.sample
  end
end

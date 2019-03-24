module AlphaBetaPruning
  MAX_SCORE = 10_000
  MAX_DEPTH = 100

  class BestScores
    include Singleton

    attr_accessor :best_scores

    @best_scores = {}
  end

  def counter(prev)
    return YellowCounter.instance if prev == RedCounter.instance
    RedCounter.instance
  end

  def get_move(board)
    BestScores.instance.best_scores = {}
    negamax board.dup, @counter

    BestScores.instance.best_scores.max_by {|_, value| value}[0]
  end

  def negamax(board, turn, alpha: -MAX_SCORE, beta: MAX_SCORE, depth: 0, max_depth: 1)
    return get_score(board, depth, turn) if board.ended?
    return 0 if depth == max_depth

    max = -MAX_SCORE

    board.possible_cols.each do |move|
      next_board = board.dup
      next_board.place turn, move
      turn = counter turn
      negamax_return = -negamax(next_board, turn, alpha: -beta, beta: -alpha, depth: depth + 1)


      max = negamax_return if negamax_return > max
      BestScores.instance.best_scores[move] = max if depth.zero?
      alpha = negamax_return if negamax_return > max
      return alpha if alpha >= beta
    end
    max
  end

  # We want to win and
  # we want to win quickly (or lose slowly)
  def scoring(board, depth)
    return 0 if board.draw?
    return MAX_SCORE / depth if board.winner? == self.name

    -MAX_SCORE / depth
  end

  def get_score(board, depth, player)
    player * scoring(board, depth)
  end
end
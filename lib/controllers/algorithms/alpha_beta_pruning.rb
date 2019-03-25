module AlphaBetaPruning
  MAX_SCORE = 10_000
  MAX_DEPTH = 3

  class BestScores
    include Singleton

    attr_accessor :best_scores

    @@best_scores = {}
  end

  def counters(turn)
    return @counters if turn == 1
    @op_counters
  end

  def get_move(board)
    BestScores.instance.best_scores = {}
    negamax board.dup, 1


    best_col = BestScores.instance.best_scores.max_by {|_, value| value}[0]
    [@counters.sample, best_col]
  end

  def negamax(board, turn, alpha: -MAX_SCORE, beta: MAX_SCORE, depth: 0, max_depth: MAX_DEPTH)
    return get_score(board, depth, turn) if board.over?
    return 0 if depth > max_depth

    my_max = -MAX_SCORE

    board.possible_cols.each do |col|
      counters(turn).each do |counter|
        next_board = board.dup
        next_board.place counter, col
        negamax_return = -negamax(next_board, -turn, alpha: -beta, beta: -alpha, depth: depth + 1)

        alpha = [negamax_return, alpha].max
        BestScores.instance.best_scores[col] = negamax_return if depth.zero?
        my_max = [my_max, negamax_return].max
        return alpha if alpha >= beta
      end
    end
    my_max
  end

  def scoring(board, depth)
    depth += 1
    return 0 if board.check == WinEnum::DRAW
    return MAX_SCORE / depth if board.win_check.winner? board, @my_win

    -MAX_SCORE / depth
  end

  def get_score(board, depth, player)
    player * scoring(board, depth)
  end
end
module AlphaBetaPruning
  MAX_SCORE = 10_000
  MAX_DEPTH = 2

  class BestScores
    include Singleton

    attr_accessor :best_scores

    @@best_scores = {}
  end

  def counter(turn)
    return @counters.sample if turn == 1
    @op_counters.sample
  end

  def favour_middle(board, col)
    mid = board.cols / 2
    diff = (mid - col).abs
    return (mid - diff).abs
  end

  def get_move(board)
    puts board.possible_cols
    BestScores.instance.best_scores = {}
    negamax board.dup, 1



    puts "Scores: ", BestScores.instance.best_scores
    best_col = BestScores.instance.best_scores.max_by {|col, value| value + favour_middle(board, col)}[0]
    [@counters.sample, best_col]
  end

  def negamax(board, turn, alpha: -MAX_SCORE, beta: MAX_SCORE, depth: 0, max_depth: MAX_DEPTH)
    return get_score(board, depth, turn) if board.over?
    return 0 if depth > max_depth

    max = -MAX_SCORE

    [2,3].each do |move|
      next_board = board.dup
      next_board.place counter(turn), move
      negamax_return = -negamax(next_board, -turn, alpha: -beta, beta: -alpha, depth: depth + 1)


      alpha = negamax_return if negamax_return > max
      max = negamax_return if negamax_return > max
      puts next_board, "M, N, M, D", max, negamax_return, depth if move == 2
      BestScores.instance.best_scores[move] = max if depth.zero?
    end
    max
  end

  # We want to win and
  # we want to win quickly (or lose slowly)
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
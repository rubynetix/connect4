module TootWinCheck
  extend self

  def is_winner?(board)
    raise NotImplementedError
  end

  def get_winner(board)
    raise NotImplementedError
  end
end

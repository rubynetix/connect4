class Player
  def initialize(name)
    @name = name
  end

  def take_turn(board)
    raise NotImplementedError
  end
end

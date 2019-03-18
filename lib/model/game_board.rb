class GameBoard
  def initialize(size)
    @size = size
  end

  def place(counter, location)
    raise NotImplementedError
  end

  def remove(location)
    raise NotImplementedError
  end
end

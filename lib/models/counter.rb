class Counter
  attr_accessor :symbol, :sprite

  def initialize(symbol, sprite_path)
    @symbol = symbol
    @sprite = sprite_path
  end

  def to_s
    symbol
  end
end


class EmptyCounter < Counter
  def initialize(symbol = "-", sprite_path="")
    super(symbol, sprite_path)
  end

  def ==(other)
    other.instance_of?(EmptyCounter)
  end
end

class YellowCounter < Counter
  def initialize(symbol = "Y", sprite_path="")
    super(symbol, sprite_path)
  end
end

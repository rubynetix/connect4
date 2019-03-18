class Counter
  attr_accessor :symbol, :sprite

  def initialize(symbol, sprite_path)
    @symbol = symbol
    @sprite = sprite_path
  end
end

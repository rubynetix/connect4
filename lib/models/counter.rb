require 'singleton'

module Counter
  def sprite
    self.class.class_variable_get(:@@sprite)
  end

  def symbol
    self.class.class_variable_get(:@@symbol)
  end

  def empty?
    false
  end

  def to_s
    self.class.class_variable_get(:@@symbol)
  end
end

class YellowCounter
  include Singleton
  include Counter

  @@symbol = "Y"
  @@sprite = "#{File.expand_path(__dir__)}/../views/assets/y_counter.png"
end

class TCounter
  include Singleton
  include Counter

  @@symbol = "T"
  @@sprite = "/Path/To/Sprite"
end

class RedCounter
  include Singleton
  include Counter

  @@symbol = "R"
  @@sprite = "#{File.expand_path(__dir__)}/../views/assets/r_counter.png"
end

class OCounter
  include Singleton
  include Counter

  @@symbol = "O"
  @@sprite = "/Path/To/Sprite"
end

class EmptyCounter
  include Singleton
  include Counter

  @@symbol = "-"
  @@sprite = "/Path/To/Sprite"

  def empty?
    true
  end
end

require 'singleton'

module CounterToString
  def to_s
    self.class.class_variable_get(:@@symbol)
  end
end

class YellowCounter
  include Singleton
  include CounterToString

  @@symbol = "Y"
  @@sprite = "/Path/To/Sprite"
end

class TCounter
  include Singleton
  include CounterToString

  @@symbol = "T"
  @@sprite = "/Path/To/Sprite"
end

class RedCounter
  include Singleton
  include CounterToString

  @@symbol = "R"
  @@sprite = "/Path/To/Sprite"
end

class OCounter
  include Singleton
  include CounterToString

  @@symbol = "O"
  @@sprite = "/Path/To/Sprite"
end

class EmptyCounter
  include Singleton
  include CounterToString

  @@symbol = "-"
  @@sprite = "/Path/To/Sprite"
end

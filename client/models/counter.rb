require 'singleton'

def get_asset(assert_path)
  "#{File.expand_path(__dir__)}/../views/assets/#{assert_path}"
end


module Counter

  def sprite
    self.class.class_variable_get(:@@sprite)
  end

  def icon
    self.class.class_variable_get(:@@icon)
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
  @@sprite = get_asset("y_counter_75.png")
  @@icon = get_asset("y_counter_40.png")
end

class TCounter
  include Singleton
  include Counter

  @@symbol = "T"
  @@sprite = get_asset("t_counter_75.png")
  @@icon = get_asset("t_counter_40.png")
end

class RedCounter
  include Singleton
  include Counter

  @@symbol = "R"
  @@sprite = get_asset("r_counter_75.png")
  @@icon = get_asset("r_counter_40.png")
end

class OCounter
  include Singleton
  include Counter

  @@symbol = "O"
  @@sprite = get_asset("o_counter_75.png")
  @@icon = get_asset("o_counter_40.png")
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

class CounterUtil
  ALL_COUNTERS = [
      YellowCounter.instance,
      RedCounter.instance,
      TCounter.instance,
      OCounter.instance,
      EmptyCounter.instance
  ]

  def self.symbol_to_counter(symbol)
    ALL_COUNTERS.detect {|c| c.symbol == symbol }
  end
end

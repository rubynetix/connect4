require 'singleton'

class Counter
  include Singleton

  @@symbol = nil
  @@sprite_path = nil

  def self.to_s
    @@symbol
  end
end


class EmptyCounter
  include Singleton

  @@symbol = "-"
  @@sprite_path = "/TO/DO"

  def self.to_s
    @@symbol
  end
end

class YellowCounter
  include Singleton

  @@symbol = "Y"
  @@sprite_path = "/TO/DO"

  def self.to_s
    @@symbol
  end
end

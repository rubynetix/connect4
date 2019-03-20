require 'singleton'

class YellowCounter
  include Singleton

  @@symbol = "Yellow"
  @@sprite = "/Path/To/Sprite"
end


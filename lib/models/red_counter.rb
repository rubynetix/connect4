require 'singleton'

class RedCounter
  include Singleton

  @@symbol = "Red"
  @@sprite = "/Path/To/Sprite"
end

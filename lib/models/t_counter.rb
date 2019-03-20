require 'singleton'

class TCounter
  include Singleton

  @@symbol = "T"
  @@sprite = "/Path/To/Sprite"
end

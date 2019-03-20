require 'singleton'

class OCounter
  include Singleton

  @@symbol = "O"
  @@sprite = "/Path/To/Sprite"
end

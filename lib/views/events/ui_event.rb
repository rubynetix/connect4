# Base class for a UI Event
class UIEvent

  attr_reader :id

  def initialize(id)
    @id = id
  end
end
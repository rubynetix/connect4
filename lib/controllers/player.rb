require_relative 'player_action'

class Player
  include PlayerAction
  def initialize(name, counter)
    @name = name
    @counter = counter
  end

  # Waits for the player to make an
  # action and returns it.
  def take_turn(board, ui)
    ui.register(self)
    raise NotImplementedError
  end

  def register(ui, event_filter)
    @event_filter = event_filter
    ui.register(self)
    raise NotImplementedError
  end

  def notify(event)
    raise NotImplementedError
  end

  def action
    raise NotImplementedError
  end

  def forfeit
    PlayerAction::FORFEIT
  end
end

require_relative 'player_action'

class Player
  include PlayerAction
  def initialize(name, counter)
    @name = name
    @counter = counter
    @event_que = Queue.new
  end

  # Waits for the player to make an
  # action and returns it.
  def take_turn(board, ui)
    @board = board
    @waiting = true
    register(ui, nil)
    e = @event_que.deq
    @board.place(@counter, e[1])
    ui.unregister self
    PlayerAction::PLACE_COUNTER
  end

  def register(ui, event_filter)
    @event_filter = event_filter
    ui.register(self)
  end

  def notify(event)
    @event_que.enq event
  end

  def action
    raise NotImplementedError
  end

  def forfeit
    PlayerAction::FORFEIT
  end
end

require_relative 'player_action'
require_relative '../models/game_board'
require_relative '../views/events/cell_click_event'
require_relative '../views/events/forfeit_click_event'

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
    register(ui, [CellClickEvent, ForfeitClickEvent])
    action = do_action(@event_que.deq) until action
    ui.unregister self
    action
  end

  # Event filter is a list of events
  # we want to listen to.
  def register(ui, event_filter)
    @event_filter = event_filter
    ui.register(self)
  end

  def notify(event)
    @event_que.enq event if @event_filter.include? event.class
  end

  # does and returns an action based on event
  def do_action(event)
    case event.class.to_s
    when 'CellClickEvent'
      place_counter(event.col)
    when 'ForfeitClickEvent'
      forfeit
    end
  end

  def forfeit
    PlayerAction::FORFEIT
  end

  def place_counter(col)
    begin
      @board.place(@counter, col)
      PlayerAction::PLACE_COUNTER
    rescue ColumnFullError, InvalidColumnError => exception
      puts exception
    end
  end
end

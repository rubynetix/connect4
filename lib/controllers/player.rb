require_relative 'player_action'
require_relative '../models/game_board'
require_relative '../views/events/cell_click_event'
require_relative '../views/events/forfeit_click_event'
require_relative '../views/events/counter_selected_event'

class Player
  include PlayerAction

  attr_accessor :name, :counters, :counter_select

  def initialize(name, counters)
    @name = name
    @counters = counters
    @counter_select = 0
    @event_que = Queue.new
  end

  # Waits for the player to make an
  # action and returns it.
  def take_turn(board, ui)
    ui.set_turn(self)
    @board = board
    @waiting = true
    register(ui, [CellClickEvent, ForfeitClickEvent, CounterSelectedEvent])
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
    when 'CounterSelectedEvent'
      @counter_select = event.index
      false
    else
      false
    end
  end

  def forfeit
    PlayerAction::FORFEIT
  end

  def place_counter(col)
    begin
      @board.place(@counters[@counter_select], col)
      PlayerAction::PLACE_COUNTER
    rescue ColumnFullError, InvalidColumnError => exception
      puts exception
    end
  end
end

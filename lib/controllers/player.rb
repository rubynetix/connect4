require_relative 'player_action'

class Player
  include PlayerAction
  def initialize(name, counter)
    @name = name
    @counter = counter
    @waiting = false
  end

  # Waits for the player to make an
  # action and returns it.
  def take_turn(board, ui)
    @board = board
    @waiting = true
    register(ui, nil)
    while @waiting; end
    puts 'Done waiting'
    ui.unregister self
    puts 'Unregistering ' + @name
    puts "TID: " + Thread.current.object_id.to_s
    PlayerAction::PLACE_COUNTER
  end

  def register(ui, event_filter)
    @event_filter = event_filter
    ui.register(self)
    puts 'Registering ' + @name
  end

  def notify(event)
    puts @name + " placeing token"
    @board.place(@counter, event[1])
    @waiting = false
    puts 'Waiting is false'
    puts "TID: " + Thread.current.object_id.to_s
  end

  def action
    raise NotImplementedError
  end

  def forfeit
    PlayerAction::FORFEIT
  end
end

class CLIPlayer < Player
 def take_turn(board, _)
  puts 'enter a column; '
  col = gets.chomp.to_i
  board.place(@counter, col)
  PlayerAction::PLACE_COUNTER
 end
end

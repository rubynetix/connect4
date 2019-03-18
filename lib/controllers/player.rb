class Player
  def initialize(name)
    @name = name
  end

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

  def get_action
    raise NotImplementedError
  end
end

require_relative 'ui_event'

class ContinueGameEvent < UIEvent
  attr_reader :game

  def initialize(game)
    super UIEvent::CONTINUE_ONLINE_GAME
    @game = game
  end
end

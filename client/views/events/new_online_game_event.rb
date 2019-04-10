require_relative 'ui_event'

class NewOnlineGameEvent < UIEvent
  attr_reader :opponent, :game_type

  def initialize(opp, game_type)
    super UIEvent::NEW_ONLINE_GAME
    @opponent = opp
    @game_type = game_type
  end
end

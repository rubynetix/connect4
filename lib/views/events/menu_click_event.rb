require_relative 'ui_event'

class MenuClickEvent < UIEvent
  # Launch the game
  START = 0

  # Game mode configuration
  CONNECT4 = 1
  TOOT_OTTO = 2

  # Opponent configuration events
  PVP = 3
  PVC = 4

  # Restart the game
  NEW_GAME = 5
  RETURN_MAIN_MENU = 6

  attr_reader :click

  def initialize(click_id)
    super UIEvent::MENU_CLICK
    @click = click_id
  end
end

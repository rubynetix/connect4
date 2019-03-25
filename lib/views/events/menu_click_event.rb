require_relative 'ui_event'

class MenuClickEvent < UIEvent
  # Launch the game
  START = 0

  # Game mode configuration
  CONNECT4 = 1
  TOOT_OTTO = 2

  # Opponent configuration events
  PVP = 3
  PVC_EASY = 4
  PVC_HARD = 5

  # Restart the game
  NEW_GAME = 6
  RETURN_MAIN_MENU = 7

  attr_reader :click

  def initialize(click_id)
    super UIEvent::MENU_CLICK
    @click = click_id
  end
end

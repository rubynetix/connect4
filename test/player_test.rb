require 'test/unit'
require_relative '../lib/controllers/player'
require_relative '../lib/controllers/player_action'
require_relative '../lib/models/counter'
require_relative '../lib/models/game_board'
require_relative 'mock/mock_event'
require_relative 'mock/mock_ui'
require_relative '../lib/views/events/forfeit_click_event'
require_relative '../lib/views/events/cell_click_event'

class PlayerTest < Test::Unit::TestCase
  TEST_ITER = 10

  def setup
    @player = Player.new("Tester", YellowCounter.instance)
  end

  def teardown; end

  def test_take_turn_forfeit
    # Preconditions
    #  - None

    board = GameBoard.new
    ui = MockUI.new
    # @player.register(ui, [ForfeitClickEvent])
    action = Thread.new { @player.take_turn(board, ui) }
    sleep(1) # we sleep to give the player time to register itself to ui
    ui.notify_all(ForfeitClickEvent.new) # Simulate button click

    # Postconditions
    #  - A Forfeit Action is returned
    assert(action.value == PlayerAction::FORFEIT)
  end

  def test_take_turn_counter
    # Preconditions
    #  - None

    board = GameBoard.new
    ui = MockUI.new
    # @player.register(ui, [CellClickEvent])
    action = Thread.new { @player.take_turn(board, ui) }
    sleep(1) # we sleep to give the player time to register itself to ui
    ui.notify_all(CellClickEvent.new(0, 0)) # Simulate button click

    # Postconditions
    #  - A Place Counter Action is returned
    assert(action.value == PlayerAction::PLACE_COUNTER)
  end
end

require 'test/unit'
require_relative '../lib/controllers/player'

class PlayerTest < Test::Unit::TestCase
  TEST_ITER = 10

  def setup
    @player = Player.new Tester
  end

  def teardown; end

  def tst_take_turn
    # Preconditions
      # None

    board = GameBoard.new
    ui = MockUi.new
    mockbutton = MockButton.new
    ui.add_button(mockbutton)
    @player.register(nil, ui)
    action = @player.take_turn(board, ui)

    # Simulate button click

    # Postconditions
      # A PlayerAction is returned
    assert(action.is_a? PlayerAction)
  end
end

require 'test/unit'
require_relative '../lib/controllers/remote_player'
require_relative '../lib/controllers/player_action'
require_relative '../lib/models/counter'
require_relative '../lib/models/game_board'
require_relative 'mock/mock_event'
require_relative 'mock/mock_ui'
require_relative '../lib/views/events/forfeit_click_event'
require_relative '../lib/views/events/cell_click_event'

class RemotePlayerTest < Test::Unit::TestCase
  TEST_ITER = 10
  BOARD_ROWS = 6
  BOARD_COLS = 7

  def setup
    #TODO: Setup dummy server to take requests

    xml_client = XMLRPC::Client.new('localhost', '/', 8080)
    @player = RemotePlayer.new("RemoteTester", "LocalTester", [RedCounter.Instance], 1, xml_client)
  end

  def teardown; end

  def test_take_turn_forfeit
    # TODO
  end

  def test_take_turn_counter
    # TODO
  end
end

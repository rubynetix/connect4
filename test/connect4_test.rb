require_relative 'helper'
require_relative 'mock/mock_ui'
require_relative '../client/controllers/connect4'
require_relative '../client/controllers/player_factory'
require_relative '../client/controllers/algorithms/alpha_beta_pruning'


class Connect4Test < Helper

  def setup
    @orig_stdout = $stdout
  end

  def teardown
    $stdout = @orig_stdout
  end

  def sink_stdout(&block)
    $stdout = File.new( '/dev/null', 'w' )
    block.call
    $stdout = @orig_stdout
  end

  def test_launch_game

    ui = MockUI.new
    c4 = Connect4.new ui

    p1 = PlayerFactory::computer_player(
        Connect4GameType.instance, PlayerFactory::PLAYER_1, 'p1', :AlphaBetaPruning)
    p2 = PlayerFactory::computer_player(
        Connect4GameType.instance, PlayerFactory::PLAYER_1, 'p2', :AlphaBetaPruning)

    cvc_config = GameConfig.new ui
    cvc_config.players = [p1, p2]
    c4.config = cvc_config

    3.times do
      # Preconditions
      begin
        c4.config.players.each do |p|
          assert_true(p.is_a?(ComputerPlayer), 'Game must be played with two computers')
        end
      end

      sink_stdout do
        c4.launch_game
      end

      # Postconditions
      begin
        assert_true (true), 'Game must terminate'
      end
    end
  end
end
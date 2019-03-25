require_relative 'helper'
require_relative 'mock/mock_ui'
require_relative '../lib/controllers/connect4'
require_relative '../lib/controllers/computer_player'
require_relative '../lib/controllers/algorithms/alpha_beta_pruning'

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

    p1 = c4.make_bot('p1', :AlphaBetaPruning)
    p2 = c4.make_bot('p2', :AlphaBetaPruning)

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
        @config.reset
      end

      # Postconditions
      begin
        assert_true (true), 'Game must terminate'
      end
    end
  end
end
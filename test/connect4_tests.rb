require_relative 'Helper'
require_relative '../lib/models/connect4'
require_relative '../lib/controllers/computer_player'

class Connect4Tests < Helper
  RESULTS = %w(win loss draw)

  def new_connect4
    Connect4.new UI.new
  end

  def tst_launch_game
    c4 = new_connect4
    TEST_ITER.times do
      # Preconditions
      begin
      end

      result = c4.launch_game [ComputerPlayer.new, ComputerPlayer.new]

      # Postconditions
      begin
        assert_true (RESULTS.include? result)
      end
    end
  end
end
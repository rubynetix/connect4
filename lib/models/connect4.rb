require_relative 'game_stats'
require_relative '../view/UI'
require_relative '../controllers/local_player'
require_relative '../controllers/game'
require_relative '../models/game_board'
require_relative '../models/win_check'

class Connect4
  include GameStats
  def initialize(ui, stats)
    @ui = ui
    @game_stats = GameStats.new stats
    @players = []
    @gameboard = GameBoard.new
    @win_check = WinCheck.new 'YYYY', 'RRRR'
  end

  def app_loop
    # TODO: Implement a main menu
    @players [LocalPlayer.new, LocalPlayer.new]
    loop do
      launch_game @players, @gameboard, @win_check
    end
  end

  def load_stats
    raise(NotImplementedError)
  end

  def configure_settings
    raise(NotImplementedError)
  end

  def launch_game
    Game.new @players, @gameboard, @win_check
  end

  def update_game_stats(update)
    raise(NotImplementedError)
    @game_stats.update update
  end
end

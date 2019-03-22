require_relative 'game_stats'
require_relative '../view/UI'

class Connect4
  include GameStats
  def initialize(ui, stats)
    @ui = ui
    @game_stats = GameStats.new stats
  end

  def app_loop
    raise(NotImplementedError)
  end

  def load_stats
    raise(NotImplementedError)
  end

  def configure_settings
    raise(NotImplementedError)
  end

  def launch_game(players)
    raise(NotImplementedError)
  end

  def update_game_stats(update)
    raise(NotImplementedError)
    @game_stats.update update
  end
end

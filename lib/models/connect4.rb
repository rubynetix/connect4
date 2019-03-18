
class Connect4
  include GameStats
  def initialize(ui)
    @ui = ui
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
end

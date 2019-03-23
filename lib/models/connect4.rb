require_relative 'game_stats'
require_relative '../views/ui'
require_relative '../controllers/local_player'
require_relative '../controllers/player'
require_relative '../controllers/game'
require_relative '../models/game_board'
require_relative '../models/win_check'
require_relative '../models/counter'

# Class representing the application
class Connect4

  def initialize(ui, stats)
    @ui = ui
    @game_stats = GameStats.new stats
    @players = [Player.new('p1', RedCounter.instance), Player.new('p2', YellowCounter.instance)]
    @gameboard = GameBoard.new
    @win_check = WinCheck.new 'YYYY', 'RRRR'
  end

  def app_loop
    # TODO: Implement a main menu
    loop do
      puts "TIDapploop: " + Thread.current.object_id.to_s
      launch_game
    end
  end

  def load_stats
    raise(NotImplementedError)
  end

  def configure_settings
    raise(NotImplementedError)
  end

  def launch_game
    game = Game.new @players, @gameboard, @win_check, @ui
    game.game_loop
  end

  def update_game_stats(update)
    raise(NotImplementedError)
    @game_stats.update update
  end
end

ui = UI.new
Thread.new { Gtk.main }
puts 'hello there'
c4 = Connect4.new ui, nil
c4.app_loop

require_relative '../models/game_stats'
require_relative '../views/ui'
require_relative '../controllers/local_player'
require_relative 'computer_player'
require_relative '../controllers/player'
require_relative '../controllers/game'
require_relative '../models/game_board'
require_relative '../models/win_check'
require_relative '../models/counter'
require_relative '../views/events/menu_click_event'
require_relative 'algorithms/mcts'
require_relative 'algorithms/alpha_beta_pruning'
require_relative 'algorithms/random'

# Class representing the application
class Connect4

  def initialize(ui, stats)
    @ui = ui
    @config = GameConfig.new(ui)
    @game_stats = GameStats.new stats
    @ready = Queue.new
  end

  def app_loop
    loop do
      @ui.register(self)
      @ready.pop
      @ui.unregister(self)
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
    puts "Launch game"
    game = Game.new(@config)
    game.game_loop
  end

  def update_game_stats(update)
    raise(NotImplementedError)
    @game_stats.update update
  end

  def notify(event)
    case event
    when MenuClickEvent::START
      @ready << true
      @ui.load_game
    when MenuClickEvent::PVC
      @config.players[1] = ComputerPlayer.new('p2',
                                              [YellowCounter.instance],
                                              "YYYY",
                                              [RedCounter.instance]).extend AlphaBetaPruning
    when MenuClickEvent::PVP
      @config.players[1] = Player.new('p2', [YellowCounter.instance])
    when MenuClickEvent::CONNECT4
      @config.win_check = WinCheck.connect4
      @config.players[0].counters = [RedCounter.instance]
      @config.players[1].counters = [YellowCounter.instance]
    when MenuClickEvent::TOOT_OTTO
      @config.win_check = WinCheck.toot_otto
      @config.players[0].counters = [TCounter.instance, OCounter.instance]
      @config.players[1].counters = [TCounter.instance, OCounter.instance]
    end
  end
end

class GameConfig
  attr_accessor :players, :gameboard, :win_check, :ui

  def initialize(ui)
    @ui = ui
    @players = [
        Player.new('p1', [RedCounter.instance]),
        Player.new('p2', [YellowCounter.instance])
    ]
    @win_check = WinCheck.connect4
    @gameboard = GameBoard.connect4
  end
end

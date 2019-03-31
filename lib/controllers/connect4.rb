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

  attr_accessor :config

  def initialize(ui)
    @game_counters = [
        [[YellowCounter.instance], [RedCounter.instance]],
        [[TCounter.instance, OCounter.instance], [TCounter.instance, OCounter.instance]]
    ]
    @game_wins = [%w(YYYY RRRR), %w(OTTO TOOT)]
    @game = 0
    @ui = ui
    @config = GameConfig.new(ui)
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

  def configure_settings
    raise(NotImplementedError)
  end

  def launch_game
    game = Game.new(@config)
    @ui.load_game
    game.game_loop
  end

  def notify(event)
    # Only interested in menu clicks
    return if event.id != UIEvent::MENU_CLICK
    puts "----- #{self.to_s} RESPONDING #{event.id} -----"

    case event.click
    when MenuClickEvent::START
      if @game.zero?
        @config.gameboard = GameBoard.connect4
        puts @config.gameboard.win_check.wins
      else
        @config.gameboard = GameBoard.toot_otto
        puts @config.gameboard.win_check.wins
      end
      @ready << true
    when MenuClickEvent::PVC_EASY
      @config.alg = :RandomAction
      configure_bot
    when MenuClickEvent::PVC_HARD
      @config.alg = :AlphaBetaPruning
      configure_bot
    when MenuClickEvent::PVP
      @config.players[1] = Player.new('p2', @game_counters[@game][0])
    when MenuClickEvent::CONNECT4
      @game = 0
      @config.win_check = WinCheck.connect4
      @config.players[0].counters = [RedCounter.instance]
      if @config.players[1].instance_of? ComputerPlayer
        configure_bot
      else
        @config.players[1].counters = [YellowCounter.instance]
      end
    when MenuClickEvent::TOOT_OTTO
      @game = 1
      @config.win_check = WinCheck.toot_otto
      @config.players[0].counters = [TCounter.instance, OCounter.instance]
      if @config.players[1].instance_of? ComputerPlayer
        configure_bot
      else
        @config.players[1].counters = [TCounter.instance, OCounter.instance]
      end
    when MenuClickEvent::NEW_GAME
      @config.reset
      @ready << true
    when MenuClickEvent::RETURN_MAIN_MENU
      @config.reset
      @ui.load_menu
    end
  end

  def make_bot(name, algorithm)
    bot = ComputerPlayer.new(name,
                       @game_counters[@game][0],
                       @game_wins[@game][0],
                       @game_counters[@game][1])
    bot.algorithm = algorithm
    bot
  end

  private

  def configure_bot
    @config.players[1] = make_bot('p2', @config.alg)
  end
end

class GameConfig
  attr_accessor :players, :gameboard, :win_check, :ui, :alg

  def initialize(ui)
    @ui = ui
    @players = [
        Player.new('p1', [RedCounter.instance]),
        Player.new('p2', [YellowCounter.instance])
    ]
    @alg = :AlphaBetaPruning
    @win_check = WinCheck.connect4
    @gameboard = GameBoard.connect4
  end

  def reset
    @gameboard = @gameboard.clear
  end
end

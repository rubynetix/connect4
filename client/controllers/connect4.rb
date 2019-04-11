require_relative '../views/ui'
require_relative 'computer_player'
require_relative 'player'
require_relative 'player_factory'
require_relative 'game'
require_relative '../models/game_board'
require_relative '../models/win_check'
require_relative '../models/counter'
require_relative '../models/game_type'
require_relative '../views/events/menu_click_event'
require_relative 'algorithms/alpha_beta_pruning'
require_relative 'algorithms/random'
require_relative '../../client/views/events/server_connect_event'
require_relative 'client'

# Class representing the application
class Connect4

  attr_accessor :config

  def initialize(ui)
    @game_type = Connect4GameType.instance
    @game = 0
    @ui = ui
    @config = GameConfig.new(ui)
    @ready = Queue.new

    @user = nil
    @client = nil
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
    case event.id
    when UIEvent::MENU_CLICK
      handle_menu_click(event)
    when UIEvent::SERVER_CONN
      server_connect(event.username, event.server_url)
    when UIEvent::LIST_USER_GAMES
      load_user_games
    when UIEvent::LIST_LEAGUE_STATS
      load_league_stats
    when UIEvent::NEW_ONLINE_GAME
      new_online_game(event.opponent, event.game_type)
    when UIEvent::CONTINUE_ONLINE_GAME
      continue_online_game(event.game)
    else
      nil
    end
  end

  private

  def configure_bot
    @config.players[1] = PlayerFactory::computer_player(
        @game_type, PlayerFactory::PLAYER_2, 'p2', @config.alg)
  end

  def handle_menu_click(event)
    case event.click
    when MenuClickEvent::START
      @config.gameboard = @game_type.new_board
      puts @config.gameboard.win_check.wins
      @ready << true
    when MenuClickEvent::PVC_EASY
      @config.alg = :RandomAction
      configure_bot
    when MenuClickEvent::PVC_HARD
      @config.alg = :AlphaBetaPruning
      configure_bot
    when MenuClickEvent::PVP
      @config.players[1] = PlayerFactory::player(@game_type, PlayerFactory::PLAYER_2, 'p2')
    when MenuClickEvent::CONNECT4
      @game_type = Connect4GameType.instance
      @config.win_check = @game_type.win_check
      @config.players[0].counters = @game_type.p1_counters
      if @config.players[1].instance_of? ComputerPlayer
        configure_bot
      else
        @config.players[1].counters = @game_type.p2_counters
      end
    when MenuClickEvent::TOOT_OTTO
      @game_type = TootOttoGameType.instance
      @config.win_check = @game_type.win_check
      @config.players[0].counters = @game_type.p1_counters
      if @config.players[1].instance_of? ComputerPlayer
        configure_bot
      else
        @config.players[1].counters = @game_type.p2_counters
      end
    when MenuClickEvent::NEW_GAME
      @config.reset
      @ready << true
    when MenuClickEvent::RETURN_MAIN_MENU
      @config.reset
      @ui.load_menu
    end
  end

  def server_connect(username, server_ip)
    puts "---- CONNECTING ----- #{username} on #{server_ip}"
    @user = username
    @client = Client.new(host: server_ip)

    unless @client.login(username)
      begin
        @client.create_user(username)
      rescue InvalidUsername => e
        puts e.message
        return
      rescue DuplicateUsers
        nil
      end
    end

    @ui.load_online_menu
  end

  def load_user_games
    puts "---- LOADING USER GAMES -----"

    games = []
    begin
      games = @client.user_games(@user)
    rescue UserDoesNotExist
      return
    end

    @ui.load_current_games(games)
  end

  def load_league_stats
    @ui.load_stats(@client.get_league)
  end

  def new_online_game(opp, type)
    if type == Connect4GameType.instance.id
      game_type = Connect4GameType.instance
    else
      game_type = TootOttoGameType.instance
    end

    begin
      gid = @client.create_game(@user, opp, game_type.id, game_type.new_board)
    rescue UserDoesNotExist
      # TODO: Display error
      return
    rescue ArgumentError => e
      # TODO: Display error message
      return
    rescue GameAlreadyInProgress
      # TODO: Redirect to existing game
      return
    end

    @config.players[1] = PlayerFactory::remote_player(game_type, PlayerFactory::PLAYER_2,
                                                      opp, @user, gid, @client)
    @ui.load_online_game

    # Save the configuration
    @config.game_type = game_type
    @ready << true
  end

  def continue_online_game(game)
    puts "Continuing game #{game[:game_id]}"
    @config.players[1] = PlayerFactory::remote_player(game[:game_type], PlayerFactory::PLAYER_2,
                                                      game[:opponent], @user, game[:game_id], @client)

    @ui.load_online_game
    @config.game_type = game[:game_type]
    @ready << true
  end
end

class GameConfig
  attr_accessor :players, :game_type, :ui, :alg, :client

  def initialize(ui)
    @ui = ui
    @players = [
        Player.new('p1', [RedCounter.instance]),
        Player.new('p2', [YellowCounter.instance])
    ]
    @alg = :AlphaBetaPruning
    @game_type = Connect4GameType.instance
    @client = Client.new
  end

  def reset
  end
end

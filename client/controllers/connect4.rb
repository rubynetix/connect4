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
    @tasks = []
  end

  def app_loop
    loop do
      @ui.register(self)
      @ready.pop

      @tasks.each(&:kill)
      @tasks.clear

      @ui.unregister(self)
      launch_game
    end
  end

  def configure_settings
    raise(NotImplementedError)
  end

  def launch_game
    game = Game.new(@config)
    if @config.online?
      @ui.load_online_game
    else
      @ui.load_offline_game
    end
    game.game_loop
  end

  def notify(event)
    case event.id
    when UIEvent::MENU_CLICK
      handle_menu_click(event)
    when UIEvent::SERVER_CONN
      server_connect(event.username, event.server_url)
    when UIEvent::LIST_USER_GAMES
      puts "---- LOADING USER GAMES -----"
      load_games_thread = Thread.new do
        while true
         load_user_games
         sleep(2)
        end
      end
      @tasks.append(load_games_thread)
    when UIEvent::LIST_LEAGUE_STATS
      load_league_stats
    when UIEvent::NEW_ONLINE_GAME
      new_online_game(event.opponent, event.game_type)
    when UIEvent::CONTINUE_ONLINE_GAME
      continue_online_game(event.game)
    else
      nil
    end
  rescue Errno::ECONNREFUSED => e
    @ui.display_error(e.message)
  end

  private

  def configure_bot
    @config.players[1] = PlayerFactory::computer_player(
        @game_type, PlayerFactory::PLAYER_2, 'p2', @config.alg)
  end

  def handle_menu_click(event)
    case event.click
    when MenuClickEvent::START
      @config.online = false
      @ready << true
    when MenuClickEvent::PVC_EASY
      @config.alg = :RandomAction
      configure_bot
    when MenuClickEvent::PVC_HARD
      @config.alg = :AlphaBetaPruning
      configure_bot
    when MenuClickEvent::PVP
      @config.players[1] = PlayerFactory::player2(@game_type, 'p2')
    when MenuClickEvent::CONNECT4
      @config.game_type = @game_type = Connect4GameType.instance
      @config.players[0].counters = @game_type.p1_counters
      if @config.players[1].instance_of? ComputerPlayer
        configure_bot
      else
        @config.players[1].counters = @game_type.p2_counters
      end
    when MenuClickEvent::TOOT_OTTO
      @config.game_type = @game_type = TootOttoGameType.instance
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
    @config.client = @client

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
    rescue UserDoesNotExist => e
      @ui.displayError(e.message)
      return
    rescue ArgumentError => e
      @ui.displayError(e.message)
      return
    rescue GameAlreadyInProgress => e
      @ui.displayError(e.message)
      return
    end

    @config.players[0] = PlayerFactory::player1(game_type, @user)
    @config.players[1] = PlayerFactory::remote_player(game_type, PlayerFactory::PLAYER_2,
                                                      opp, @user, gid, @client)
    @ui.load_online_game

    # Save the configuration
    @config.game_type = game_type
    @config.gid = gid
    @config.online = true
    @ready << true
  end

  def continue_online_game(game)
    game_type = game[:game_type] == Connect4GameType.instance.name ? Connect4GameType.instance : TootOttoGameType.instance
    opp = game[:opponent]
    gid = game[:game_id]

    if @user == game[:p1]
      @config.players[0] = PlayerFactory::player1(game_type, @user)
      @config.players[1] = PlayerFactory::remote_player(game_type, PlayerFactory::PLAYER_2, opp, @user, gid, @client)
    else
      @config.players[0] = PlayerFactory::player2(game_type, @user)
      @config.players[1] = PlayerFactory::remote_player(game_type, PlayerFactory::PLAYER_1, opp, @user, gid, @client)
    end

    @ui.load_online_game
    @config.game_type = game_type
    @config.gid = game[:game_id]
    @config.online = true
    @ready << true
  end
end

class GameConfig
  attr_accessor :players, :game_type, :ui, :alg, :client, :online, :gid
  alias_method :online?, :online

  def initialize(ui)
    @ui = ui
    @players = [
        Player.new('p1', [RedCounter.instance]),
        Player.new('p2', [YellowCounter.instance])
    ]
    @alg = :AlphaBetaPruning
    @game_type = Connect4GameType.instance
    @client = nil
    @online = false
    @gid = nil
  end

  def reset; end
end

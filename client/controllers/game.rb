class Game
  def initialize(config)
    raise NotTwoPlayersError unless config.players.size == 2
    # Ensure online games have a client and offline games do not
    raise InvalidConfigError if (config.online? && config.client.nil?) || (!config.online? && !config.client.nil?)

    @players = config.players
    @win_check = config.game_type.win_check
    @client = config.client
    @ui = config.ui
    @done = false
    @winner = nil
    @gid = config.gid
    @online = config.online?

    if config.online?
      game = @client.get_game(config.gid)

      # Swap player order if opponent's turn
      if game[:turn] == @players[1].name
        @players[0], @players[1] = @players[1], @players[0]
      end

      @gameboard = game[:board]
    else
      @gameboard = config.game_type.new_board
    end
  end

  def game_loop
    update_board
    until @done
      @players.each do |p|
        @quit = Queue.new
        process_action(p, p.take_turn(@gameboard, @ui))
        return unless @quit.empty?

        update_board
        break if @done
      end
    end
    @ui.game_over(@winner)
  end

  private

  def process_action(player, action)
    case action
    when PlayerAction::FORFEIT
      @done = true
      @winner = other_player(player)
    when PlayerAction::PLACE_COUNTER
      # No need to do win analysis locally for online games
      return if @online

      case @win_check.check(@gameboard)
      when WinEnum::DRAW
        @done = true
      when WinEnum::WIN1
        @done = true
        @winner = @players[0]
      when WinEnum::WIN2
        @done = true
        @winner = @players[1]
      end
    when PlayerAction::REMOTE_UPDATE
      game = @client.get_game(@gid)
      @gameboard = game[:board]
      case game[:state]
      when 'draw'
        @done = true
      when 'w1'
        @done = true
        @winner = game[:p1] == @players[0].name ? @players[0] : @players[1]
      when 'w2'
        @done = true
        @winner = game[:p2] == @players[0].name ? @players[0] : @players[1]
      end
    when PlayerAction::EXIT_ONLINE_GAME
      @quit << true
    end

    # Update the server if the local player won
    if @online && @done && @winner.instance_of?(Player)
      remote_player = other_player(@winner)
      remote_player.update_remote_board(@gameboard)
    end
  end

  def update_board
    # Possibly update remote board here

    puts "\n--------- GAMESTATE ---------"
    puts @gameboard.to_s
    @ui.draw_gameboard(@gameboard)
  end

  def other_player(p)
    case p
    when @players[0]
      @players[1]
    else
      @players[0]
    end
  end
end

class NotTwoPlayersError < StandardError; end
class GameAlreadyOverError < StandardError; end
class InvalidConfigError < StandardError; end

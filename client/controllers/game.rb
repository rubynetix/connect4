class Game
  def initialize(config)
    raise NotTwoPlayersError unless config.players.size == 2

    @players = config.players
    @win_check = config.game_type.win_check
    @client = config.client
    @ui = config.ui
    @done = false
    @winner = nil
    @gid = config.gid

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

    @game_state = WinEnum::NEUTRAL
  end

  def game_loop
    update_board
    until @done
      @players.each do |p|
        @quit = Queue.new
        @game_state = p.take_turn(@gameboard, @ui, @game_state)
        process_action(p, @game_state)
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
    when PlayerAction::REMOTE_UPDATE_BOARD
      case @client.get_game(gid)[:state]
      when 'draw'
        @done = true
      when 'w1'
        @done = true
        @winner = @players[0]
      when 'w2'
        @done = true
        @winner = @players[1]
      end
    when PlayerAction::EXIT_ONLINE_GAME
      @quit << true
    end
  end

  def update_board
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

class Game
  def initialize(config)
    raise NotTwoPlayersError unless config.players.size == 2

    @players = config.players
    @gameboard = config.game_type.new_board
    @win_check = config.game_type.win_check
    @client = config.client
    @ui = config.ui
    @done = false
    @winner = nil

    # TODO: Properly initialize game settings (aka grab from server if remoteplayer)
    @gid = nil
    @game_state = WinEnum::NEUTRAL
  end

  def game_loop
    update_board
    until @done
      @players.each do |p|
        @game_state = p.take_turn(@gameboard, @ui, @game_state)
        process_action(p, @game_state)
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

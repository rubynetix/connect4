class Game
  def initialize(config)
    raise NotTwoPlayersError unless config.players.size == 2

    @players = config.players
    puts config.gameboard.win_check.wins
    @gameboard = config.gameboard
    @win_check = config.win_check
    @ui = config.ui
    @done = false
    @winner = nil
  end

  def game_loop
    update_board
    until @done
      @players.each do |p|
        p_action = p.take_turn(@gameboard, @ui)
        process_action(p, p_action)
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

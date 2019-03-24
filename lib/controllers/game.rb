class Game
  def initialize(config)
    @players = config.players
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
        process_action(p.take_turn(@gameboard, @ui))
        process_state
        update_board
        break if @done
      end
    end
    @ui.game_over(@winner)
  end

  private

  def process_action(action)
    @done = action == PlayerAction::FORFEIT
  end

  def process_state
    case @win_check.check @gameboard
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

  def update_board
    puts "\n--------- GAMESTATE ---------"
    puts @gameboard.to_s
    @ui.draw_gameboard(@gameboard)
  end
end
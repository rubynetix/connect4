class Game
  def initialize(players, gameboard, win_check, ui)
    @players = players
    @gameboard = gameboard
    @win_check = win_check
    @ui = ui
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
      end
    end
  end

  private

  def process_action(action)
    @done = action == PlayerAction::FORFEIT
  end

  def process_state
    case @win_check.check(@gameboard)
    when WinEnum::DRAW
      @done = true
    when WinEnum::WIN1 || WinEnum::WIN2
      @done = true
      @winner = @players[0]
    end
  end

  def update_board
    @ui.draw_gameboard(@gameboard)
  end
end
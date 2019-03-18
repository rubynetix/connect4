class Game
  def initialize(players, gameboard, win_check)
    @players = players
    @gameboard = gameboard
    @win_check = win_check
  end

  def game_loop
    raise(NotImplementedError)
    # For each player
    #   get their player action
    #   handle the player action
    #
  end

  def request_player_action(player)
    raise(NotImplementedError)
  end

  def handle_player_action(action)
    raise(NotImplementedError)
  end

  def update_board(action)
    raise(NotImplementedError)
  end
end
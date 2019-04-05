
# Handles game related requests
class GameHandler
  # Creates a new game
  def create(username1, username2)
    { 'id' => 'game_id' }
  end

  # gets the gameboard, player_turn and game_state
  def get(game_id)
    { 'board' => 'game_board', 'turn' => 'player_turn',
      'state' => 'game_state' }
  end

  # Saves the gameboard and player turn
  def put(game_id, game_board, player_turn)
    { 'put' => 'success or fail' }
  end
end

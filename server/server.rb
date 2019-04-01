require 'xmlrpc/server'

# Handles user related requests
class UserHandler

  # Creates a new user
  # returns 'success' or 'failed'
  def create(username)
    # Check if the user exists
    # Add the user to the DB
    success = false
    if success
      return { 'create' => 'success' }
    else
      return { 'create' => 'failed' }
    end
  end

  # Returns games of a user
  def games(username)
    { 'games' => ['list of active game ids'] }
  end

  # Returns a list of all usernames
  def list()
    { 'list' => ['list of names here'] }
  end
end

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

# Handles league related requests
class LeagueHandler
  # Returns league standings of a user
  def standings(username)
    { 'wins' => 'wins', 'losses' => 'losses' }
  end
end

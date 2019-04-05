require 'xmlrpc/server'
require_relative 'db_connection'

# Handles user related requests
class UserHandler

  def initialize
    @conn = Connection.new
  end

  # Creates a new user
  # returns 'success' or 'failed'
  def create(username)
    # Check if the user exists
    # Add the user to the DB
    success = @conn.create_user username
    if success
      return { 'create' => 'success' }
    else
      return { 'create' => 'failed' }
    end
  end

  # Returns games of a user
  def games(username)
    { 'games' => @conn.games username }
  end

  # Returns a list of all usernames
  def list()
    { 'list' => @conn.user_list}
  end
end

# Handles game related requests
class GameHandler
  def initialize
    @conn = Connection.new
  end

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

  def initialize
    @conn = Connection.new
  end

  # Returns league standings of a user
  def standings(username)
    @conn.user_stats username
  end

  # Returns league standings of a user
  def table
    @conn.league
  end
end

def serve
  s = XMLRPC::Server.new(8080)
  s.add_handler('user', UserHandler.new)
  s.add_handler('game', GameHandler.new)
  s.add_handler('league', LeagueHandler.new)
  s.serve
end

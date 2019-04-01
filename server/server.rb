require 'xmlrpc/server'

# Handles user related requests
class UserHandler
  def create(username)
    
    { :success => true }
  end

  # Returns games of a user
  def games(username)
    { 'games' => ['game1', 'game2'] }
  end
end

# Handles game related requests
class GameHandler
  # Creates a new game
  def create(username1, username2)
    { 'game' => ['gamename', username1, username2] }
  end
end

# Handles league related requests
class LeagueHandler
  # Returns league standings of a user
  def standings(username)
    { 'standings' => ['wins', 'losses'] }
  end
end

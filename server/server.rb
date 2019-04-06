require 'xmlrpc/server'
require_relative 'base_handler'
require_relative 'game_handler'
# require_relative 'league_handler'

# Handles user related requests
class UserHandler < BaseHandler

  def valid_username(username)
    /[a-zA-Z0-9_]+/.match(username)[0] == username
  end

  # Creates a new user
  # returns 'success' or 'failed'
  def create(username)
    unless valid_username(username)
      return {
          success: false,
          message: "Username '#{username}' is invalid."
      }
    end

    # Check if the user exists
    if user_exists?(username)
      return {
          success: false,
          message: "Username '#{username}' is already taken."
      }
    end

    # Add the user to the DB
    @db_client.query("INSERT INTO users (username) VALUES ('#{username}')")

    if user_exists?(username)
      return { success: true }
    end

    { success: false, message: "User creation failed." }
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

def serve(port: 8080)
  s = XMLRPC::Server.new(port)
  s.add_handler('user', UserHandler.new)
  s.add_handler('game', GameHandler.new)
  # s.add_handler('league', LeagueHandler.new)
  s.serve
end

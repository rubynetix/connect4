require_relative 'base_handler'

# Handles user related requests
class UserHandler < BaseHandler

  def valid_username(username)
    /[a-zA-Z_]+/.match(username)[0] == username
  end

  # Creates a new user
  # returns 'success' or 'failed'
  def create(username)
    unless valid_username(username)
      return {
          :success => false,
          :message => "Username '#{username}' is invalid."
      }
    end

    # Check if the user exists
    if user_exists?(username)
      return {
          :success => false,
          :message => "Username '#{username}' is already taken."
      }
    end

    # Add the user to the DB
    @db_client.query("INSERT INTO users (username) VALUES ('#{username}')")

    if user_exists?(username)
      return { :success => true }
    end

    { :success => false, :message => "User creation failed." }
  end

  # Returns games of a user
  def games(username)
    raise UserDoesNotExist unless user_exists?(username)
    games = []
    result = query("SELECT game_id FROM games WHERE player_1=? or player_2=?",
      username, username, :symbolize_keys => true).each do |row|
        games.append(row[:game_id])
      end
    return { :games => games } # TODO: check if this works
  end

  # Returns a list of all usernames
  def list()
    { 'list' => ['list of names here'] }
  end
end

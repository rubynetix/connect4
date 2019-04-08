require_relative 'base_handler'

# Handles user related requests
class UserHandler < BaseHandler

  def self.endpoints
    [:create, :games, :list]
  end

  def valid_username(username)
    /[a-zA-Z0-9_]+/.match(username)[0] == username
  end

  # Creates a new user
  # returns 'success' or 'failed'
  def create(username)
    raise InvalidUsername unless valid_username(username)
    # Check if the user exists
    raise DuplicateUsers if user_exists?(username)

    # Add the user to the DB
    query("INSERT INTO users (username) VALUES (?)", username)
    { success: true }
  end

  # Returns games of a user
  def games(username)
    raise UserDoesNotExist unless user_exists?(username)
    games = []
    query("SELECT BIN_TO_UUID(game_id) as game_id, p1, p2 FROM games WHERE (p1=? OR p2=?) AND state='active';",
      username, username, :symbolize_keys => true).each do |row|
        if row[:p1] != username
          games.append({ **row, opponent: row[:p1] })
        else
          games.append({ **row, opponent: row[:p2] })
        end
      end
    { :games => games }
  end

  # Returns a list of all usernames
  def list()
    users = []
    query("SELECT username FROM users", :symbolize_keys => true).each do |row|
      users.append(row[:username])
    end
    { :list => users }
  end
end

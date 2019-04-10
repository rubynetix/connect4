require_relative 'enums'
require_relative 'base_handler'

# Handles user related requests
class UserHandler < BaseHandler

  def self.endpoints
    [:create, :games, :list]
  end

  def valid_username(username)
    /[a-zA-Z0-9_]+/.match(username)[0] == username
  end

  def login(username)
    { success: user_exists?(username) }
  end

  # Creates a new user
  # returns 'success' or 'failed'
  def create(username)
    raise InvalidUsername.new("Invalid username #{username}") unless valid_username(username)
    raise DuplicateUsers.new("Username '#{username} already exists.'") if user_exists?(username)

    # Add the user to the DB
    query("INSERT INTO users (username) VALUES (?)", username)
    { success: true }
  end

  # Returns games of a user
  def games(username)
    raise UserDoesNotExist unless user_exists?(username)
    games = []
    query(load_query('user_games'), username, username).each do |row|
      row[:game_type] = GAME_TYPES[row[:game_type].to_sym]
      if row[:p1] != username
        games.append({ **row, opponent: row[:p1] })
      else
        games.append({ **row, opponent: row[:p2] })
      end
    end
    { :games => games }
  end

  # Returns a list of all usernames
  def list
    users = []
    query("SELECT username FROM users").each do |row|
      users.append(row[:username])
    end
    { :list => users }
  end
end

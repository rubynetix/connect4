require 'mysql2'

class BaseHandler

  def initialize
    @db_client = Mysql2::Client.new(
        :host => "localhost",
        :database => "connect4",
        :port => 3306,
        :username => "ece421",
        :password => "ece421")
  end

  def user_exists?(username)
    puts "SELECT * FROM users WHERE username='#{username}'"
    query = @db_client.prepare("SELECT * FROM users WHERE username=?")
    r = query.execute(username)
    r.count > 0
  end

  def get_user(username)
    raise UserDoesNotExist unless user_exists?
    puts "SELECT * FROM users WHERE username='#{username}'"
    query = @db_client.prepare("SELECT * FROM users WHERE username=?")
    r = query.execute(username, :symbolize_keys => true)
    r[:username]
  end

end

class UserDoesNotExist < StandardError; end

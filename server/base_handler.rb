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
    r = query("SELECT * FROM users WHERE username=?", username, :symbolize_keys => true)
    r.count > 0
  end

  def get_user(username)
    raise UserDoesNotExist unless user_exists? username
    r = query("SELECT * FROM users WHERE username=?", username, :symbolize_keys => true)
    r[:username]
  end

  def query(sql, *args, **kwargs)
    @db_client.prepare(sql)
    r = query.execute(*args, **kwargs)
    r
  end

end

class UserDoesNotExist < StandardError; end

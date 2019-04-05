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
    raise DuplicateUsers if r.count > 1

    r.first[:username]
  end

  def query(sql, *args, **kwargs)
    statement = @db_client.prepare(sql)
    r = statement.execute(*args, **kwargs)
    r
  end

  def transaction
    raise ArgumentError, 'No block was given' unless block_given?

    begin
      @db_client.query('BEGIN')
      yield
      @db_client.query('COMMIT')
      true
    rescue
      @db_client.query('ROLLBACK')
      false
    end
  end

end

class UserDoesNotExist < StandardError; end
class DuplicateUsers < StandardError; end

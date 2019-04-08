require 'mysql2'


def prod_db
  Mysql2::Client.new(
      :host => "localhost",
      :database => "connect4",
      :port => 3306,
      :username => "ece421",
      :password => "ece421")
end


def abs_path(path)
  "#{File.expand_path(__dir__)}/#{path}"
end


class BaseHandler

  def initialize(opts = {})
    @db_client = opts[:db_client] || prod_db
  end

  def user_exists?(username)
    exists?("SELECT * FROM users WHERE username=?", username)
  end

  def get_user(username)
    raise UserDoesNotExist unless user_exists? username

    r = query("SELECT * FROM users WHERE username=?", username, :symbolize_keys => true)
    raise DuplicateUsers if r.count > 1

    r.first[:username]
  end

  def query(sql, *args, **kwargs)
    statement = @db_client.prepare(sql)
    statement.execute(*args, symbolize_keys: true, **kwargs)
  end

  def exists?(sql, *args, **kwargs)
    r = query(sql, *args, **kwargs)
    r.count > 0
  end

  def load_query(qname)
    File.read(abs_path("queries/#{qname}.sql"))
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

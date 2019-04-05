require 'mysql2'



class BaseHandler

  def self.default_opts
    @default_opts ||= {
        :db_client => Mysql2::Client.new(
            :host => "localhost",
            :database => "connect4",
            :port => 3306,
            :username => "ece421",
            :password => "ece421")
    }
  end

  def initialize(opts = {})
    @opts = self.class.default_opts.dup
    @opts.merge! opts

    @db_client = @opts[:db_client]
  end

  def user_exists?(username)
    puts "SELECT * FROM users WHERE username='#{username}'"
    r = @db_client.query("SELECT * FROM users WHERE username='#{username}'")
    r.count > 0
  end

  def get_user(username)
    raise UserDoesNotExist unless user_exists?
    puts "SELECT * FROM users WHERE username='#{username}'"
    r = @db_client.query("SELECT * FROM users WHERE username='#{username}'",
                     :symbolize_keys => true)
    r[:username]
  end

end

class UserDoesNotExist < StandardError; end

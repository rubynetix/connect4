require 'mysql2'
require_relative 'server_error'


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

  def self.endpoints
    []
  end

  def self.method_added(name)
    return unless self.endpoints.include?(name)
    return if @__last_endpoint && @__last_endpoint.include?(name)

    endpoint = :"#{name}_endpoint"
    endpoint_impl = :"#{name}__endpoint_impl"
    @__last_endpoint = [name, endpoint, endpoint_impl]

    define_method endpoint do |*args|
      begin
        send endpoint_impl, *args
      rescue StandardError => e
        { exception: Marshal.dump(e) }
      end
    end

    alias_method endpoint_impl, name
    alias_method name, endpoint
    @__last_endpoint = nil
  end

  def initialize(opts = {})
    @db_client = opts[:db_client] || prod_db
  end

  def user_exists?(username)
    exists?("SELECT * FROM users WHERE username=?", username)
  end

  def get_user(username)
    raise UserDoesNotExist unless user_exists? username

    r = query("SELECT * FROM users WHERE username=?", username)
    raise DuplicateUsers if r.count > 1

    r.first[:username]
  end

  def query(sql, *args, **kwargs)
    statement = @db_client.prepare(sql)
    statement.execute(*args, **kwargs, symbolize_keys: true)
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
    rescue Mysql2::Error => e
      @db_client.query('ROLLBACK')
      raise e
    end
  end

end

require 'mysql2'

class Connection

  def initialize(host: '162.246.157.188', port: '3306', user: 'ece421', db: 'connect4')
    @conn = Mysql2::Client.new(:host => host, :username => user, :port => port, :database => db, :password => 'password')
    puts @conn.server_info
  end

  def create_user(id)
    begin
      query = @conn.prepare("Insert into users (username) value (?);")
      query.execute(id)
      return true
    rescue
      false
    end
  end

  def get_user(id)
    query = @conn.prepare("Select * from users Where username=?;")
    result = query.execute(id)
    result.each { |row| return row['username']}
  end

  def games(user)
    query = @conn.prepare("SELECT game_id FROM games WHERE player_1=? OR player_2=?")
    query.execute(user, user, :as => :array).to_a
  end
end
require 'Mysql2'

class Database

  def initialise(host: '162.246.157.188', port: '3306', user: 'ece421', db: 'ece421')
    @conn = Mysql2::Client.new(:host => host, :username => user, :port => port, :database => db, :password => 'password')
  end

  def create_user(id)
    #
  end

  def games(user)
    results = @conn.query("SELECT game_id FROM games WHERE player_1="+user+" OR player_2="+user)
    puts results
  end
end

db = Database.new
db.games 'ryan'
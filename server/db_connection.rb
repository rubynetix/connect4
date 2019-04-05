require 'mysql2'

# Handles transactions to the mysql database
class Connection
  def initialize(host: '162.246.157.188', port: '3306', user: 'ece421', db: 'connect4')
    @conn = Mysql2::Client.new(host: host, username: user, port: port, database: db, password: 'password')
    puts @conn.server_info
  end

  def create_user(id)
    query = @conn.prepare('Insert into users (username) value (?);')
    query.execute(id)
    true
  rescue
    false
  end

  def user_exists?(id)
    query = @conn.prepare('Select * from users Where username=?;')
    result = query.execute(id)
    result.each {|row| return true}
    false
  end

  def user_list
    query = @conn.prepare('Select * from users')
    query.execute(as: :array).to_a
  end

  def create_game(p1, p2)
    #
  end

  def games(user)
    query = @conn.prepare('SELECT game_id FROM games WHERE player_1=? OR player_2=?')
    query.execute(user, user, as: :array).to_a
  end

  def update_game(game_id, board, turn, state)
    transaction do
      query = @conn.prepare('Update game_boards SET board=? WHERE game_id=?')
      query.execute(board, game_id)
      query = @conn.prepare('Update games SET state=? WHERE game_id=?')
      query.execute(state, game_id)
    end
    true
  rescue
    false
  end

  def league
    query = "Select username, SUM(wins) As Wins, SUM(losses) As Lossses, "\
            "SUM(draws) As Draws FROM("\
    "SELECT player1 as username, "\
    "count(case state when 'W1' then 1 else null end) AS wins, "\
    "count(case state when 'W2' then 1 else null end) AS losses, "\
    "count(case state when 'D' then 1 else null end) AS draws "\
    "FROM games "\
    "Group by player1 "\
    "UNION "\
    "SELECT player2 as username, "\
    "count(case state when 'W2' then 1 else null end) AS wins, "\
    "count(case state when 'W1' then 1 else null end) AS losses, "\
    "count(case state when 'D' then 1 else null end) AS draws "\
    "FROM games "\
    "Group by player2) GROUP BY username;"
    puts query
  end

  def user_stats(username)

  end

  private

  def transaction
    raise ArgumentError, 'No block was given' unless block_given?

    begin
      @conn.query('BEGIN')
      yield
      @conn.query('COMMIT')
    rescue
      @conn.query('ROLLBACK')
    end
  end
end

Connection.league
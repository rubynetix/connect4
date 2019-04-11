require_relative 'base_handler'
require_relative 'server_error'

class LeagueHandler < BaseHandler

  def league
    { league: query(load_query("league"))}
  end

  def standings(username)
    raise UserDoesNotExist unless user_exists? username

    r = query(load_query('stats'), username).to_a[0]
    r
  end
end

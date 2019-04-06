require_relative 'base_handler'

class LeagueHandler < BaseHandler

  def league
    sql = ""\
    "Select username, cast(SUM(wins) as char(4)) As Wins, cast(SUM(losses) as char(4)) As Losses, cast(SUM(draws) as char(4)) As Draws "\
    "FROM (SELECT player_1                                          as username, "\
    "         count(case state when 'w1' then 1 else null end) AS wins, "\
    "         count(case state when 'w2' then 1 else null end) AS losses, "\
    "         count(case state when 'd' then 1 else null end)  AS draws "\
    "  FROM games "\
    "  Group by player_1 "\
    "  UNION "\
    "  SELECT player_2                                          as username, "\
    "         count(case state when 'w2' then 1 else null end) AS wins, "\
    "         count(case state when 'w1' then 1 else null end) AS losses, "\
    "         count(case state when 'd' then 1 else null end)  AS draws "\
    "  FROM games "\
    "  Group by player_2) As League "\
    "GROUP BY username "\
    "ORDER BY score(SUM(wins), SUM(losses), SUM(draws)) DESC;"
    { league: @db_client.query(sql, :symbolize_keys => true).to_a}
  end

  def standings(username)
    sql = ""\
    "Select cast(SUM(wins) as char(4)) As Wins, cast(SUM(losses) as char(4)) As Losses, cast(SUM(draws) as char(4)) As Draws "\
    "FROM (SELECT count(case state when 'w1' then 1 else null end) AS wins, "\
    "         count(case state when 'w2' then 1 else null end) AS losses, "\
    "         count(case state when 'd' then 1 else null end)  AS draws "\
    "  FROM games "\
    "  Where player_1 = ? "\
    "  UNION "\
    "  SELECT count(case state when 'w2' then 1 else null end) AS wins, "\
    "         count(case state when 'w1' then 1 else null end) AS losses, "\
    "         count(case state when 'd' then 1 else null end)  AS draws "\
    "  FROM games "\
    "  Where player_2 = ?) As Standings;"
    r = query(sql, username, username, :symbolize_keys => true).to_a[0]
    r
  end
end

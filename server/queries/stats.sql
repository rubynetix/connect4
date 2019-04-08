Select cast(SUM(wins) as char(4)) As Wins, cast(SUM(losses) as char(4)) As Losses, cast(SUM(draws) as char(4)) As Draws 
    FROM (SELECT count(case state when 'w1' then 1 else null end) AS wins, 
             count(case state when 'w2' then 1 else null end) AS losses, 
             count(case state when 'draw' then 1 else null end)  AS draws
      FROM games 
      Where p1 = ?
      UNION 
      SELECT count(case state when 'w2' then 1 else null end) AS wins, 
             count(case state when 'w1' then 1 else null end) AS losses, 
             count(case state when 'draw' then 1 else null end)  AS draws
      FROM games 
      Where p2 = ?) As Standings;
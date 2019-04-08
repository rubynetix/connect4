Select username,
       cast(SUM(wins) as char(4))   As Wins,
       cast(SUM(losses) as char(4)) As Losses,
       cast(SUM(draws) as char(4))  As Draws
FROM (SELECT p1                                         as username,
             count(case state when 'w1' then 1 else null end) AS wins,
             count(case state when 'w2' then 1 else null end) AS losses,
             count(case state when 'draw' then 1 else null end)  AS draws
      FROM games
      Group by p1
      UNION
      SELECT p1                                         as username,
             count(case state when 'w2' then 1 else null end) AS wins,
             count(case state when 'w1' then 1 else null end) AS losses,
             count(case state when 'draw' then 1 else null end)  AS draws
      FROM games
      Group by p1) As League
GROUP BY username
ORDER BY score(SUM(wins), SUM(losses), SUM(draws)) DESC;
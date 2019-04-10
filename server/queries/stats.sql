Select username,
       cwins,
       closses,
       cdraws,
       cgames,
       owins,
       olosses,
       odraws,
       ogames,
       games,
       rank
From (Select *, ogames + cgames As games, @curRank := @curRank + 1 AS rank
      FROM users u, (SELECT @curRank := 0) r
  Order By score(cwins+owins, closses+olosses, cdraws+odraws)) As League
Where username = ?;
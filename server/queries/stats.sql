Select username,
       c4_wins,
       c4_losses,
       c4_draws,
       c4_games,
       to_wins,
       to_losses,
       to_draws,
       to_games,
       rank
From (Select *, @curRank := @curRank + 1 AS rank
      FROM users u, (SELECT @curRank := 0) r
  Order By score(c4_wins+to_wins, c4_losses+to_losses, c4_draws+to_draws) desc) As League
Where username = ?;

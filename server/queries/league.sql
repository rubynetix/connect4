Select username,
       c4_wins,
       c4_losses,
       c4_draws,
       c4_games,
       to_wins,
       to_losses,
       to_draws,
       to_games
FROM users
Order By score(c4_wins+to_wins, c4_losses+to_losses, c4_draws+to_draws) desc;

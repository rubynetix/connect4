SELECT BIN_TO_UUID(game_id) as game_id, type as game_type, p1, p2
FROM games
WHERE (p1=? OR p2=?)
  AND state='active';

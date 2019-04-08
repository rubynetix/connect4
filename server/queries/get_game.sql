SELECT g.game_id, state, turn, board
FROM games g
  JOIN game_boards gb
  ON g.game_id = gb.game_id
WHERE game_id=?;

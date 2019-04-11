SELECT BIN_TO_UUID(g.game_id) as game_id, state, turn, board
FROM games g
  JOIN game_boards gb
  ON g.game_id = gb.game_id
WHERE g.game_id=UUID_TO_BIN(?);

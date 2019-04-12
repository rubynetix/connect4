SELECT BIN_TO_UUID(g.game_id) as game_id, state, turn, board
FROM games g
WHERE g.game_id=UUID_TO_BIN(?);

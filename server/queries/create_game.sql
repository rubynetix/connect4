INSERT INTO games (game_id, type, turn, state, p1, p2, board)
VALUES (UUID_TO_BIN(?), ?, ?, 'active', ?, ?, ?);

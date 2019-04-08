INSERT INTO games (game_id, type, state, p1, p2, turn)
VALUES (UUID_TO_BIN(?), ?, 'active', ?, ?, ?);

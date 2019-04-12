DELETE from games;
DELETE from users;
INSERT INTO users (username) VALUES
  ("conservative"), ("ndp"), ("liberal"), ("green"), ("rhinoceros");
INSERT INTO games (game_id, type, state, turn, p1, p2, board) VALUES
  (UUID_TO_BIN(?), "connect4", "active", "conservative", "conservative", "liberal", "Gameboard"),
  (UUID_TO_BIN(?), "connect4", "active", "ndp", "ndp", "conservative", "Gameboard"),
  (UUID_TO_BIN(?), "connect4", "active", "rhinoceros", "green", "rhinoceros", "Gameboard"),
  (UUID_TO_BIN(?), "toototto", "active", "liberal", "conservative", "liberal", "Gameboard"),
  (UUID_TO_BIN(?), "toototto", "active", "ndp", "ndp", "conservative", "Gameboard"),
  (UUID_TO_BIN(?), "toototto", "active", "green", "green", "rhinoceros", "Gameboard");

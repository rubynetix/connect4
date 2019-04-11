DELETE from games;
DELETE from users;

INSERT INTO users (username) VALUES ("conservative");
INSERT INTO users (username) VALUES ("ndp");
INSERT INTO users (username) VALUES ("liberal");
INSERT INTO users (username) VALUES ("green");
INSERT INTO users (username) VALUES ("rhinoceros");

INSERT INTO games (game_id, type, state, turn, p1, p2) VALUES (1, "connect4", "active", "conservative", "conservative", "liberal");
INSERT INTO games (game_id, type, state, turn, p1, p2) VALUES (2, "connect4", "active", "ndp", "ndp", "conservative");
INSERT INTO games (game_id, type, state, turn, p1, p2) VALUES (3, "connect4", "active", "rhinoceros", "green", "rhinoceros");

INSERT INTO games (game_id, type, state, turn, p1, p2) VALUES (4, "toototto", "active", "liberal", "conservative", "liberal");
INSERT INTO games (game_id, type, state, turn, p1, p2) VALUES (5, "toototto", "active", "ndp", "ndp", "conservative");
INSERT INTO games (game_id, type, state, turn, p1, p2) VALUES (6, "toototto", "active", "green", "green", "rhinoceros");

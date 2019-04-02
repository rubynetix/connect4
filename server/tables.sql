USE connect4;

# Cleanup tables if they exist
DROP TABLE IF EXISTS game_boards;
DROP TABLE IF EXISTS games;
DROP TABLE IF EXISTS users;

CREATE TABLE IF NOT EXISTS users(
  username char,
  PRIMARY KEY (username)
);

CREATE TABLE IF NOT EXISTS games(
  game_id INTEGER,
  type ENUM('C','T') NOT NULL,
  state ENUM('W1', 'W2', 'D', 'P1', 'P2') NOT NULL,
  player_1 char NOT NULL,
  player_2 char NOT NULL,
  FOREIGN KEY (player_1) REFERENCES users(username),
  FOREIGN KEY (player_2) REFERENCES users(username),
  PRIMARY KEY (game_id)
);

CREATE TABLE IF NOT EXISTS game_boards(
  game_id INTEGER NOT NULL,
  board BLOB NOT NULL,
  FOREIGN KEY (game_id) REFERENCES games(game_id) ON DELETE CASCADE
);

# Note these may error if exists
CREATE INDEX games_p1 ON games(player_1);
CREATE INDEX games_p2 ON games(player_2);

DELIMITER $$
CREATE TRIGGER game_ends
  AFTER UPDATE ON games FOR EACH ROW
  BEGIN
    IF new.state IN ('W1', 'W2', 'D') THEN
      DELETE FROM game_boards WHERE game_id = NEW.game_id;
      IF NEW.player_2 LIKE 'Computer%' THEN
        DELETE FROM games WHERE game_id = NEW.game_id;
      end if;
    end if;
  END$$
DELIMITER ;
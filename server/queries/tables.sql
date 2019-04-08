USE connect4;

# Cleanup tables if they exist
DROP TABLE IF EXISTS game_boards;
DROP TABLE IF EXISTS games;
DROP TABLE IF EXISTS users;

CREATE TABLE IF NOT EXISTS users (
  username VARCHAR(50),
  PRIMARY KEY (username)
);

CREATE TABLE IF NOT EXISTS games (
  game_id BINARY(16) PRIMARY KEY,
  type ENUM('c','t') NOT NULL,
  state ENUM('w1', 'w2', 'draw', 'active') NOT NULL,
  turn VARCHAR (50) NOT NULL,
  p1 VARCHAR(50) NOT NULL,
  p2 VARCHAR(50) NOT NULL,
  FOREIGN KEY (p1) REFERENCES users(username),
  FOREIGN KEY (p2) REFERENCES users(username)
);

CREATE TABLE IF NOT EXISTS game_boards (
  game_id BINARY(16) NOT NULL,
  board BLOB NOT NULL,
  FOREIGN KEY (game_id) REFERENCES games(game_id) ON DELETE CASCADE
);

CREATE INDEX games_p1 ON games(p1);
CREATE INDEX games_p2 ON games(p2);

DELIMITER $$
CREATE TRIGGER game_ends
  AFTER UPDATE ON games FOR EACH ROW
  BEGIN
    IF NEW.state IN ('w1', 'w2', 'draw') THEN
      DELETE FROM game_boards WHERE game_id = NEW.game_id;
    end if;
  END$$
DELIMITER ;

USE connect4;

# Cleanup tables if they exist
DROP TABLE IF EXISTS game_boards;
DROP TABLE IF EXISTS games;
DROP TABLE IF EXISTS c4_stats;
DROP TABLE IF EXISTS otto_stats;
DROP TABLE IF EXISTS users;
DROP FUNCTION IF EXISTS score;

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

CREATE TABLE IF NOT EXISTS c4_stats (
                                            pid VARCHAR(50) NOT NULL,
                                            wins INTEGER NOT NULL DEFAULT 0,
                                            losses INTEGER NOT NULL DEFAULT 0,
                                            draws INTEGER NOT NULL DEFAULT 0,
                                            games INTEGER NOT NULL DEFAULT 0,
                                            PRIMARY KEY(pid),
                                            FOREIGN KEY (pid) REFERENCES users(username)
);

CREATE TABLE IF NOT EXISTS otto_stats (
                                        pid VARCHAR(50) NOT NULL,
                                        wins INTEGER NOT NULL DEFAULT 0,
                                        losses INTEGER NOT NULL DEFAULT 0,
                                        draws INTEGER NOT NULL DEFAULT 0,
                                        games INTEGER NOT NULL DEFAULT 0,
                                            PRIMARY KEY(pid),
                                            FOREIGN KEY (pid) REFERENCES users(username)
);



DELIMITER $$

# Make stats
CREATE TRIGGER make_stats
  AFTER INSERT ON users FOR EACH ROW
BEGIN
  INSERT INTO c4_stats(pid, wins, losses, draws, games) VALUES (NEW.username, 0,0,0,0);
  INSERT INTO otto_stats(pid, wins, losses, draws, games) VALUES (NEW.username, 0,0,0,0);
END$$

CREATE TRIGGER no_player_changes
  BEFORE UPDATE ON games FOR EACH ROW
BEGIN
  IF NEW.p1 != OLD.p1 OR NEW.p2 != OLD.p2 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = "Cannot change the player!";
  end if;
END$$


CREATE TRIGGER gameboard_delete
  AFTER UPDATE ON games FOR EACH ROW
BEGIN
  IF NEW.state IN ('w1', 'w2', 'draw') THEN
    DELETE FROM game_boards WHERE game_id = NEW.game_id;
  end if;
END$$

CREATE TRIGGER game_win1
  AFTER UPDATE ON games FOR EACH ROW
BEGIN
  IF NEW.state = 'w1' THEN
    IF NEW.type = 'c' THEN
      UPDATE c4_stats SET wins = wins + 1, games = games + 1 WHERE pid = p1;
      UPDATE c4_stats SET losses = losses + 1, games = games + 1 WHERE pid = p2;
    ELSE
      UPDATE otto_stats SET wins = wins + 1, games = games + 1 WHERE pid = p1;
      UPDATE otto_stats SET losses = losses + 1, games = games + 1 WHERE pid = p2;
    end if;
  end if;
END$$

CREATE TRIGGER game_win2
  AFTER UPDATE ON games FOR EACH ROW
BEGIN
  IF NEW.state = 'w2' THEN
    IF NEW.type = 'c' THEN
      UPDATE c4_stats SET wins = wins + 1, games = games + 1 WHERE pid = p2;
      UPDATE c4_stats SET losses = losses + 1, games = games + 1 WHERE pid = p1;
    ELSE
      UPDATE otto_stats SET wins = wins + 1, games = games + 1 WHERE pid = p2;
      UPDATE otto_stats SET losses = losses + 1, games = games + 1 WHERE pid = p1;
    end if;
  end if;
END$$

CREATE TRIGGER game_draw
  AFTER UPDATE ON games FOR EACH ROW
BEGIN
  IF NEW.state = 'draw' THEN
    IF NEW.type = 'c' THEN
      UPDATE c4_stats SET draws = draws + 1, games = games + 1 WHERE pid = p2;
      UPDATE c4_stats SET draws = draws + 1, games = games + 1 WHERE pid = p1;
    ELSE
      UPDATE otto_stats SET draws = draws + 1, games = games + 1 WHERE pid = p2;
      UPDATE otto_stats SET draws = draws + 1, games = games + 1 WHERE pid = p1;
    end if;
  end if;
END$$
DELIMITER ;

CREATE FUNCTION score(wins INTEGER, losses INTEGER, draws INTEGER)
  RETURNS INTEGER DETERMINISTIC
RETURN wins * 2 - losses * 2 + draws;

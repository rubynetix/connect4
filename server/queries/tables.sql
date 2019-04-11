USE connect4;

# Cleanup tables if they exist
DROP TABLE IF EXISTS game_boards;
DROP TABLE IF EXISTS games;
DROP TABLE IF EXISTS c4_stats;
DROP TABLE IF EXISTS otto_stats;
DROP TABLE IF EXISTS users;
DROP FUNCTION IF EXISTS score;

CREATE TABLE IF NOT EXISTS users
(
  username VARCHAR(50),
  cwins   INTEGER     NOT NULL DEFAULT 0,
  closses INTEGER     NOT NULL DEFAULT 0,
  cdraws  INTEGER     NOT NULL DEFAULT 0,
  cgames  INTEGER     NOT NULL DEFAULT 0,
  owins   INTEGER     NOT NULL DEFAULT 0,
  olosses INTEGER     NOT NULL DEFAULT 0,
  odraws  INTEGER     NOT NULL DEFAULT 0,
  ogames  INTEGER     NOT NULL DEFAULT 0,
  PRIMARY KEY (username)
);

CREATE TABLE IF NOT EXISTS games
(
  game_id BINARY(16) PRIMARY KEY,
  type    ENUM ('connect4','toototto')        NOT NULL,
  state   ENUM ('w1', 'w2', 'draw', 'active') NOT NULL,
  turn    VARCHAR(50)                         NOT NULL,
  p1      VARCHAR(50)                         NOT NULL,
  p2      VARCHAR(50)                         NOT NULL,
  FOREIGN KEY (p1) REFERENCES users (username),
  FOREIGN KEY (p2) REFERENCES users (username)
);

CREATE TABLE IF NOT EXISTS game_boards
(
  game_id BINARY(16) NOT NULL,
  board   BLOB       NOT NULL,
  FOREIGN KEY (game_id) REFERENCES games (game_id) ON DELETE CASCADE
);


DELIMITER $$

# TODO: stats can only be reset or incremented

CREATE TRIGGER no_player_or_type_changes
  BEFORE UPDATE
  ON games
  FOR EACH ROW
BEGIN
  IF NEW.p1 != OLD.p1 OR NEW.p2 != OLD.p2 OR NEW.type != OLD.type THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = "Cannot change the players or type in a game entry!";
  end if;
END$$

CREATE TRIGGER no_changing_finished_game_states
  BEFORE UPDATE
  ON games
  FOR EACH ROW
BEGIN
  IF OLD.state IN ('w1', 'w2', 'draw') THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = "Cannot change game ending!";
  end if;
END$$

CREATE TRIGGER no_adding_finished_game
  BEFORE INSERT
  ON games
  FOR EACH ROW
BEGIN
  IF NEW.state IN ('w1', 'w2', 'draw') THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = "Cannot add finished games!";
  end if;
END$$


CREATE TRIGGER gameboard_delete
  AFTER UPDATE
  ON games
  FOR EACH ROW
BEGIN
  IF NEW.state IN ('w1', 'w2', 'draw') THEN
    DELETE FROM game_boards WHERE game_id = NEW.game_id;
  end if;
END$$

CREATE TRIGGER game_win1
  AFTER UPDATE
  ON games
  FOR EACH ROW
BEGIN
  IF NEW.state = 'w1' THEN
    IF NEW.type = 'c' THEN
      UPDATE users SET cwins = cwins + 1, cgames = cgames + 1 WHERE username = NEW.p1;
      UPDATE users SET closses = closses + 1, cgames = cgames + 1 WHERE username = NEW.p2;
    ELSE
      UPDATE users SET owins = owins + 1, ogames = ogames + 1 WHERE username = NEW.p1;
      UPDATE users SET olosses = olosses + 1, ogames = ogames + 1 WHERE username = NEW.p2;
    end if;
  end if;
END$$

CREATE TRIGGER game_win2
  AFTER UPDATE
  ON games
  FOR EACH ROW
BEGIN
  IF NEW.state = 'w2' THEN
    IF NEW.type = 'c' THEN
      UPDATE users SET cwins = cwins + 1, cgames = cgames + 1 WHERE username = NEW.p2;
      UPDATE users SET closses = closses + 1, cgames = cgames + 1 WHERE username = NEW.p1;
    ELSE
      UPDATE users SET owins = owins + 1, ogames = ogames + 1 WHERE username = NEW.p2;
      UPDATE users SET olosses = olosses + 1, ogames = ogames + 1 WHERE username = NEW.p1;
    end if;
  end if;
END$$

CREATE TRIGGER game_draw
  AFTER UPDATE
  ON games
  FOR EACH ROW
BEGIN
  IF NEW.state = 'draw' THEN
    IF NEW.type = 'c' THEN
      UPDATE users SET cdraws = cdraws + 1, cgames = cgames + 1 WHERE username = NEW.p2;
      UPDATE users SET cdraws = cdraws + 1, cgames = cgames + 1 WHERE username = NEW.p1;
    ELSE
      UPDATE users SET odraws = odraws + 1, ogames = ogames + 1 WHERE username = NEW.p2;
      UPDATE users SET odraws = odraws + 1, ogames = ogames + 1 WHERE username = NEW.p1;
    end if;
  end if;
END$$
DELIMITER ;

CREATE FUNCTION score(wins INTEGER, losses INTEGER, draws INTEGER)
  RETURNS INTEGER DETERMINISTIC
RETURN wins * 2 - losses * 2 + draws;

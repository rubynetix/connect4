UPDATE game_boards SET board = ?
WHERE game_id = UUID_TO_BIN(?);

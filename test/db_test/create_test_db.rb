require 'mysql2'
require 'uuid'
require_relative '../../server/base_handler'
require_relative '../../client/models/game_board'
require_relative '../../client/models/counter'

class TestDBHandler < BaseHandler

  def initialize
    super
    @uuid = UUID.new
    @game_uuids = []
    @boards = Hash.new
    query("DELETE from games;")
    query("DELETE from users;")
    load_users
    load_games
    load_boards
  end

  private

  def load_users
    File.open(Dir.pwd + '/test/db_test/queries/create_test_db_users.sql').each do |line|
      query(line)
    end
  end

  def load_games
    File.open(Dir.pwd + '/test/db_test/queries/create_test_db_games.sql').each do |line|
      game_id = @uuid.generate
      @game_uuids.append(game_id)
      query(line, game_id)
    end
  end

  def make_boards
    board1 = GameBoard.connect4
    board1.place(YellowCounter.instance, 0)
    board1.place(RedCounter.instance, 1)
    board1.place(YellowCounter.instance, 2)
    board1.place(RedCounter.instance, 3)
    board2 = GameBoard.connect4
    board2.place(YellowCounter.instance, 0)
    board2.place(RedCounter.instance, 1)
    board2.place(YellowCounter.instance, 2)
    board2.place(RedCounter.instance, 3)
    board3 = GameBoard.connect4
    board3.place(YellowCounter.instance, 0)
    board3.place(RedCounter.instance, 1)
    board3.place(YellowCounter.instance, 2)
    board3.place(RedCounter.instance, 3)
    board4 = GameBoard.toot_otto
    board4.place(TCounter.instance, 0)
    board4.place(OCounter.instance, 1)
    board4.place(TCounter.instance, 2)
    board4.place(OCounter.instance, 3)
    board5 = GameBoard.toot_otto
    board5.place(TCounter.instance, 0)
    board5.place(OCounter.instance, 1)
    board5.place(TCounter.instance, 2)
    board5.place(OCounter.instance, 3)
    board6 = GameBoard.toot_otto
    board6.place(TCounter.instance, 0)
    board6.place(OCounter.instance, 1)
    board6.place(TCounter.instance, 2)
    board6.place(OCounter.instance, 3)
    boards = [board6, board5, board4, board3, board2, board1]
    # Map boards to the game ids
    @game_uuids.each do |uuid|
      @boards[uuid] = boards.pop
    end
  end

  def load_boards
    make_boards
    @game_uuids.each do |uuid|
      line = "INSERT INTO game_boards (game_id, board) VALUES (UUID_TO_BIN(?), ?)"
      query(line, uuid, Marshal.dump(@boards[uuid]))
    end
  end
end


tdbh = TestDBHandler.new
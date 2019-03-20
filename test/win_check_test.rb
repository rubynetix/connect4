require 'test/unit'
require_relative '../lib/models/game_board'
require_relative '../lib/models/o_counter'
require_relative '../lib/models/t_counter'
require_relative '../lib/models/red_counter'
require_relative '../lib/models/yellow_counter'
require_relative '../lib/models/otto_win_check'
require_relative '../lib/models/toot_win_check'
require_relative '../lib/models/red_win_check'
require_relative '../lib/models/yellow_win_check'

class WinCheckTest < Test::Unit::TestCase
  TEST_ITER = 10

  def _setup

  end

  def teardown; end

  def board_counter_check(board, valid_counters)
    # TODO: Check that all counters on the board are in the list of valid_counters
    return TRUE
  end

  def generate_red_yellow_win_boards(winning_counter, losing_counter)
    board_list = []

    horiz_win_board = GameBoard.new(5)
    horiz_win_board.place(winning_counter, 1)
    horiz_win_board.place(winning_counter, 2)
    horiz_win_board.place(winning_counter, 3)
    horiz_win_board.place(winning_counter, 4)
    board_list.push(horiz_win_board)

    vert_win_board = GameBoard.new(5)
    vert_win_board.place(winning_counter, 1)
    vert_win_board.place(winning_counter, 1)
    vert_win_board.place(winning_counter, 1)
    vert_win_board.place(winning_counter, 1)
    board_list.push(vert_win_board)

    diag_win_board = GameBoard.new( 5)
    diag_win_board.place(winning_counter, 1)
    diag_win_board.place(losing_counter, 2)
    diag_win_board.place(winning_counter, 2)
    diag_win_board.place(losing_counter, 3)
    diag_win_board.place(losing_counter, 3)
    diag_win_board.place(winning_counter, 3)
    diag_win_board.place(losing_counter, 4)
    diag_win_board.place(losing_counter, 4)
    diag_win_board.place(losing_counter, 4)
    diag_win_board.place(winning_counter, 4)
    board_list.push(diag_win_board)

    return board_list
  end

  def generate_otto_win_boards
    board_list = []

    horiz_win_board = GameBoard.new(5)
    horiz_win_board.place(OCounter.instance, 1)
    horiz_win_board.place(TCounter.instance, 2)
    horiz_win_board.place(TCounter.instance, 3)
    horiz_win_board.place(OCounter.instance, 4)
    board_list.push(horiz_win_board)

    vert_win_board = GameBoard.new(5)
    vert_win_board.place(OCounter.instance, 1)
    vert_win_board.place(TCounter.instance, 1)
    vert_win_board.place(TCounter.instance, 1)
    vert_win_board.place(OCounter.instance, 1)
    board_list.push(vert_win_board)

    return board_list
  end

  def generate_toot_win_boards
    board_list = []

    horiz_win_board = GameBoard.new(5)
    horiz_win_board.place(TCounter.instance, 1)
    horiz_win_board.place(OCounter.instance, 2)
    horiz_win_board.place(OCounter.instance, 3)
    horiz_win_board.place(TCounter.instance, 4)
    board_list.push(horiz_win_board)

    vert_win_board = GameBoard.new(5)
    vert_win_board.place(TCounter.instance, 1)
    vert_win_board.place(OCounter.instance, 1)
    vert_win_board.place(OCounter.instance, 1)
    vert_win_board.place(TCounter.instance, 1)
    board_list.push(vert_win_board)

    return board_list
  end

  #### TESTING ####

  def tst_ot_neutral
    ot_neutral_board = GameBoard.new(5)
    ot_neutral_board.place(OCounter.instance, 1)
    ot_neutral_board.place(TCounter.instance, 4)

    # Preconditions
    begin
      assert_true( ot_neutral_board.is_a?(GameBoard), "Board is not of type GameBoard")
      assert_true( board_counter_check(ot_neutral_board, [OCounter.instance, TCounter.instance]), "GameBoard contains invalid counter types")
    end

    otto_result = OttoWinCheck.new().is_winner?(ot_neutral_board)
    toot_result = TootWinCheck.new().is_winner?(ot_neutral_board)

    # Postconditions
    begin
      assert_false(otto_result, "OTTO win check incorrectly found a win on a neutral board")
      assert_false(toot_result, "TOOT win check incorrectly found a win on a neutral board")
    end
  end

  def tst_otto_win
    otto_win_boards = generate_otto_win_boards()

    otto_win_boards.each do |otto_win_board|
      # Preconditions
      begin
        assert_true( otto_win_board.is_a?(GameBoard), "Board is not of type GameBoard")
        assert_true( board_counter_check(otto_win_board, [OCounter.instance, TCounter.instance]), "GameBoard contains invalid counter types")
      end

      otto_result = OttoWinCheck.new().is_winner?(otto_win_board)
      toot_result = TootWinCheck.new().is_winner?(otto_win_board)

      # Postconditions
      begin
        assert_true(otto_result, "OTTO missed win on a winning board")
        assert_false(toot_result, "TOOT incorrectly found a win on a losing board")
      end
    end
  end


  def tst_toot_win
    toot_win_boards = generate_otto_win_boards()

    toot_win_boards.each do |toot_win_board|

      # Preconditions
      begin
        assert_true( toot_win_board.is_a?(GameBoard), "Board is not of type GameBoard")
        assert_true( board_counter_check(toot_win_board, [OCounter.instance, TCounter.instance]), "GameBoard contains invalid counter types")
      end

      otto_result = OttoWinCheck.new().is_winner?(toot_win_board)
      toot_result = TootWinCheck.new().is_winner?(toot_win_board)

      # Postconditions
      begin
        assert_false(otto_result, "OTTO incorrectly found a win on a losing board")
        assert_true(toot_result, "TOOT missed win on a winning board")
      end
    end
  end


  def tst_red_yellow_neutral
    red_yellow_neutral_board = GameBoard.new(5)
    red_yellow_neutral_board.place(RedCounter.Instance, 1)
    red_yellow_neutral_board.place(YellowCounter.Instance, 1)

    # Preconditions
    begin
      assert_true( red_yellow_neutral_board.is_a?(GameBoard), "Board is not of type GameBoard")
      assert_true( board_counter_check(red_yellow_neutral_board, [RedCounter.Instance, YellowCounter.Instance]), "GameBoard contains invalid counter types")
    end

    red_result = RedWinCheck.new().is_winner?(red_yellow_neutral_board)
    yellow_result = YellowWinCheck.new().is_winner?(red_yellow_neutral_board)

    # Postconditions
    begin
      assert_false(red_result, "RED win check incorrectly found a win on a neutral board")
      assert_false(yellow_result, "YELLOW win check incorrectly found a win on a neutral board")
    end
  end


  def tst_red_win
    red_win_boards = generate_red_yellow_win_boards(RedCounter.Instance, YellowCounter.Instance)

    red_win_boards.each do |red_win_board|

      # Preconditions
      begin
        assert_true( red_win_board.is_a?(GameBoard), "Board is not of type GameBoard")
        assert_true( board_counter_check(red_win_board, [RedCounter.Instance, YellowCounter.Instance]), "GameBoard contains invalid counter types")
      end

      red_result = RedWinCheck.new().is_winner?(red_win_board)
      yellow_result = YellowWinCheck.new().is_winner?(red_win_board)

      # Postconditions
      begin
        assert_true(red_result, "RED win check missed win on a winning board")
        assert_false(yellow_result, "YELLOW win check incorrectly found a win on a losing board")
      end
    end

  end


  def tst_yellow_win
    yellow_win_boards = generate_red_yellow_win_boards(YellowCounter.Instance, RedCounter.Instance)

    yellow_win_boards.each do |yellow_win_board|
      # Preconditions
      begin
        assert_true( yellow_win_board.is_a?(GameBoard), "Board is not of type GameBoard")
        assert_true( board_counter_check(yellow_win_board, [RedCounter.Instance, YellowCounter.Instance]), "GameBoard contains invalid counter types")
      end

      red_result = RedWinCheck.new().is_winner?(yellow_win_board)
      yellow_result = YellowWinCheck.new().is_winner?(yellow_win_board)

      # Postconditions
      begin
        assert_false(red_result, "RED win check incorrectly found a win on a losing board")
        assert_true(yellow_result, "YELLOW win check missed win on a winning board")
      end
    end
  end

end

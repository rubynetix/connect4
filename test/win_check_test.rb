require 'test/unit'
require_relative '../client/models/game_board'
require_relative '../client/models/counter'
require_relative '../client/models/win_check'

class WinCheckTest < Test::Unit::TestCase
  TEST_ITER = 10

  def _setup

  end

  def teardown; end

  def board_counter_check(board, valid_counters)
    result = true
    board.iter do |_, _, counter|
      result = (result and (valid_counters.include?(counter)))
    end
    result
  end

  def generate_red_yellow_neutral_board(counter1, counter2)
    board_list = []

    neutral_board1 = GameBoard.new
    neutral_board1.place(counter1, 0)
    neutral_board1.place(counter1, 1)
    neutral_board1.place(counter1, 2)
    neutral_board1.place(counter2, 3)
    neutral_board1.place(counter2, 4)
    neutral_board1.place(counter2, 5)
    neutral_board1.place(counter1, 6)
    board_list.push(neutral_board1)

    neutral_board2 = GameBoard.new
    neutral_board2.place(counter1, 0)
    neutral_board2.place(counter2, 1)
    neutral_board2.place(counter1, 2)
    neutral_board2.place(counter2, 3)
    neutral_board2.place(counter1, 4)
    neutral_board2.place(counter2, 5)
    neutral_board2.place(counter1, 6)
    neutral_board2.place(counter2, 0)
    neutral_board2.place(counter1, 1)
    neutral_board2.place(counter2, 2)
    neutral_board2.place(counter1, 3)
    neutral_board2.place(counter2, 4)
    neutral_board2.place(counter1, 5)
    neutral_board2.place(counter2, 6)
    neutral_board2.place(counter1, 0)
    neutral_board2.place(counter1, 1)
    neutral_board2.place(counter1, 2)
    neutral_board2.place(counter1, 3)
    neutral_board2.place(counter1, 4)
    neutral_board2.place(counter1, 5)
    neutral_board2.place(counter1, 6)
    neutral_board2.place(counter2, 0)
    neutral_board2.place(counter2, 1)
    neutral_board2.place(counter2, 2)
    neutral_board2.place(counter2, 3)
    neutral_board2.place(counter2, 4)
    neutral_board2.place(counter2, 5)
    neutral_board2.place(counter2, 6)
    board_list.push(neutral_board1)

  end

  def generate_red_yellow_win_boards(winning_counter, losing_counter)
    board_list = []

    horiz_win_board = GameBoard.new
    horiz_win_board.place(winning_counter, 1)
    horiz_win_board.place(winning_counter, 2)
    horiz_win_board.place(winning_counter, 3)
    horiz_win_board.place(winning_counter, 4)
    board_list.push(horiz_win_board)

    vert_win_board = GameBoard.new
    vert_win_board.place(winning_counter, 1)
    vert_win_board.place(winning_counter, 1)
    vert_win_board.place(winning_counter, 1)
    vert_win_board.place(winning_counter, 1)
    board_list.push(vert_win_board)

    right_diag_win_board = GameBoard.new
    right_diag_win_board.place(losing_counter, 1)
    right_diag_win_board.place(losing_counter, 1)
    right_diag_win_board.place(losing_counter, 1)
    right_diag_win_board.place(winning_counter, 1)
    right_diag_win_board.place(losing_counter, 2)
    right_diag_win_board.place(losing_counter, 2)
    right_diag_win_board.place(winning_counter, 2)
    right_diag_win_board.place(losing_counter, 3)
    right_diag_win_board.place(winning_counter, 3)
    right_diag_win_board.place(winning_counter, 4)
    board_list.push(right_diag_win_board)

    left_diag_win_board = GameBoard.new
    left_diag_win_board.place(winning_counter, 3)
    left_diag_win_board.place(losing_counter, 4)
    left_diag_win_board.place(winning_counter, 4)
    left_diag_win_board.place(losing_counter, 5)
    left_diag_win_board.place(losing_counter, 5)
    left_diag_win_board.place(winning_counter, 5)
    left_diag_win_board.place(losing_counter, 6)
    left_diag_win_board.place(losing_counter, 6)
    left_diag_win_board.place(losing_counter, 6)
    left_diag_win_board.place(winning_counter, 6)
    board_list.push(left_diag_win_board)

    board_list
  end

  def generate_ot_netural_boards
    board_list = []

    empty_board = GameBoard.new
  end

  def generate_otto_win_boards
    board_list = []

    horiz_win_board = GameBoard.new
    horiz_win_board.place(OCounter.instance, 1)
    horiz_win_board.place(TCounter.instance, 2)
    horiz_win_board.place(TCounter.instance, 3)
    horiz_win_board.place(OCounter.instance, 4)
    board_list.push(horiz_win_board)

    vert_win_board = GameBoard.new
    vert_win_board.place(OCounter.instance, 1)
    vert_win_board.place(TCounter.instance, 1)
    vert_win_board.place(TCounter.instance, 1)
    vert_win_board.place(OCounter.instance, 1)
    board_list.push(vert_win_board)

    board_list
  end

  def generate_toot_win_boards
    board_list = []

    horiz_win_board = GameBoard.new()
    horiz_win_board.place(TCounter.instance, 1)
    horiz_win_board.place(OCounter.instance, 2)
    horiz_win_board.place(OCounter.instance, 3)
    horiz_win_board.place(TCounter.instance, 4)
    board_list.push(horiz_win_board)

    vert_win_board = GameBoard.new()
    vert_win_board.place(TCounter.instance, 1)
    vert_win_board.place(OCounter.instance, 1)
    vert_win_board.place(OCounter.instance, 1)
    vert_win_board.place(TCounter.instance, 1)
    board_list.push(vert_win_board)

    board_list
  end

  #### TESTING ####

  def test_empty_board
    empty_board = GameBoard.new
    last_counter_pos = empty_board.last_counter_pos

    win_check = WinCheck.new("TOOT", "OTTO")

    # Preconditions
    begin
      assert_true(last_counter_pos.nil?, "board.last_counter_pos is not initialized to nil")
      assert_true(board_counter_check(empty_board, [EmptyCounter.instance]))
    end

    result = win_check.check(empty_board)

    # Postconditions
    begin
      assert_equal(WinEnum::NEUTRAL, result, "Wincheck found incorrect result on empty board.")
    end
  end

  def test_full_board
    full_board = GameBoard.new(rows:1,cols:1)
    full_board.place(OCounter.instance, 0)
    last_counter_pos = full_board.last_counter_pos

    win_check = WinCheck.new("TOOT", "OTTO")

    begin
      assert_true(last_counter_pos.is_a?(Array))
      assert_true(last_counter_pos[0].is_a?(Integer))
      assert_true(last_counter_pos[1].is_a?(Integer))
      assert_true(board_counter_check(full_board, [EmptyCounter.instance, OCounter.instance, TCounter.instance]), "GameBoard contains invalid counter types")
    end

    result = win_check.check(full_board)

    begin
      assert_equal(WinEnum::DRAW, result, "Wincheck found incorrect result on full board. Expected: #{WinEnum::NEUTRAL}. Actual: #{result}")
    end
  end

  def test_ot_neutral
    ot_neutral_board = GameBoard.new(rows:5, cols:5)
    ot_neutral_board.place(OCounter.instance, 1)
    ot_neutral_board.place(TCounter.instance, 4)
    last_counter_pos = ot_neutral_board.last_counter_pos

    win_check = WinCheck.new("TOOT", "OTTO")

    # Preconditions
    begin
      assert_true(last_counter_pos.is_a?(Array))
      assert_true(last_counter_pos[0].is_a?(Integer))
      assert_true(last_counter_pos[1].is_a?(Integer))
      assert_true(board_counter_check(ot_neutral_board, [EmptyCounter.instance, OCounter.instance, TCounter.instance]), "GameBoard contains invalid counter types")
    end

    result = win_check.check(ot_neutral_board)

    # Postconditions
    begin
      assert_equal(WinEnum::NEUTRAL, result, "Wincheck found incorrect result. Expected: #{WinEnum::NEUTRAL}. Actual: #{result}")
    end
  end

  def test_otto_win
    otto_win_boards = generate_otto_win_boards
    win_check = WinCheck.new("TOOT", "OTTO")

    otto_win_boards.each do |otto_win_board|
      last_counter_pos = otto_win_board.last_counter_pos

      # Preconditions
      begin
        assert_true(last_counter_pos.is_a?(Array))
        assert_true(last_counter_pos[0].is_a?(Integer))
        assert_true(last_counter_pos[1].is_a?(Integer))
        assert_true(board_counter_check(otto_win_board, [EmptyCounter.instance, OCounter.instance, TCounter.instance]), "GameBoard contains invalid counter types")
      end

      result = win_check.check(otto_win_board)

      # Postconditions
      begin
        assert_equal(WinEnum::WIN2, result,"Wincheck found incorrect result. Expected: #{WinEnum::WIN2}. Actual: #{result}")
      end
    end
  end


  def test_toot_win
    toot_win_boards = generate_toot_win_boards
    win_check = WinCheck.new("TOOT", "OTTO")

    toot_win_boards.each do |toot_win_board|
      last_counter_pos = toot_win_board.last_counter_pos

      # Preconditions
      begin
        assert_true(last_counter_pos.is_a?(Array))
        assert_true(last_counter_pos[0].is_a?(Integer))
        assert_true(last_counter_pos[1].is_a?(Integer))
        assert_true(board_counter_check(toot_win_board, [EmptyCounter.instance, OCounter.instance, TCounter.instance]), "GameBoard contains invalid counter types")
      end

      result = win_check.check(toot_win_board)

      # Postconditions
      begin
        assert_equal(WinEnum::WIN1, result, "Wincheck found incorrect result. Expected: #{WinEnum::WIN1}. Actual: #{result}")
      end
    end
  end

  def test_toot_otto_draw
    ot_draw_board = GameBoard.new
    ot_draw_board.place(OCounter.instance, 0)
    ot_draw_board.place(TCounter.instance, 1)
    ot_draw_board.place(OCounter.instance, 3)
    ot_draw_board.place(OCounter.instance, 4)
    ot_draw_board.place(TCounter.instance, 5)

    last_counter_pos = ot_draw_board.last_counter_pos

    win_check = WinCheck.new("TOOT", "OTTO")
    pre_check = win_check.check(ot_draw_board)

    # Preconditions
    begin
      assert_true(last_counter_pos.is_a?(Array))
      assert_true(last_counter_pos[0].is_a?(Integer))
      assert_true(last_counter_pos[1].is_a?(Integer))
      assert_true(board_counter_check(ot_draw_board, [EmptyCounter.instance, OCounter.instance, TCounter.instance]), "GameBoard contains invalid counter types")
      assert_equal(WinEnum::NEUTRAL, pre_check, "Wincheck found incorrect result. Expected: #{WinEnum::NEUTRAL}. Actual: #{pre_check}")
    end

    ot_draw_board.place(TCounter.instance, 2)
    result = win_check.check(ot_draw_board)

    begin
      assert_equal(WinEnum::DRAW, result, "Wincheck found incorrect result. Expected: #{WinEnum::NEUTRAL}. Actual: #{result}")
    end
  end


  def test_red_yellow_neutral
    ry_neutral_boards = generate_red_yellow_neutral_board(RedCounter.instance, YellowCounter.instance)
    win_check = WinCheck.new("RRRR", "YYYY")

    ry_neutral_boards.each do |neutral_board|
      last_counter_pos = neutral_board.last_counter_pos

      # Preconditions
      begin
        assert_true(last_counter_pos.is_a?(Array))
        assert_true(last_counter_pos[0].is_a?(Integer))
        assert_true(last_counter_pos[1].is_a?(Integer))
        assert_true( board_counter_check(neutral_board, [EmptyCounter.instance, RedCounter.instance, YellowCounter.instance]), "GameBoard contains invalid counter types")
      end

      result = win_check.check(neutral_board)

      # Postconditions
      begin
        assert_equal(WinEnum::NEUTRAL, result, "Wincheck found incorrect result. Expected: #{WinEnum::NEUTRAL}. Actual: #{result}")
      end
    end
  end


  def test_red_win
    red_win_boards = generate_red_yellow_win_boards(RedCounter.instance, YellowCounter.instance)
    win_check = WinCheck.new("RRRR", "YYYY")

    red_win_boards.each do |red_win_board|
      last_counter_pos = red_win_board.last_counter_pos

      # Preconditions
      begin
        assert_true(last_counter_pos.is_a?(Array))
        assert_true(last_counter_pos[0].is_a?(Integer))
        assert_true(last_counter_pos[1].is_a?(Integer))
        assert_true(board_counter_check(red_win_board, [EmptyCounter.instance, RedCounter.instance, YellowCounter.instance]), "GameBoard contains invalid counter types")
      end

      result = win_check.check(red_win_board)

      # Postconditions
      begin
        assert_equal(WinEnum::WIN1, result, "Wincheck found incorrect result. Expected: #{WinEnum::WIN1}. Actual: #{result}")
      end
    end

  end


  def test_yellow_win
    yellow_win_boards = generate_red_yellow_win_boards(YellowCounter.instance, RedCounter.instance)
    win_check = WinCheck.new("RRRR", "YYYY")

    yellow_win_boards.each do |yellow_win_board|
      last_counter_pos = yellow_win_board.last_counter_pos

      # Preconditions
      begin
        assert_true(last_counter_pos.is_a?(Array))
        assert_true(last_counter_pos[0].is_a?(Integer))
        assert_true(last_counter_pos[1].is_a?(Integer))
        assert_true(board_counter_check(yellow_win_board, [EmptyCounter.instance, RedCounter.instance, YellowCounter.instance]), "GameBoard contains invalid counter types")
      end

      result = win_check.check(yellow_win_board)

      # Postconditions
      begin
        assert_equal(WinEnum::WIN2, result, "Wincheck found incorrect result. Expected: #{WinEnum::WIN2}. Actual: #{result}")
      end
    end
  end

end

require 'test/unit'
require_relative '../lib/models/game_board'
require_relative '../lib/models/counter'
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
    board.iter do |_, _, counter|
      assert_true(valid_counters.include?(counter))
    end
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
    last_counter_pos = ot_neutral_board.last_counter_pos

    win_check = WinCheck.new("TOOT", "OTTO")

    # Preconditions
    begin
      assert_true(last_counter_pos.is_a?(Array))
      assert_true(last_counter_pos[0].is_a?(Integer))
      assert_true(last_counter_pos[1].is_a?(Integer))
      assert_true(board_counter_check(ot_neutral_board, [OCounter.instance, TCounter.instance]), "GameBoard contains invalid counter types")
    end

    result = win_check.check(ot_neutral_board, last_counter_pos)

    # Postconditions
    begin
      assert_equal(result, WinEnum::NEUTRAL, "Wincheck found incorrect result. Expected: #{WinEnum::NEUTRAL}. Actual: #{result}")
    end
  end

  def tst_otto_win
    otto_win_boards = generate_otto_win_boards
    win_check = WinCheck.new("TOOT", "OTTO")

    otto_win_boards.each do |otto_win_board|
      last_counter_pos = otto_win_board.last_counter_pos

      # Preconditions
      begin
        assert_true(last_counter_pos.is_a?(Array))
        assert_true(last_counter_pos[0].is_a?(Integer))
        assert_true(last_counter_pos[1].is_a?(Integer))
        assert_true(board_counter_check(otto_win_board, [OCounter.instance, TCounter.instance]), "GameBoard contains invalid counter types")
      end

      result = win_check.check(otto_win_board, last_counter_pos)

      # Postconditions
      begin
        assert_equal(result, WinEnum::WIN2, "Wincheck found incorrect result. Expected: #{WinEnum::WIN2}. Actual: #{result}")
      end
    end
  end


  def tst_toot_win
    toot_win_boards = generate_toot_win_boards
    win_check = WinCheck.new("TOOT", "OTTO")

    toot_win_boards.each do |toot_win_board|
      last_counter_pos = toot_win_board.last_counter_pos

      # Preconditions
      begin
        assert_true(last_counter_pos.is_a?(Array))
        assert_true(last_counter_pos[0].is_a?(Integer))
        assert_true(last_counter_pos[1].is_a?(Integer))
        assert_true(board_counter_check(toot_win_board, [OCounter.instance, TCounter.instance]), "GameBoard contains invalid counter types")
      end

      result = win_check.check(toot_win_board, last_counter_pos)

      # Postconditions
      begin
        assert_equal(result, WinEnum::WIN1, "Wincheck found incorrect result. Expected: #{WinEnum::WIN1}. Actual: #{result}")
      end
    end
  end


  def tst_red_yellow_neutral
    red_yellow_neutral_board = GameBoard.new(5)
    red_yellow_neutral_board.place(RedCounter.Instance, 1)
    red_yellow_neutral_board.place(YellowCounter.Instance, 1)
    last_counter_pos = red_yellow_neutral_board.last_counter_pos

    win_check = WinCheck.new("RRRR", "YYYY")

    # Preconditions
    begin
      assert_true(last_counter_pos.is_a?(Array))
      assert_true(last_counter_pos[0].is_a?(Integer))
      assert_true(last_counter_pos[1].is_a?(Integer))
      assert_true( board_counter_check(red_yellow_neutral_board, [RedCounter.Instance, YellowCounter.Instance]), "GameBoard contains invalid counter types")
    end

    result = win_check.check(red_yellow_neutral_board, last_counter_pos)

    # Postconditions
    begin
      assert_equal(result, WinEnum::NEUTRAL, "Wincheck found incorrect result. Expected: #{WinEnum::NEUTRAL}. Actual: #{result}")
    end
  end


  def tst_red_win
    red_win_boards = generate_red_yellow_win_boards(RedCounter.Instance, YellowCounter.Instance)
    win_check = WinCheck.new("RRRR", "YYYY")

    red_win_boards.each do |red_win_board|
      last_counter_pos = red_win_board.last_counter_pos

      # Preconditions
      begin
        assert_true(last_counter_pos.is_a?(Array))
        assert_true(last_counter_pos[0].is_a?(Integer))
        assert_true(last_counter_pos[1].is_a?(Integer))
        assert_true(board_counter_check(red_win_board, [RedCounter.instance, YellowCounter.instance]), "GameBoard contains invalid counter types")
      end

      result = win_check.check(red_win_board, last_counter_pos)

      # Postconditions
      begin
        assert_equal(result, WinEnum::WIN1, "Wincheck found incorrect result. Expected: #{WinEnum::WIN1}. Actual: #{result}")
      end
    end

  end


  def tst_yellow_win
    yellow_win_boards = generate_red_yellow_win_boards(YellowCounter.Instance, RedCounter.Instance)
    win_check = WinCheck.new("RRRR", "YYYY")

    yellow_win_boards.each do |yellow_win_board|
      last_counter_pos = yellow_win_board.last_counter_pos

      # Preconditions
      begin
        assert_true(last_counter_pos.is_a?(Array))
        assert_true(last_counter_pos[0].is_a?(Integer))
        assert_true(last_counter_pos[1].is_a?(Integer))
        assert_true(board_counter_check(yellow_win_board, [RedCounter.instance, YellowCounter.instance]), "GameBoard contains invalid counter types")
      end

      result = win_check.check(yellow_win_board, last_counter_pos)

      # Postconditions
      begin
        assert_equal(result, WinEnum::WIN2, "Wincheck found incorrect result. Expected: #{WinEnum::WIN2}. Actual: #{result}")
      end
    end
  end

end

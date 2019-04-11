require 'uuid'
require_relative 'base_handler'


# Handles game related requests
class GameHandler < BaseHandler

  def self.endpoints
    [:create, :get, :put]
  end

  def initialize(opts = {})
    super(opts)
    @uuid = UUID.new
  end

  # Creates a new game
  def create(p1, p2, game_type, gb)
    raise UserDoesNotExist unless user_exists?(p1) and user_exists?(p2)
    raise ArgumentError.new("You cannot play against yourself") if p1 == p2
    raise GameAlreadyInProgress if active_game?(p1, p2)

    game_id = @uuid.generate

    transaction do
      query(load_query('create_game'),
            game_id, game_type, p1, p1, p2)
      query(load_query('create_board'),
            game_id, gb)
    end

    { game_id: game_id }
  end

  # gets the gameboard, player_turn and game_state
  def get(game_id)
    raise GameDoesNotExist unless
        exists?("SELECT true from games WHERE game_id=UUID_TO_BIN(?);", game_id)

    query(load_query('get_game'), game_id).first
  end

  # Saves the gameboard and player turn
  def put(game_id, board_array, player_name, counter_placement)
    raise GameDoesNotExist unless
        exists?("SELECT true from games WHERE game_id=UUID_TO_BIN(?);", game_id)

    _, state, current_turn, _ = get(game_id).to_a()

    raise GameOver unless state == "active"
    raise InvalidTurn unless current_turn == player_name

    win_check = create_win_check(game_id)
    game_board = GameBoard(rows: board_array.length, cols: board_array[0].length, board: board_array, win_check: win_check, last_move: counter_placement)

    check_board(game_board)
    next_turn = get_next_turn(game_id, current_turn)
    
    transaction do
      query(load_query('update_board'), board_array, game_id)
      query(load_query('update_game'), next_turn, game_id)
      query(load_query('update_game_state'), [state, game_id])
    end

    { success: true }
  end

  def active_game?(p1, p2)
    exists? <<END_SQL
      SELECT true FROM games
      WHERE ((p1='#{p1}' AND p2='#{p2}') OR (p1='#{p2}' AND p2='#{p1}'))
        AND state = 'active';
END_SQL
  end

  private

  def get_turn(game_id)

  end

  def create_win_check(game_id)
    game_type = query("SELECT type FROM games WHERE game_id=UUID_TO_BIN(?);", game_id).first
    if game_type == 'connect4'
      win_check = WinCheck.connect4
    else
      win_check = WinCheck.toot_otto
    end
    win_check
  end

  # This method requires a gameboard object, NOT a 2D array
  def check_board(game_board)
    case win_check.check(game_board)
    when WinEnum::DRAW
      state = 'draw'
    when WinEnum::WIN1
      state = 'w1'
    when WinEnum::WIN2
      state = 'w2'
    else
      state = 'active'
    end
    state
  end

  def get_next_turn(game_id, current_turn)
    p1, p2 = query("SELECT p1, p2 FROM games WHERE game_id=UUID_TO_BIN(?);", game_id).first(2)
    if current_turn == p1
      next_turn = p2
    else
      next_turn = p1
    end
    next_turn
  end

end

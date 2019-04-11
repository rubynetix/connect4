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
  def put(game_id, game_board, player_turn, last_counter_pos)
    transaction do
      query(load_query('update_game'), player_turn, game_id)
      query(load_query('update_board'), game_board, game_id)
    end

    { success: true }
  end

  def put2(game_id, new_board, player_name, counter_placement)
    raise GameDoesNotExist unless
        exists?("SELECT true from games WHERE game_id=UUID_TO_BIN(?);", game_id)

    gid, state, current_turn, current_board = get(game_id).to_a()

    raise GameOver unless state == "active"
    raise InvalidTurn unless current_turn == player_name

    #TODO: Refactor this into 'get' function
    game_type = query("SELECT type FROM games WHERE game_id=UUID_TO_BIN(?);", game_id).first
    if game_type == 'connect4'
      win_check = WinCheck.connect4
    else
      win_check = WinCheck.toot_otto
    end

    # TODO: Change dummy state to actual wincheck. Need to rework wincheck to check 2d arrays
    state = 'active'

    p1, p2 = query("SELECT p1, p2 FROM games WHERE game_id=UUID_TO_BIN(?);", game_id).first(2)
    if current_turn == p1
      next_turn = p2
    else
      next_turn = p1
    end

    query(load_query('update_board'), new_board, game_id)
    query(load_query('update_game'), next_turn, game_id)
    query(load_query('update_game_state'), [state, game_id])

  end

  def active_game?(p1, p2)
    exists? <<END_SQL
      SELECT true FROM games
      WHERE ((p1='#{p1}' AND p2='#{p2}') OR (p1='#{p2}' AND p2='#{p1}'))
        AND state = 'active';
END_SQL
  end
end

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

  def active_game?(p1, p2)
    exists? <<END_SQL
      SELECT true FROM games
      WHERE ((p1='#{p1}' AND p2='#{p2}') OR (p1='#{p2}' AND p2='#{p1}'))
        AND state = 'active';
END_SQL
  end
end

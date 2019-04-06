require 'uuid'
require_relative 'base_handler'


# Handles game related requests
class GameHandler < BaseHandler

  def initialize(opts = {})
    super(opts)
    @uuid = UUID.new
  end

  # Creates a new game
  def create(p1, p2, game_type)
    raise UserDoesNotExist unless user_exists?(p1) and user_exists?(p2)
    raise ArgumentError.new("You cannot play against yourself") if p1 == p2
    raise GameAlreadyInProgressError if active_game?(p1, p2)

    game_id = @uuid.generate

    query(load_query(abs_path('queries/create_game.sql')),
                     game_id, game_type, p1, p2)

    { game_id: game_id }
  end

  # gets the gameboard, player_turn and game_state
  def get(game_id)
    { 'board' => 'game_board', 'turn' => 'player_turn',
      'state' => 'game_state' }
  end

  # Saves the gameboard and player turn
  def put(game_id, game_board, player_turn)
    { 'put' => 'success or fail' }
  end

  def active_game?(p1, p2)
    exists? <<END_SQL
      SELECT true FROM games
      WHERE ((p1='#{p1}' AND p2='#{p2}') OR (p1='#{p2}' AND p2='#{p1}'))
        AND state NOT IN ('W1', 'W2', 'D');
END_SQL
  end
end

class GameAlreadyInProgressError < StandardError; end

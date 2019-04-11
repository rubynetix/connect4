require 'mysql2'
require_relative '../../server/base_handler'
require_relative '../../client/models/game_board'

class TestDBHandler < BaseHandler

  def initialize
    super

    gb = game_board.new
    query(load_query('update_board'), board_array, game_id)
  end
end

tdbh = TestDBHandler.new
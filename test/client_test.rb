require_relative 'helper'
require_relative '../server/server'

class ClientTest < Helper

  def setup_db
    #
  end

  def setup
    setup_db
    @server_thread = Thread.new do
      serve
    end
  end

  def teardown
    Thread.kill @server_thread
  end

  def test_user_games
    user = 'user_games'

  end

  def test_create_game
    user = 'create_game'

  end

  def test_get_game
    user = 'get_game'

  end

  def test_put_game
    user = 'put_game'

  end
end
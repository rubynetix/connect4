require 'test/unit'
require_relative '../server/server'

class ServerTest < Test::Unit::TestCase
  TEST_ITER = 10

  def setup
    @server = XMLRPC::Client.new('localhost', '/', 8080)
  end

  def teardown; end

  def tst_user_games
    # Preconditions
    begin
    end

    # Postconditions
    begin
    end
  end

  def tst_game_create
    # Preconditions
    begin
    end

    # Postconditions
    begin
    end
  end

  def tst_league_standings
    # Preconditions
    begin
    end

    # Postconditions
    begin
    end
  end

end
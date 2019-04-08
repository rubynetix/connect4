require_relative 'server'
require_relative '../client/controllers/client'
require_relative '../client/models/game_board'
require_relative 'base_handler'

server_thread = Thread.new do
  serve
end

sleep(1)

def create_user(client, username)
  begin
    client.create_user(username)
  rescue DuplicateUsers
    nil
  end
end

def create_game(client, p1, p2)
  begin
    res = client.create_game(p1, p2, 'c', GameBoard.connect4)
    res[:game_id]
  rescue GameAlreadyInProgress
    game = client.user_games(p1).detect { |g| g[:opponent] == p2 }
    game[:game_id]
  end
end


client = Client.new
create_user(client, 'p1')
create_user(client, 'p2')
game_id = create_game(client, 'p1', 'p2')
puts game_id

server_thread.kill

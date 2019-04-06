require_relative 'server'
require_relative '../client/controllers/client'

server_thread = Thread.new do
  serve
end

sleep(1)

client = Client.new
client.create_user('p1')
client.create_user('p2')
client.create_game('p1', 'p2', 'C')

server_thread.kill

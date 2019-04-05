require "xmlrpc/client"

# Make an object to represent the XML-RPC server.
server = XMLRPC::Client.new('localhost', '/', 8080)

# Call the remote server and get our result
result = server.call("user.create", "my_name")
puts "Result: #{result[:success]}"

# result = server.call("user.games", "my_name")
# puts "Result: #{result['games']}"
#
# result = server.call("game.create", "my_name", "their_name")
# puts "Result: #{result['game']}"
#
# result = server.call("league.standings", "my_name")
# puts "Result: #{result['standings']}"
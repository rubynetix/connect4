require_relative 'server'

s = XMLRPC::Server.new(8080)
s.add_handler('user', UserHandler.new)
s.add_handler('game', GameHandler.new)
s.add_handler('league', LeagueHandler.new)
s.serve

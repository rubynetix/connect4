require 'xmlrpc/server'
require_relative 'base_handler'
require_relative 'game_handler'
require_relative 'league_handler'

def serve(port: 8080)
  s = XMLRPC::Server.new(port)
  s.add_handler('user', UserHandler.new)
  s.add_handler('game', GameHandler.new)
  s.add_handler('league', LeagueHandler.new)
  s.serve
end

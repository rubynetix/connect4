require 'xmlrpc/server'
require_relative 'game_handler'
require_relative 'league_handler'
require_relative 'user_handler'

def serve(port: 8080, host: nil)
  s = host.nil? ? XMLRPC::Server.new(port) : XMLRPC::Server.new(port, host)
  s.add_handler('user', UserHandler.new)
  s.add_handler('game', GameHandler.new)
  s.add_handler('league', LeagueHandler.new)
  s.serve
end

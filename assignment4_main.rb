require "gtk3"
require_relative 'lib/views/ui'
require_relative 'lib/controllers/connect4'
require_relative 'lib/models/game_board'
require_relative 'lib/controllers/local_player'
require_relative 'lib/models/counter'


# Group No. 6 Members:
#   - Fraser Bulbuc
#   - James Hryniw
#   - Jordan Lane
#   - Ryan Furrer
#   - Tim Tran
#

ui = UI.new
c4 = Connect4.new ui
Thread.new do
  c4.app_loop
end
Gtk.main

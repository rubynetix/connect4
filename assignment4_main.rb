require "gtk3"
require_relative 'client/views/ui'
require_relative 'client/controllers/connect4'
require_relative 'client/models/game_board'
require_relative 'client/models/counter'


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

require "gtk3"
require_relative 'lib/views/ui'
require_relative 'lib/models/connect4'
require_relative 'lib/models/game_board'
require_relative 'lib/models/red_win_check'
require_relative 'lib/controllers/local_player'
require_relative 'lib/models/counter'

# app = Gtk::Application.new("org.gtk.example", :flags_none)
#
# app.signal_connect "activate" do |application|
#   window = Gtk::ApplicationWindow.new(application)
#   window.set_title("Window")
#   window.set_default_size(600, 600)
#   window.show_all
# end
#
# puts app.run

players = [
    LocalPlayer.new('player1'),
    LocalPlayer.new('player2')
]

gameboard = GameBoard.new
# game = Game.new(players, gameboard, RedWinCheck.new)
gameboard.place(RedCounter.instance, 1)
gameboard.place(YellowCounter.instance, 1)
gameboard.place(RedCounter.instance, 2)

ui = UI.new
ui.draw_gameboard(gameboard)

Gtk.main

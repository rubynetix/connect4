require "gtk3"
require_relative 'lib/views/ui'

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

ui = UI.new
Gtk.main

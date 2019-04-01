require 'gtk3'
require 'fileutils'
require_relative 'lib/views/gtk_ui'
require_relative 'lib/views/windows/app_window'
require_relative 'lib/controllers/application'
require_relative 'lib/controllers/connect4'

# Recursively require all ruby files in lib directory
root = File.expand_path(__dir__)

# Define the source & target files of the glib-compile-resources command
resource_xml = File.join(root, 'lib/resources', 'gresources.xml')
resource_bin = File.join(root, 'gresource.bin')

# Build the binary
system("glib-compile-resources",
       "--target", resource_bin,
       "--sourcedir", File.dirname(resource_xml),
       resource_xml)

# Allow binary resources to be accessed from within application
resource = Gio::Resource.load(resource_bin)
Gio::Resources.register(resource)

at_exit do
  # Remove resource binary upon exit
  FileUtils.rm_f(resource_bin)
end

app = C4::Application.new
ui = GtkUI.new(app)
c4 = Connect4.new(ui)
Thread.new do
  c4.app_loop
end

puts app.run
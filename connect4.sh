#!/usr/bin/env ruby

require 'gtk3'

# Recursively require all ruby files in lib directory
application_root_path = File.expand_path(__dir__)
Dir[File.join(application_root_path, '/lib/**', '*.rb')].each { |file| require file }

# Define the source & target files of the glib-compile-resources command
resource_xml = File.join(application_root_path, 'lib/resources', 'gresources.xml')
resource_bin = File.join(application_root_path, 'gresource.bin')

# Build the binary
system("glib-compile-resources",
       "--target", resource_bin,
       "--sourcedir", File.dirname(resource_xml),
       resource_xml)

# Allow binary resources to be accessed from within application
resource = Gio::Resource.load(resource_bin)
Gio::Resources.register(resource)

#at_exit do
  # Remove resource binary upon exit
 # FileUtils.rm_f(resource_bin)
#end

app = C4::Application.new

puts app.run
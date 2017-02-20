#!/usr/bin/env ruby
require 'yaml'

# Make sure you edit /etc/sudoers with:
# <username> ALL = NOPASSWD: /etc/init.d/plexHue

config = YAML.load_file(File.join(File.expand_path(File.dirname(__FILE__)), 'etc/config.yaml') )
cmd = "rsync -r . #{config['deploy']['host']}:#{config['deploy']['path']}"
restart_cmd = "ssh #{config['deploy']['host']} -t \"sudo /etc/init.d/plexHue restart\""

puts "Deploying..."
puts "  => #{cmd}"
system(cmd)

puts "Restarting..."
puts "  => #{restart_cmd}"
system(restart_cmd)

puts "Deploy finished."

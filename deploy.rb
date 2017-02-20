#!/usr/bin/env ruby
require 'yaml'

config = YAML.load_file(File.join(File.expand_path(File.dirname(__FILE__)), 'etc/config.yaml') )
cmd = "rsync -r . #{config['deploy']['host']}:#{config['deploy']['path']}"

puts "Deploying..."
puts "  => #{cmd}"
system(cmd)
puts "Deploy finished."

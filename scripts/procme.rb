#!/usr/bin/env ruby

# Reads the Procfile, starts all commands in the background except the server one.
# Server command should be interactive for debugging, yo!
first_type = nil
commands = File.read("Procfile").lines.map do |line|
  parts = line.split(":")
  type = parts.shift.strip
  first_type ||= type
  [type, parts.join(":").strip]
end.to_h

server_command = commands["server"] || commands[first_type]
commands.each { |type, command| system("#{command}&") unless ["server", first_type].include?(type) }
system(server_command)

#!/usr/bin/ruby
#
# bdfremap.rb
# This file is part of BDF UM+ OUTLINE.
#

if ARGV.length != 2
  puts "Usage: bdfremap.rb bdffile mapfile"
  exit
end


bdf = IO.read(ARGV[0])
print bdf.match(/^.*ENDPROPERTIES\s*\n/m)
chars = bdf.scan(/STARTCHAR.+?ENDCHAR\s*\n/m).inject({}) { |sum,s| sum[s.match(/ENCODING\s+(\d+)/)[1].to_i] = s; sum }

out = []
IO.read(ARGV[1]).scan(/^\s*(\d+)\s+(\d+)\s*$/) do |s|
  to = s[0].to_i
  from = s[1].to_i
  out << chars[from].gsub(/ENCODING\s+(\d+)/) { |m| sprintf('ENCODING %d', to) } if chars[from]
end

puts "CHARS " + out.length.to_s
print out.join
puts "ENDFONT"

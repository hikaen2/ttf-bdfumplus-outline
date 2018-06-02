#!/usr/bin/ruby
#
# bdf2pbm.rb
# 
# Copyright (c) 2015 Suzuki Taro
# Released under the MIT license
# http://opensource.org/licenses/mit-license.php
#

if ARGV.length != 2
  puts "Usaga: bdf2pbm.rb bdffile outputdir"
  exit 1
end


IO.read(ARGV[0]).scan(/STARTCHAR.*?ENDCHAR/m) do |s|

  pbm =
    "P4\n" +
    s.match(/BBX\s+(\d+)/)[1] + " " + s.match(/BBX\s+\d+\s+(\d+)/)[1] + "\n" +
    s.match(/BITMAP\s*\n(.*)ENDCHAR/m)[1].split("\n").inject("") { |sum,item| sum += [item].pack("H*") }
  
  filename = File.join(ARGV[1], sprintf("u%04x.pbm", s.match(/ENCODING\s+(\d+)/)[1]))
  open(filename, "w") { |f| f << pbm }

end
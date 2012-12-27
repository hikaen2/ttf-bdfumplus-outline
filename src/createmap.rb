#!/usr/bin/ruby
#
# createmap.rb
# This file is part of BDF UM+ OUTLINE.
#

require 'rubygems'
require 'sqlite3'
require 'tempfile'


if ARGV.length != 2
  puts 'Usaga: createmap.rb 90msp-RKSJ-H UniJIS-UTF32-H'
  exit 1
end


def parse_cmap(cmap)
  cmap.scan(/begincidchar.*?endcidchar/m).join.scan(/<([0-9A-Fa-f]+)>[ \t]+(\d+)/).map { |s| [s[0].hex, s[1].to_i] } +
  cmap.scan(/begincidrange.*?endcidrange/m).join.scan(/<([0-9A-Fa-f]+)>[ \t]+<([0-9A-Fa-f]+)>[ \t]+(\d+)/).inject([]) do |sum, s|
    sum + ((s[0].hex)..(s[1].hex)).zip((s[2].to_i)..(s[2].to_i + s[1].hex - s[0].hex))
  end
end


def sjis_to_jis(sjis)
  hi = (sjis >> 8) & 0xff
  lo = sjis & 0xff
  return lo if hi == 0
  
  hi -= (hi<=0x9f) ? 0x71 : 0xb1
  hi = hi * 2 + 1
  lo -= (lo > 0x7f) ? 1 : 0
  hi += (lo >= 0x9e) ? 1 : 0
  lo -= (lo >= 0x9e) ? 0x7d : 0x1f
  return hi << 8 | lo
end



rksj_to_cid = parse_cmap(IO.read(ARGV[0]))
utf32_to_cid = parse_cmap(IO.read(ARGV[1]))


db = SQLite3::Database.new(Tempfile.new('').path)
db.execute('CREATE TABLE rksj_to_cid (rksj INTEGER PRIMARY KEY, cid INTEGER)')
db.execute('CREATE TABLE utf32_to_cid (utf32 INTEGER PRIMARY KEY, cid INTEGER)')
db.execute('CREATE TABLE cid_to_rksj (cid INTEGER PRIMARY KEY, rksj INTEGER)')
db.execute('CREATE TABLE utf32_to_rksj (utf32 INTEGER PRIMARY KEY, rksj INTEGER)')

db.transaction do
  rksj_to_cid.each do |rksj, cid|
    db.execute('INSERT INTO rksj_to_cid VALUES (?, ?)', rksj, cid)
  end
  utf32_to_cid.each do |utf32, cid|
    db.execute('INSERT INTO utf32_to_cid VALUES (?, ?)', utf32, cid)
  end

  db.execute('UPDATE rksj_to_cid SET cid =  99 WHERE rksj =   124 AND cid =  93')  # 0x7c is VERTICAL LINE(CID 99), not BROKEN BAR(CID 93).
  db.execute('UPDATE rksj_to_cid SET cid = 226 WHERE rksj =   126 AND cid =  95')  # 0x7e is OVERLINE(CID 226?), not TILDE(CID 95).
  db.execute('UPDATE rksj_to_cid SET cid =  98 WHERE rksj = 33125 AND cid = 670')  # 0x8165 to U+2018(LEFT SINGLE QUOTATION MARK)
  db.execute('UPDATE rksj_to_cid SET cid =  96 WHERE rksj = 33126 AND cid = 671')  # 0x8166 to U+2019(RIGHT SINGLE QUOTATION MARK)
  db.execute('UPDATE rksj_to_cid SET cid = 108 WHERE rksj = 33127 AND cid = 672')  # 0x8167 to U+201C(LEFT DOUBLE QUOTATION MARK)
  db.execute('UPDATE rksj_to_cid SET cid = 122 WHERE rksj = 33128 AND cid = 673')  # 0x8168 to U+201D(RIGHT DOUBLE QUOTATION MARK)

  db.execute('INSERT INTO cid_to_rksj SELECT cid, MIN(rksj) FROM rksj_to_cid GROUP BY cid')
  db.execute('INSERT INTO utf32_to_rksj SELECT utf32_to_cid.utf32, cid_to_rksj.rksj FROM utf32_to_cid NATURAL JOIN cid_to_rksj')
end


rows = db.execute('SELECT * FROM utf32_to_rksj ORDER BY utf32')

puts rows.map {|utf32, rksj| sprintf("0x%04X\t0x%04X", utf32, sjis_to_jis(rksj)) }.join("\n")

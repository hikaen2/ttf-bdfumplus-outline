# Makefile
# This file is part of BDF UM+ OUTLINE.

all: map bdf ttf

ttf:
	bdfresize -b 1 -f 4 < compiled/bdfUMplus.bdf > compiled/bdfUMplus_x4.bdf
	mkdir compiled/svg
	ruby src/bdf2pbm.rb compiled/bdfUMplus_x4.bdf compiled/svg
	rm compiled/bdfUMplus_x4.bdf
	potrace -s -z white -a -1 compiled/svg/*.pbm
	rm compiled/svg/*.pbm
	fontforge -script src/createttf.pe `date '+%Y.%m.%d'`
	rm -rf compiled/svg/

bdf:
	patch -ocompiled/mplus_f12r-jisx0201.bdf data/mplus_f12r.bdf data/mplus_f12r-jisx0201.diff
	ruby src/bdfremap.rb data/mplus_j12r.bdf compiled/unicode-jis.map > compiled/mplus_j12r-utf16.bdf
	ruby src/bdfremap.rb compiled/mplus_f12r-jisx0201.bdf compiled/unicode-jis.map > compiled/mplus_f12r-jisx0201-utf16.bdf
	ruby src/bdfmerge.rb data/6x13.bdf data/12x13ja.bdf compiled/mplus_f12r-jisx0201-utf16.bdf data/mplus_f12r.bdf compiled/mplus_j12r-utf16.bdf > compiled/bdfUMplus.bdf
	rm compiled/mplus_f12r-jisx0201.bdf
	rm compiled/mplus_f12r-jisx0201-utf16.bdf
	rm compiled/mplus_j12r-utf16.bdf
	sed -i "s/SWIDTH \(443\|480\) 0/SWIDTH 384 0/" compiled/bdfUMplus.bdf
	sed -i "s/SWIDTH \(886\|960\) 0/SWIDTH 768 0/" compiled/bdfUMplus.bdf

map:
	ruby src/createmap.rb data/90msp-RKSJ-H data/UniJIS-UTF32-H > compiled/unicode-jis.map

clean:
	-rm compiled/mplus_f12r-jisx0201.bdf
	-rm compiled/mplus_f12r-jisx0201-utf16.bdf
	-rm compiled/mplus_j12r-utf16.bdf
	-rm compiled/bdfUMplus_x4.bdf
	-rm -rf compiled/svg/

distclean:
	-rm -rf compiled/*

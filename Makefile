#
# Makefile
# This file is part of BDF UM+ OUTLINE.
#

all: bdf ttf

ttf:
	bdfresize -b 1 -f 4 < compiled/bdfUMplus.bdf > compiled/bdfUMplus-x4.bdf
	-rm -rf compiled/svg
	mkdir -p compiled/svg
	ruby bin/bdf2pbm.rb compiled/bdfUMplus-x4.bdf compiled/svg
	rm compiled/bdfUMplus-x4.bdf
	potrace -s -z black -a -1 compiled/svg/*.pbm
	rm compiled/svg/*.pbm
	fontforge -script bin/createttf.pe `date '+%Y.%m.%d'`
	rm -rf compiled/svg
	gzip -f compiled/bdfUMplus-outline.sfd

bdf:
	mkdir -p compiled
	patch -ocompiled/mplus_f12r-jisx0201.bdf data/mplus_f12r.bdf data/mplus_f12r-jisx0201.diff
	ruby bin/bdfremap.rb data/mplus_j12r.bdf data/CP932.TXT > compiled/mplus_j12r-utf16.bdf
	ruby bin/bdfremap.rb compiled/mplus_f12r-jisx0201.bdf data/JIS0201.TXT > compiled/mplus_f12r-jisx0201-utf16.bdf
	ruby bin/bdfmerge.rb data/6x13.bdf data/12x13ja.bdf compiled/mplus_f12r-jisx0201-utf16.bdf data/mplus_f12r.bdf compiled/mplus_j12r-utf16.bdf data/template.bdf > compiled/bdfUMplus.bdf
	rm compiled/mplus_f12r-jisx0201.bdf
	rm compiled/mplus_f12r-jisx0201-utf16.bdf
	rm compiled/mplus_j12r-utf16.bdf
	sed -i 's/SWIDTH \(443\|480\) 0/SWIDTH 384 0/' compiled/bdfUMplus.bdf
	sed -i 's/SWIDTH \(886\|960\) 0/SWIDTH 768 0/' compiled/bdfUMplus.bdf
	sed -i 's/STARTCHAR .*/STARTCHAR (for_rename)/' compiled/bdfUMplus.bdf

clean:
	-rm compiled/mplus_f12r-jisx0201.bdf
	-rm compiled/mplus_f12r-jisx0201-utf16.bdf
	-rm compiled/mplus_j12r-utf16.bdf
	-rm compiled/bdfUMplus-x4.bdf
	-rm -rf compiled/svg

distclean:
	-rm -rf compiled/*

.PHONY: all ttf bdf clean distclean

#
# Makefile
# This file is part of BDF UM+ OUTLINE.
#

all: bdf regular bold

regular:
	bdfresize -b 1 -f 4 < dist/bdfUMplus.bdf > dist/bdfUMplus-x4.bdf
	-rm -rf dist/svg
	mkdir -p dist/svg
	bin/bdf2pbm dist/bdfUMplus-x4.bdf dist/svg
	rm dist/bdfUMplus-x4.bdf
	potrace -s -z black -a -1 dist/svg/*.pbm
	rm dist/svg/*.pbm
	fontforge -script bin/createttf.pe `date '+%Y.%m.%d'`
	rm -rf dist/svg
	gzip -f dist/bdfUMplus-outline.sfd

bold:
	bdfresize -b 1 -f 4 < dist/bdfUMplus-bold.bdf > dist/bdfUMplus-bold-x4.bdf
	-rm -rf dist/svg
	mkdir -p dist/svg
	bin/bdf2pbm dist/bdfUMplus-bold-x4.bdf dist/svg
	rm dist/bdfUMplus-bold-x4.bdf
	potrace -s -z black -a -1 dist/svg/*.pbm
	rm dist/svg/*.pbm
	fontforge -script bin/createttf-bold.pe `date '+%Y.%m.%d'`
	rm -rf dist/svg
	gzip -f dist/bdfUMplus-outline-bold.sfd

bdf:
	mkdir -p dist
	patch -odist/mplus_f12r-jisx0201.bdf data/mplus_f12r.bdf data/mplus_f12r-jisx0201.diff
	cat data/mplus_j12r.bdf          | bin/bdfremap data/map.txt     | bin/bdfuniq | bin/bdfsort > dist/mplus_j12r-unicode.bdf
	cat dist/mplus_f12r-jisx0201.bdf | bin/bdfremap data/JIS0201.TXT | bin/bdfuniq | bin/bdfsort > dist/mplus_f12r-jisx0201-unicode.bdf
	cat data/template.bdf dist/mplus_j12r-unicode.bdf data/mplus_f12r.bdf dist/mplus_f12r-jisx0201-unicode.bdf data/12x13ja.bdf data/6x13.bdf | bin/bdfuniq | bin/bdfsort > dist/bdfUMplus.bdf
	rm dist/mplus_f12r-jisx0201.bdf
	rm dist/mplus_f12r-jisx0201-unicode.bdf
	rm dist/mplus_j12r-unicode.bdf
	sed -i 's/SWIDTH \(443\|480\) 0/SWIDTH 384 0/' dist/bdfUMplus.bdf
	sed -i 's/SWIDTH \(886\|960\) 0/SWIDTH 768 0/' dist/bdfUMplus.bdf
	sed -i 's/STARTCHAR .*/STARTCHAR (for_rename)/' dist/bdfUMplus.bdf
	perl bin/mkbold -r -L dist/bdfUMplus.bdf > dist/bdfUMplus-bold.bdf

map:
	bin/createmap < data/CP932.TXT > data/map.txt

clean:
	-rm dist/mplus_f12r-jisx0201.bdf
	-rm dist/mplus_f12r-jisx0201-unicode.bdf
	-rm dist/mplus_j12r-unicode.bdf
	-rm dist/bdfUMplus-x4.bdf
	-rm -rf dist/svg

distclean:
	-rm -rf dist/*

.PHONY: all regular bold bdf map clean distclean

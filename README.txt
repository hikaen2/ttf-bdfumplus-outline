BDF UM+ OUTLINE - ビットマップTrueTypeフォント


説明
  BDF UM+ OUTLINEはKaoriYa.net（http://www1.kaoriya.net/）で公開されている
  BDF UM+のアウトライン版です。オリジナルのBDF UM+と異なり、Mac OS XやGNU/Linux
  で表示させることができます（Windowsでも表示させることができます）。
  BDF UM+ OUTLINEは（オリジナルのBDF UM+と異なり）高さ13ピクセルのサイズで最適な
  表示になります。通常、13ピクセルはWindowsでは10ポイントにあたります。
  13(pixels) ✕ 72(points per inch) / 96(pixels per inch) = 9.75(points) ≒ 10(points)


アーカイブに同梱されているファイルのオリジナル配付サイト
  - M+ BITMAP FONTS
    http://mplus-fonts.sourceforge.jp/mplus-bitmap-fonts/index.html
  - Unicode fonts and tools for X11
    http://www.cl.cam.ac.uk/~mgk25/ucs-fonts.html


ファイルの説明
  - compiled/bdfUMplus-outline.ttf
    フォント本体
  - compiled/bdfUMplus-outline.sfd
    FontForgeのスプラインフォントデータベースファイル
  - compiled/bdfUMplus.bdf
    BDFフォント
  - data/6x13.bdf
    Unicode versions of the X11 "misc-fixed-*" fonts
    オリジナルファイル：ucs-fonts.tar.gz
  - data/12x13ja.bdf
    Unicode versions of the X11 "misc-fixed-*" fonts -- CJK Supplement
    オリジナルファイル：ucs-fonts-asian.tar.gz
  - data/mplus_f12r.bdf
    M+ BITMAP FONTS 12 ドット固定幅欧文フォント
    オリジナルファイル：mplus_bitmap_fonts-2.2.4.tar.gz
  - data/mplus_f12r-jisx0201.diff
    M+ BITMAP FONTS gothic 12r 半角カナ用 diff ファイル
    オリジナルファイル：mplus_bitmap_fonts-2.2.4.tar.gz
  - data/mplus_j12r.bdf
    M+ BITMAP FONTS 12 ドット和文フォント
    オリジナルファイル：
    http://sourceforge.jp/cvs/view/mplus-fonts/mplus_bitmap_fonts/fonts_j/mplus_j12r.bdf?revision=1.183
  - data/CP932.TXT
    cp932 to Unicode table
    オリジナルファイル：
    http://www.unicode.org/Public/MAPPINGS/VENDORS/MICSFT/WINDOWS/CP932.TXT
  - data/JIS0201.TXT
    JIS X 0201 (1976) to Unicode 1.1 Table
    オリジナルファイル：
    http://www.unicode.org/Public/MAPPINGS/OBSOLETE/EASTASIA/JIS/JIS0201.TXT


コンパイルに必要なソフトウェア
  - make
  - Ruby
  - FontForge
  - Potrace
  - bdfresize
  - patch
  - sed

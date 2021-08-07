SECTION "Assets", ROMX[$4000], BANK[1]

noCGBScreen::
	incbin "assets/nocgberror.fx"
noCGBScreenMap::
	incbin "assets/nocgberror.tilemap"

koishi::
	incbin "assets/koishi/00.cfx"         ; 1
	incbin "assets/koishi/10.cfx"         ; 2
	incbin "assets/koishi/01.cfx"         ; 3
	incbin "assets/koishi/11.cfx"         ; 4
	incbin "assets/koishi/02.cfx"         ; 5
	incbin "assets/koishi/12.cfx"         ; 6
	incbin "assets/koishi/03.cfx"         ; 7
	incbin "assets/koishi/13.cfx"         ; 8
koishi_walk::
	incbin "assets/koishi/03_walk.cfx"    ; 9
	incbin "assets/koishi/13_walk.cfx"    ; 10
	incbin "assets/koishi/03_walk2.cfx"   ; 11
	incbin "assets/koishi/13_walk2.cfx"   ; 12
	incbin "assets/koishi/eyeclosed0.cfx" ; 13
	incbin "assets/koishi/eyeclosed1.cfx" ; 14
	incbin "assets/koishi/eyeclosing.cfx" ; 15

include "src/palettes.asm"
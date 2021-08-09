SECTION "Assets", ROMX[$4000], BANK[1]

noCGBScreen::
	incbin "assets/nocgberror.fx"
noCGBScreenMap::
	incbin "assets/nocgberror.tilemap"

koishi::
	incbin "assets/koishi/00.cfx"           ; 00
	incbin "assets/koishi/10.cfx"           ; 01
	incbin "assets/koishi/01.cfx"           ; 02
	incbin "assets/koishi/11.cfx"           ; 03
	incbin "assets/koishi/02.cfx"           ; 04
	incbin "assets/koishi/12.cfx"           ; 05
	incbin "assets/koishi/03.cfx"           ; 06
	incbin "assets/koishi/13.cfx"           ; 07
koishi_walk::
	incbin "assets/koishi/03_walk.cfx"      ; 08
	incbin "assets/koishi/13_walk.cfx"      ; 09
	incbin "assets/koishi/03_walk2.cfx"     ; 0A
	incbin "assets/koishi/13_walk2.cfx"     ; 0B
koishi_eyes::
	incbin "assets/koishi/eyeclosed0.cfx"   ; 0C
	incbin "assets/koishi/eyeclosed1.cfx"   ; 0D
	incbin "assets/koishi/eyeclosing.cfx"   ; 0E
koishi_jump::
	incbin "assets/koishi/jump01.cfx"       ; 0F
        incbin "assets/koishi/jump11.cfx"       ; 10
        incbin "assets/koishi/jump02.cfx"       ; 11
        incbin "assets/koishi/jump12.cfx"       ; 12
        incbin "assets/koishi/jump03.cfx"       ; 13
        incbin "assets/koishi/jump13.cfx"       ; 14
	incbin "assets/koishi/jump01closed.cfx" ; 15
        incbin "assets/koishi/jump11closed.cfx" ; 16

include "src/palettes.asm"
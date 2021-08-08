SECTION "Assets", ROMX[$4000], BANK[1]

noCGBScreen::
	incbin "assets/nocgberror.fx"
noCGBScreenMap::
	incbin "assets/nocgberror.tilemap"

koishi::
	incbin "assets/koishi/00.cfx"           ; 01
	incbin "assets/koishi/10.cfx"           ; 02
	incbin "assets/koishi/01.cfx"           ; 03
	incbin "assets/koishi/11.cfx"           ; 04
	incbin "assets/koishi/02.cfx"           ; 05
	incbin "assets/koishi/12.cfx"           ; 06
	incbin "assets/koishi/03.cfx"           ; 07
	incbin "assets/koishi/13.cfx"           ; 08
koishi_walk::
	incbin "assets/koishi/03_walk.cfx"      ; 09
	incbin "assets/koishi/13_walk.cfx"      ; 0A
	incbin "assets/koishi/03_walk2.cfx"     ; 0B
	incbin "assets/koishi/13_walk2.cfx"     ; 0C
koishi_eyes::
	incbin "assets/koishi/eyeclosed0.cfx"   ; 0D
	incbin "assets/koishi/eyeclosed1.cfx"   ; 0E
	incbin "assets/koishi/eyeclosing.cfx"   ; 0F
koishi_jump::
	incbin "assets/koishi/jump01.cfx"       ; 10
        incbin "assets/koishi/jump11.cfx"       ; 11
        incbin "assets/koishi/jump02.cfx"       ; 12
        incbin "assets/koishi/jump12.cfx"       ; 13
        incbin "assets/koishi/jump03.cfx"       ; 14
        incbin "assets/koishi/jump13.cfx"       ; 15
	incbin "assets/koishi/jump01closed.cfx" ; 16
        incbin "assets/koishi/jump11closed.cfx" ; 17

include "src/palettes.asm"
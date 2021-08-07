SECTION "Music", ROMX[$6CB0], BANK[1]
include "src/sound/hartmanns_youkai_girl/channel1.asm"
include "src/sound/hartmanns_youkai_girl/channel2.asm"
include "src/sound/hartmanns_youkai_girl/channel3.asm"
include "src/sound/hartmanns_youkai_girl/channel4.asm"

KoishiTheme::
	db $100 - $7A
	db %100
	dw musicChan1KoishiTheme
	dw musicChan2KoishiTheme
	dw musicChan3KoishiTheme
	dw musicChan4KoishiTheme
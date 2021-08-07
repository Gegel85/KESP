musicChan2KoishiTheme::
	setRegisters $A5, $F4, $00, $00
.loop:
	stopMusic
	jump .loop
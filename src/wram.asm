SECTION "RAM", WRAM0

include "src/sound/constants.asm"

randomRegister::
	ds $1
frameCounter::
	ds $1
keysDisabled::
	ds $1

playingMusics::
playingMusic1::
	ds MUSIC_STRUCT_SIZE
playingMusic2::
	ds MUSIC_STRUCT_SIZE
playingMusic3::
	ds MUSIC_STRUCT_SIZE
playingMusic4::
	ds MUSIC_STRUCT_SIZE

playingSfxTimers::
playingSfx1Timer::
	ds $1
playingSfx2Timer::
	ds $1
playingSfx3Timer::
	ds $1
playingSfx4Timer::
	ds $1

nbRepeated::
	ds $1

; Game stuff
playerPos::
playerPosX::
	ds $1
playerPosY::
	ds $1
playerSpeed::
playerSpeedX::
	ds $1
playerSpeedY::
	ds $1
playerState::
	ds $1
playerAnim::
	ds $1
playerAnimCtr::
	ds $1



SECTION "AUDIO_REGISTERS_MIRROR", WRAM0[$C410]
Channel1Mirror::
	ds $6
Channel2Mirror::
	ds $4
Channel3Mirror::
	ds $6
Channel4Mirror::
	ds $4
APUParamsMirror::
	ds $3

SECTION "OAM", WRAM0[$C500]
oamSrc::
	ds $A0

stackTop::
	ds $C800 - stackTop
stackBottom::

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
playerPosX::
	ds $2
playerSpeedX::
	ds $2
playerPosY::
	ds $2
playerSpeedY::
	ds $2
playerState::
	ds $1
playerAnim::
	ds $1
playerAnimCtr::
	ds $1


mapWidth::
	ds $1
mapHeight::
	ds $1
mapNbObjects::
	ds $1
mapObjects::
	ds $20 * $5

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

SECTION "LoadedMapPart1", WRAMX[$D000], BANK[1]
loadedMapPart1::
	ds $1000

SECTION "LoadedMapPart2", WRAMX[$D000], BANK[2]
loadedMapPart2::
	ds $1000

SECTION "LoadedMapPart3", WRAMX[$D000], BANK[3]
loadedMapPart3::
	ds $1000

SECTION "LoadedMapPart4", WRAMX[$D000], BANK[4]
loadedMapPart4::
	ds $1000
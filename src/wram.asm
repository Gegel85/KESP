SECTION "RAM", WRAM0

include "src/constants.asm"
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

cameraX::
	ds $2
cameraY::
	ds $2

cameraScreenTopLeftPtr::
	ds $2
cameraMapTopLeftPtrBank::
	ds $1
cameraMapTopLeftPtr::
	ds $2
cameraScreenTopRightPtr::
	ds $2
cameraMapTopRightPtrBank::
	ds $1
cameraMapTopRightPtr::
	ds $2
cameraScreenBottomLeftPtr::
	ds $2
cameraMapBottomLeftPtrBank::
	ds $1
cameraMapBottomLeftPtr::
	ds $2


mapNbObjects::
	ds $1
mapWidth::
	ds $1
mapHeight::
	ds $1
mapObjects::
	ds $20 * OBJECT_STRUCT_SIZE

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

SECTION "LoadedMapPart5", WRAMX[$D000], BANK[5]
loadedMapPart5::
	ds $1000

SECTION "LoadedMapPart6", WRAMX[$D000], BANK[6]
loadedMapPart6::
	ds $1000
include "src/constants.asm"
include "src/macro.asm"
include "src/registers.asm"

SPEED_FORCE = 2
GRAVITY_COUNTER = 6
TIME_SPAWN_TIMING = 8
MIN_DIFFICULTY = 7
MAX_DIFFICULTY = 3

SECTION "Main", ROM0

notCGB::
	call waitVBLANKInt
	reset lcdCtrl
	reg dmgBgPalData, %00011011

	reg ROMBankSelect, 3
	ld hl, noCGBScreen
	ld de, VRAMStart
	ld bc, noCGBScreenMap - noCGBScreen
	call copyMemory

	ld b, 18
	push hl
	ld hl, VRAMBgStart
	pop de
.loop:
	ld c, 20
.miniLoop:
	ld a, [de]
	ld [hli], a
	inc de
	dec c
	jr nz, .miniLoop
	push bc
	ld bc, 12
	add hl, bc
	pop bc
	dec b
	jr nz, .loop

	reg lcdCtrl, %11010001

; Locks the CPU
; Params:
;	None
; Return:
;	Never
; Registers:
;	N/A
lockup::
	reset interruptFlag
	ld [interruptEnable], a
.loop:
	halt
	jr .loop

; Main function
main::
	; We init the stack here because init fills the whole RAM with 0
	; If we add used
	ld sp, $FFFF
	cp CGB_A_INIT
	jp nz, notCGB
	call init
; Fall through to main_menu.asm, the main_menu loading function

include "src/menus/main_menu.asm"
include "src/menus/in_game.asm"
include "src/init.asm"
include "src/interrupts.asm"
include "src/sound/music.asm"
include "src/sound/sfx.asm"
include "src/utils.asm"
include "src/map.asm"

include "src/sound/hartmanns_youkai_girl/main.asm"
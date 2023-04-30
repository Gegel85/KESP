include "src/player/struct.asm"

; Switches to the in game menu
inGame::
	; Initialization routine
	; Wait for VBLANK and disable the LCD
	call waitVBLANKInt
	reset lcdCtrl
	; Load koishi's sprites in memory
	ld hl, koishi
	ld bc, $10 * $17
	ld de, VRAMStart
	call copyMemory

	; Load terrain tiles in memory
	ld de, VRAMStart + $1000
	ld a, $FF
	ld bc, $10
	call fillMemory
	ld hl, terrain
	ld bc, terrainEnd - terrain
	call copyMemory

	; Load sprite palettes
	ld de, cgbObjPalIndex
	ld a, $80
	ld [de], a
	inc e
	ld hl, koishiPal
	ld bc, $40
	call streamMemory

	; Load background palettes
	ld de, cgbBgPalIndex
	ld a, $80
	ld [de], a
	inc e
	ld hl, terrainPal
	ld bc, $40
	call streamMemory

	; Load first map
	xor a
	call loadMap

	; Reactivate the LCD
	ld a, 1
	ld [ROMBankSelect], a
	reg lcdCtrl, %11000011
	; Start the music
	ld hl, KoishiTheme
	ld de, playingMusics
	call startMusic

	reset player + PLAYER_STATE
.loop:
	ld hl, lcdLine
	ld a, $90 - 1
.halt::
	halt
	cp [hl]
	jr nc, .halt

.update:
	ld hl, player
	call updatePlayer
	call updatePlayerSprite

	call preparePlayer
	call getKeys

	bit RIGHT_BIT, a
	call z, .right

	bit LEFT_BIT, a
	call z, .left

	bit DOWN_BIT, a
	call z, .down

	bit A_BIT, a
	call z, .a

	bit B_BIT, a
	call z, .b

	bit SELECT_BIT, a
	call z, .select

	bit START_BIT, a
	call z, .start

	ld hl, player + PLAYER_STATE
	ld a, [hl]
	and STATE_WALK_REQUEST
	jr nz, .loop
	ld a, [hl]
	and ~STATE_WALKING
	ld [hl], a
	jr .loop

.right:
	; Right
	push af
	ld a, [player + PLAYER_STATE]
	and STATE_JUMPING
	jr nz, .reduceLeftMomentum

	ld a, [player + PLAYER_STATE]
	and STATE_OPENING
	jr nz, .retRight
	ld a, 1
	ld [player + PLAYER_SPEEDX], a
	ld a, [player + PLAYER_STATE]
	or STATE_FACE_RIGHT
	jr .walk

.reduceLeftMomentum::
	ld hl, player + PLAYER_SPEEDX + 1
	ld a, [hld]
	ld c, a
	ld b, [hl]
	bit 7, b
	jr nz, .allGoodRight
	ld a, 2
	cp b
	jr nz, .allGoodRight
	jr c, .retRight
	xor a
	or c
	jr nz, .allGoodRight
.retRight::
	pop af
	ret
.allGoodRight::
	ld a, c
	add $10
	ld c, a
	ld a, b
	adc 0
	ld [hli], a
	ld [hl], c
	pop af
	ret

.left:
	; Left
	push af
	ld a, [player + PLAYER_STATE]
	and STATE_JUMPING
	jr nz, .reduceRightMomentum
	ld a, [player + PLAYER_STATE]
	and STATE_OPENING
	jr nz, .leftEnd
	ld hl, player + PLAYER_SPEEDX
	ld a, -1
	ld [player + PLAYER_SPEEDX], a
	ld a, [player + PLAYER_STATE]
	and ~STATE_FACE_RIGHT
	jr .walk

.reduceRightMomentum::
	ld hl, player + PLAYER_SPEEDX + 1
	ld a, [hld]
	ld c, a
	ld b, [hl]
	bit 7, b
	jr z, .allGood
	ld a, $FE
	cp b
	jr c, .allGood
	jr nz, .leftEnd
	xor a
	or c
	jr nz, .allGood
	pop af
	ret
.allGood::
	ld a, c
	sub $10
	ld c, a
	ld a, b
	sbc 0
	ld [hli], a
	ld [hl], c
	pop af
	ret

.walk:
	or STATE_WALK_REQUEST
	ld c, a
	or STATE_WALKING
	ld [player + PLAYER_STATE], a
	ld a, STATE_WALKING
	and c
	jr nz, .leftEnd
	ld [player + PLAYER_ANIM], a
	ld [player + PLAYER_ANIM + PLAYER_ANIM_CTR], a
.leftEnd:
	pop af
	ret

.down:
	; Go through platform
	ret

.a:
	; Jump
	push af
	ld a, [player + PLAYER_STATE]
	and STATE_JUMPING
	jr z, .aNew
	ld a, [player + PLAYER_ANIM]
	or a
	jr z, .aOK
	pop af
	ret
.aNew::
	ld hl, player + PLAYER_ANIM
	xor a
	ld [hli], a
	ld [hli], a
.aOK::
	reg player + PLAYER_SPEEDY, $FD
	pop af
	ret

.b:
	; Run/Action (depends on the nearby object)
	ret

.start:
	; Pause
	ret

; Called when select is pressed.
.select:
	; Close eyes
	push af
	ld hl, player + PLAYER_STATE
	ld a, [hl]

	; If we are already in the opening/closing
	; animation or if we are in the air, bail out.
	and STATE_OPENING | STATE_JUMPING
	jr nz, .selectEnd

	; We add the opening flag to the state
	ld a, [hl]
	or STATE_OPENING
	ld [hli], a
	; We also reset the animation state
	xor a
	ld [hli], a
	ld [hl], a
.selectEnd:
	pop af
	ret


include "src/player/logic.asm"
include "src/player/render.asm"
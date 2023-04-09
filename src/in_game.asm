updatePlayerSprite::
	ld hl, oamSrc
	ld a, [playerPosX]
	ld b, a
	ld a, [playerPosY]
	ld c, a

	ld a, [playerState]
	and STATE_FACE_RIGHT
	ld d, 8
	jr z, .right
	ld d, 0
.right::

	ld a, [playerState]
	and STATE_OPENING
	jr nz, .drawStart
	ld a, [playerState]
	and STATE_WALKING
	jr z, .drawStart
	ld a, [playerAnim]
	and 1
	jr nz, .drawStart
	inc c

	; 00
.drawStart:
	ld a, c
	add $10
	ld [hli], a
	ld a, b
	add $8
	add d
	ld [hli], a
	xor a
	ld [hli], a
	ld a, d
	rla
	rla
	ld [hli], a

	; 10
	ld a, c
	add $10
	ld [hli], a
	ld a, b
	add $10
	sub d
	ld [hli], a
	ld a, 1
	ld [hli], a
	ld a, d
	rla
	rla
	ld [hli], a

	; 01
	ld a, c
	add $18
	ld [hli], a
	ld a, b
	add $8
	add d
	ld [hli], a

	ld a, [playerState]
	and STATE_OPENING
	ld a, 2
	jr nz, .01draw

	ld a, [playerState]
	and STATE_EYE_CLOSED | STATE_JUMPING
	ld e, a
	ld a, 2
	jr z, .01draw

	ld a, STATE_EYE_CLOSED | STATE_JUMPING
	cp e
	ld a, $15
	jr z, .01draw

	ld a, STATE_EYE_CLOSED
	and e
	ld a, 12
	jr nz, .01draw

	ld a, $F
.01draw::
	ld [hli], a
	ld a, d
	rla
	rla
	inc a
	ld [hli], a

	; 11
	ld a, c
	add $18
	ld [hli], a
	ld a, b
	add $10
	sub d
	ld [hli], a

	ld a, [playerState]
	and STATE_OPENING
	ld a, 14
	jr nz, .11draw

	ld a, [playerState]
	and STATE_EYE_CLOSED | STATE_JUMPING
	ld e, a
	ld a, 3
	jr z, .11draw

	ld a, STATE_EYE_CLOSED | STATE_JUMPING
	cp e
	ld a, $16
	jr z, .11draw

	ld a, STATE_EYE_CLOSED
	and e
	ld a, $D
	jr nz, .11draw

	ld a, $10
.11draw::
	ld [hli], a
	ld a, d
	rla
	rla
	inc a
	ld [hli], a

	ld a, [playerState]
	and STATE_JUMPING
	jr z, .draw02
	dec c
.draw02:
	; 02
	ld a, c
	add $20
	ld [hli], a
	ld a, b
	add $8
	add d
	ld [hli], a
	ld a, [playerState]
	and STATE_JUMPING
	ld a, 4
	jr z, .02draw
	ld a, $11
.02draw:
	ld [hli], a
	ld a, d
	rla
	rla
	ld [hli], a

	; 12
	ld a, c
	add $20
	ld [hli], a
	ld a, b
	add $10
	sub d
	ld [hli], a
	ld a, [playerState]
	and STATE_JUMPING
	ld a, 5
	jr z, .12draw
	ld a, $12
.12draw:
	ld [hli], a
	ld a, d
	rla
	rla
	ld [hli], a

	; 03
	ld a, c
	add $28
	ld [hli], a
	ld a, b
	add $8
	add d
	push de
	ld d, a
	ld e, 6

	ld a, [playerState]
	and STATE_OPENING
	jr nz, .keepCopyLastX

	ld a, [playerState]
	and STATE_JUMPING
	ld e, $13
	jr nz, .keepCopyLastX

	ld e, 6
	ld a, [playerState]
	and STATE_WALKING
	jr z, .keepCopyLastX

	ld a, [playerAnim]
	and 1
	jr nz, .keepCopyLastX

	ld a, [playerAnim]
	and 2
	jr nz, .animFrame2X

	ld e, 8
	jr .keepCopyLastX
.animFrame2X::
	ld e, 10
.keepCopyLastX::
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	pop de
	ld a, d
	rla
	rla
	inc a
	ld [hli], a

	; 13
	ld a, c
	add $28
	ld [hli], a
	ld a, b
	add $10
	sub d
	push de
	ld d, a
	ld e, 7
	ld a, [playerState]
	and STATE_OPENING
	jr nz, .keepCopyLastY

	ld a, [playerState]
	and STATE_JUMPING
	ld e, $14
	jr nz, .keepCopyLastY
	ld e, 7

	ld a, [playerState]
	and STATE_WALKING
	jr z, .keepCopyLastY

	ld a, [playerAnim]
	and 1
	jr nz, .keepCopyLastY

	ld a, [playerAnim]
	and 2
	jr nz, .animFrame2Y

	ld e, 9
	jr .keepCopyLastY
.animFrame2Y::
	ld e, 11
.keepCopyLastY::
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	pop de
	ld a, d
	rla
	rla
	inc a
	ld [hli], a
	ret


updatePlayer::
	ld a, [playerAnimCtr]
	inc a
	ld [playerAnimCtr], a
	and $F
	jr nz, .noAnimChange
	ld a, [playerAnim]
	inc a
	ld [playerAnim], a
.noAnimChange:
	ld hl, playerState
	ld a, [hli]
	and STATE_OPENING
	jp nz, .checkClosingOpening
	ld hl, playerSpeedY + 1

	ld a, [hl]
	ld c, a
	add $40
	ld [hld], a
	ld a, [hl]
	ld b, a
	adc 0
	bit 7, a
	jr nz, .speedChange
	cp $06
	jr nc, .noSpeedChange
.speedChange:
	ld [hld], a
	jr .applySpeedY

.noSpeedChange:
	dec hl

.applySpeedY:
	ld a, [hld]
	ld e, a
	ld a, [hl]
	push hl
	ld l, e
	ld h, a
	ld e, a
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	ld a, b
	ld [hli], a
	ld [hl], c

	ld a, b
	and %11111000
	ld b, a
	ld a, e
	and %11111000
	cp b
	jr z, .applySpeedX

	; TODO: Support other map size, different from 32x32
	ld c, a
	ld a, b
	sub c
	ld c, a
	jr nc, .noCarryY
	ld b, $FF
	jr .updatePlayerPtrY
.noCarryY:
	ld b, 0
.updatePlayerPtrY:
	sla c
	rl b
	sla c
	rl b
	ld hl, playerMapPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	ld a, [playerSpeedY]
	bit 7, a
	jr nz, .speedYNeg
	ld bc, 32 * 3
	add hl, bc
	ld bc, -32
	ld d, -8
	jr .updatePlayerPtrYLoop
.speedYNeg:
	ld bc, 32
	ld d, 8

.updatePlayerPtrYLoop:
	ld a, [hl]
	cp $11
	jr nc, .savePtrY
	add hl, bc
	ld a, h
	and $DF
	set 4, a
	ld h, a
	ld a, [playerPosY]
	add d
	ld [playerPosY], a
	jr .updatePlayerPtrYLoop

.savePtrY:
	ld a, [playerSpeedY]
	bit 7, a
	jr nz, .ptrYSave
	ld bc, -32 * 3
	add hl, bc

.ptrYSave:
	ld a, l
	ld b, h
	ld hl, playerMapPtr
	ld [hli], a
	ld [hl], b

.applySpeedX:
	ld hl, playerSpeedX + 1
	ld a, [hld]
	ld c, a
	ld a, [hld]
	ld b, a
	ld a, [hld]
	ld e, a
	ld a, [hl]
	push hl
	ld l, e
	ld h, a
	ld e, a
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	ld a, b
	ld [hli], a
	ld [hl], c

	ld a, b
	and %11111000
	ld b, a
	ld a, e
	and %11111000
	cp b
	jr z, .checkCollisions

	; TODO: Support other map size, different from 32x32
	ld c, a
	ld a, b
	sub c
	ld c, a
	jr nc, .noCarryX
	ld b, $FF
	jr .updatePlayerPtrX
.noCarryX:
	ld b, 0
.updatePlayerPtrX:
	rrc b
	rr c
	rrc b
	rr c
	rrc b
	rr c
	ld hl, playerMapPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	ld a, [playerSpeedX]
	bit 7, a
	jr nz, .speedXNeg

	ld bc, 1
	add hl, bc

	ld bc, -1
	ld d, -8
	jr .updatePlayerPtrXLoop
.speedXNeg:
	ld bc, 1
	ld d, 8

.updatePlayerPtrXLoop:
	ld a, [hl]
	cp $11
	jr nc, .savePtrX

	ld a, l
	and %11100000
	add hl, bc
	ld e, a
	ld a, %00011111
	and l
	or e
	ld a, l

	ld a, [playerPosX]
	add d
	ld [playerPosX], a
	jr .updatePlayerPtrXLoop

.savePtrX:
	ld a, [playerSpeedX]
	bit 7, a
	jr nz, .ptrXSave
	ld bc, -1
	add hl, bc

.ptrXSave:
	ld a, l
	ld b, h
	ld hl, playerMapPtr
	ld [hli], a
	ld [hl], b

.checkClosingOpening::
	ld a, [hld]
	cp 4
	jr nz, .checkCollisions
	ld a, [hl]
	xor STATE_EYE_CLOSED | STATE_OPENING
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a

.checkCollisions::
	ld hl, playerPosY
	ld a, [hl]
	cp 144 - 32
	jr c, .checkGround

	ld a, 144 - 32
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a

	ld hl, playerSpeedX
	ld [hli], a
	ld [hli], a

	ld a, [playerState]
	and ~STATE_JUMPING
	ld [playerState], a

.checkGround:
	ld hl, playerMapPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a

	; TODO: Support other map size, different from 32x32
	ld bc, 4 * 32
	add hl, bc
	ld a, h
	and $DF
	set 4, a
	ld h, a
	ld a, [hli]
	cp $11
	jr c, .onGround
	ld a, [hl]
	cp $11
	jr c, .onGround

	ld a, [playerState]
	or STATE_JUMPING
	ld [playerState], a
	xor a
	ld [playerPosY + 1], a
	jr .end
.onGround:
	ld a, [playerState]
	and ~STATE_JUMPING
	ld [playerState], a
	xor a
	ld hl, playerSpeedY
	ld [hli], a
	ld [hl], a
	ld hl, playerSpeedX
	ld [hli], a
	ld [hl], a

.end:
	jp calcCamera


preparePlayer::
	ld a, [playerState]
	and STATE_JUMPING | STATE_EYE_CLOSED | STATE_OPENING | STATE_FACE_RIGHT | STATE_WALKING
	ld [playerState], a
	ret


inGame::
	call waitVBLANK
	reset lcdCtrl
	ld hl, koishi
	ld bc, $10 * $17
	ld de, VRAMStart
	call copyMemory

	ld de, VRAMStart + $1000
	ld a, $FF
	ld bc, $10
	call fillMemory
	ld hl, terrain
	ld bc, terrainEnd - terrain
	call copyMemory

	ld hl, cgbObjPalIndex
	ld a, $80
	ld [hli], a
	ld de, koishiPal
	ld b, $40
.objPalLoop::
	ld a, [de]
	inc de
	ld [hl], a
	dec b
	jr nz, .objPalLoop

	ld hl, cgbBgPalIndex
	ld a, $80
	ld [hli], a
	ld de, terrainPal
	ld b, $40
.bgPalLoop::
	ld a, [de]
	inc de
	ld [hl], a
	dec b
	jr nz, .bgPalLoop

	xor a
	call loadMap

	ld a, 1
	ld [ROMBankSelect], a
	reg lcdCtrl, %11000011
	ld hl, KoishiTheme
	ld de, playingMusics
	call startMusic

	reg playerState, 1
.loop:
	ld hl, lcdLine
	ld a, $90 - 1
.halt::
	halt
	cp [hl]
	jr nc, .halt
.rendering::


.update:
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

	ld hl, playerState
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
	ld a, [playerState]
	and STATE_JUMPING
	jr nz, .reduceLeftMomentum

	ld a, [playerState]
	and STATE_OPENING
	jr nz, .retRight
	ld a, 1
	ld [playerSpeedX], a
	ld a, [playerState]
	or STATE_FACE_RIGHT
	jr .walk

.reduceLeftMomentum::
	ld hl, playerSpeedX + 1
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
	ld a, [playerState]
	and STATE_JUMPING
	jr nz, .reduceRightMomentum
	ld a, [playerState]
	and STATE_OPENING
	jr nz, .leftEnd
	ld hl, playerSpeedX
	ld a, -1
	ld [playerSpeedX], a
	ld a, [playerState]
	and ~STATE_FACE_RIGHT
	jr .walk

.reduceRightMomentum::
	ld hl, playerSpeedX + 1
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
	ld [playerState], a
	ld a, STATE_WALKING
	and c
	jr nz, .leftEnd
	ld [playerAnim], a
	ld [playerAnimCtr], a
.leftEnd:
	pop af
	ret

.down:
	; Go through platform
	ret

.a:
	; Jump
	push af
	ld a, [playerState]
	and STATE_JUMPING
	jr z, .aNew
	ld a, [playerAnim]
	or a
	jr z, .aOK
	pop af
	ret
.aNew::
	ld hl, playerAnim
	xor a
	ld [hli], a
	ld [hli], a
.aOK::
	reg playerSpeedY, $FD
	pop af
	ret

.b:
	; Run/Action (depends on the nearby object)
	ret

.start:
	; Pause
	ret

.select:
	; Close eyes
	push af
	ld hl, playerState
	ld a, [hl]
	and STATE_OPENING
	jr nz, .selectEnd
	ld a, [hl]
	and STATE_JUMPING
	jr nz, .selectEnd

	ld a, [hl]
	or STATE_OPENING
	ld [hli], a
	xor a
	ld [hli], a
	ld [hl], a
.selectEnd:
	pop af
	ret

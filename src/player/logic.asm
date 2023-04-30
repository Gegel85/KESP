; Updates the player animation
; Params:
;    ha -> Address to the player struct
; Return:
;    hl -> Ptr to PLAYER_ANIM field
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
updatePlayerAnimation:
	add PLAYER_ANIM_CTR
	ld l, a
	ld a, [hl]
	inc a
	ld [hld], a
	; Point hl to PLAYER_ANIM
	; Animations are 15 frames long
	and $F
	ret nz
	inc [hl]
	ret

; Updates the player during the closing/opening animation
; Params:
;    hl -> Address to the player struct's PLAYER_ANIM element
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
closingOpeningAnimation:
	ld a, [hld]
	; Wait for 4 animation cycles
	cp 4
	ret nz

	ld a, [hl]
	; We remove the STATE_OPENING bit and invert the closed state
	xor STATE_EYE_CLOSED | STATE_OPENING
	ld [hli], a
	; Reset the animation counter
	xor a
	ld [hli], a
	ld [hli], a
	ret

; Updates the player
; Params:
;    hl -> address to the player struct
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
updatePlayer::
	ld a, l
	ld [$FFFE], a
	call updatePlayerAnimation

	; PLAYER_STATE
	dec l
	ld a, [hli]
	and STATE_OPENING
	jp nz, closingOpeningAnimation

	ld hl, player + PLAYER_SPEEDY + 1
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
	ld hl, player + PLAYER_MAP_PTR
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	ld a, [player + PLAYER_SPEEDY]
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
	ld a, [player + PLAYER_POSY]
	add d
	ld [player + PLAYER_POSY], a
	jr .updatePlayerPtrYLoop

.savePtrY:
	ld a, [player + PLAYER_SPEEDY]
	bit 7, a
	jr nz, .ptrYSave
	ld bc, -32 * 3
	add hl, bc

.ptrYSave:
	ld a, l
	ld b, h
	ld hl, player + PLAYER_MAP_PTR
	ld [hli], a
	ld [hl], b

.applySpeedX:
	ld hl, player + PLAYER_SPEEDX + 1
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
	ld hl, player + PLAYER_MAP_PTR
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	ld a, [player + PLAYER_SPEEDX]
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

	ld a, [player + PLAYER_POSX]
	add d
	ld [player + PLAYER_POSX], a
	jr .updatePlayerPtrXLoop

.savePtrX:
	ld a, [player + PLAYER_SPEEDX]
	bit 7, a
	jr nz, .ptrXSave
	ld bc, -1
	add hl, bc

.ptrXSave:
	ld a, l
	ld b, h
	ld hl, player + PLAYER_MAP_PTR
	ld [hli], a
	ld [hl], b

.checkCollisions::
	ld hl, player + PLAYER_POSY
	ld a, [hl]
	cp 144 - 32
	jr c, .checkGround

	ld a, 144 - 32
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a

	ld hl, player + PLAYER_SPEEDX
	ld [hli], a
	ld [hli], a

	ld a, [player + PLAYER_STATE]
	and ~STATE_JUMPING
	ld [player + PLAYER_STATE], a

.checkGround:
	ld hl, player + PLAYER_MAP_PTR
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

	ld a, [player + PLAYER_STATE]
	or STATE_JUMPING
	ld [player + PLAYER_STATE], a
	xor a
	ld [player + PLAYER_POSY + 1], a
	jr .end
.onGround:
	ld a, [player + PLAYER_STATE]
	and ~STATE_JUMPING
	ld [player + PLAYER_STATE], a
	xor a
	ld hl, player + PLAYER_SPEEDY
	ld [hli], a
	ld [hl], a
	ld hl, player + PLAYER_SPEEDX
	ld [hli], a
	ld [hl], a

.end:
	jp calcCamera


preparePlayer::
	ld a, [player + PLAYER_STATE]
	and STATE_JUMPING | STATE_EYE_CLOSED | STATE_OPENING | STATE_FACE_RIGHT | STATE_WALKING
	ld [player + PLAYER_STATE], a
	ret


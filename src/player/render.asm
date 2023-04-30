updatePlayerSprite::
	ld hl, oamSrc
	ld a, [player + PLAYER_POSX]
	ld b, a
	ld a, [player + PLAYER_POSY]
	ld c, a

	ld a, [player + PLAYER_STATE]
	and STATE_FACE_RIGHT
	ld d, 8
	jr z, .right
	ld d, 0
.right::

	ld a, [player + PLAYER_STATE]
	and STATE_OPENING
	jr nz, .drawStart
	ld a, [player + PLAYER_STATE]
	and STATE_WALKING
	jr z, .drawStart
	ld a, [player + PLAYER_ANIM]
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

	ld a, [player + PLAYER_STATE]
	and STATE_OPENING
	ld a, 2
	jr nz, .01draw

	ld a, [player + PLAYER_STATE]
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

	ld a, [player + PLAYER_STATE]
	and STATE_OPENING
	ld a, 14
	jr nz, .11draw

	ld a, [player + PLAYER_STATE]
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

	ld a, [player + PLAYER_STATE]
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
	ld a, [player + PLAYER_STATE]
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
	ld a, [player + PLAYER_STATE]
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

	ld a, [player + PLAYER_STATE]
	and STATE_OPENING
	jr nz, .keepCopyLastX

	ld a, [player + PLAYER_STATE]
	and STATE_JUMPING
	ld e, $13
	jr nz, .keepCopyLastX

	ld e, 6
	ld a, [player + PLAYER_STATE]
	and STATE_WALKING
	jr z, .keepCopyLastX

	ld a, [player + PLAYER_ANIM]
	and 1
	jr nz, .keepCopyLastX

	ld a, [player + PLAYER_ANIM]
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
	ld a, [player + PLAYER_STATE]
	and STATE_OPENING
	jr nz, .keepCopyLastY

	ld a, [player + PLAYER_STATE]
	and STATE_JUMPING
	ld e, $14
	jr nz, .keepCopyLastY
	ld e, 7

	ld a, [player + PLAYER_STATE]
	and STATE_WALKING
	jr z, .keepCopyLastY

	ld a, [player + PLAYER_ANIM]
	and 1
	jr nz, .keepCopyLastY

	ld a, [player + PLAYER_ANIM]
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



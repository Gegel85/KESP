drawPlayer::
	ld hl, oamSrc
	ld a, [playerPosX]
	ld b, a
	ld a, [playerPosY]
	ld c, a

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
	ld [hli], a
	ld a, 1
	ld [hli], a
	inc a
	ld [hli], a

	; 10
	ld a, c
	add $10
	ld [hli], a
	ld a, b
	add $10
	ld [hli], a
	ld a, 2
	ld [hli], a
	ld [hli], a

	; 01
	ld a, c
	add $18
	ld [hli], a
	ld a, b
	add $8
	ld [hli], a
	ld a, [playerState]
	and STATE_CLOSED
	ld a, 3
	jr z, .01draw
	ld a, 13
.01draw::
	ld [hli], a
	ld a, 1
	ld [hli], a

	; 11
	ld a, c
	add $18
	ld [hli], a
	ld a, b
	add $10
	ld [hli], a
	ld a, [playerState]
	and STATE_CLOSED
	ld a, 14
	jr nz, .11draw
	ld a, [playerState]
	and STATE_OPENING
	ld a, 4
	jr z, .11draw
	ld a, 15
.11draw::
	ld [hli], a
	ld a, 1
	ld [hli], a

	; 02
	ld a, c
	add $20
	ld [hli], a
	ld a, b
	add $8
	ld [hli], a
	ld a, 5
	ld [hli], a
	xor a
	ld [hli], a

	; 12
	ld a, c
	add $20
	ld [hli], a
	ld a, b
	add $10
	ld [hli], a
	ld a, 6
	ld [hli], a
	xor a
	ld [hli], a

	; 03
	ld a, c
	add $28
	ld [hli], a
	ld a, b
	add $8
	ld d, a
	ld e, 7
	ld a, [playerState]
	and STATE_OPENING
	jr nz, .keepCopyLastX
	ld a, [playerState]
	and STATE_WALKING
	jr z, .keepCopyLastX
	ld a, [playerAnim]
	and 1
	jr nz, .keepCopyLastX
	ld a, [playerAnim]
	and 2
	jr nz, .animFrame2X
	ld e, 9
	jr .keepCopyLastX
.animFrame2X::
	ld e, 11
.keepCopyLastX::
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, 1
	ld [hli], a

	; 13
	ld a, c
	add $28
	ld [hli], a
	ld a, b
	add $10
	ld d, a
	ld e, 8
	ld a, [playerState]
	and STATE_OPENING
	jr nz, .keepCopyLastY

	ld a, [playerState]
	and STATE_WALKING
	jr z, .keepCopyLastY

	ld a, [playerAnim]
	and 1
	jr nz, .keepCopyLastY

	ld a, [playerAnim]
	and 2
	jr nz, .animFrame2Y

	ld e, 10
	jr .keepCopyLastY
.animFrame2Y::
	ld e, 12
.keepCopyLastY::
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, 1
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
	ret


inGame::
	call waitVBLANK
	reset lcdCtrl
	ld hl, koishi
	ld bc, $10 * 15
	ld de, VRAMStart + $10
	call copyMemory

	ld hl, cgbObjPalIndex
	ld a, $80
	ld [hli], a
	ld de, koishiPal
	ld b, $18
.bgPalLoop::
	ld a, [de]
	inc de
	ld [hl], a
	dec b
	jr nz, .bgPalLoop

	reg lcdCtrl, %11011011
	ld hl, KoishiTheme
	ld de, playingMusics
	call startMusic

	reg playerState, 1
.loop:
	halt
	call updatePlayer
	call drawPlayer
	call getKeys

	jr .loop
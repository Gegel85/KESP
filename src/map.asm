mapArray::
	db BANK(mapA1_1)
	dw mapA1_1

tilePaletteArray::
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

loadMap::
	rla
	ld b, 0
	ld c, a
	ld hl, mapArray
	add hl, bc
	ld a, [hli]
	ld [ROMBankSelect], a
	ld a, [hli]
	ld h, [hl]
	ld l, a

loadMapPtr::
	ld de, mapNbObjects
	ld a, [hli]
	ld c, a
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a

	ld de, player + PLAYER_POSX
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a

	ld b, OBJECT_STRUCT_SIZE
	call multiply

	ld b, d
	ld c, e
	ld de, mapObjects
	call copyMemory

uncompressMap::
	ld b, 1
	ld a, b
	ld [WRAMBankSelect], a
	ld d, h
	ld e, l
	ld hl, loadedMapPart1
.loop::
	ld a, [de]
	or a
	jr z, calcPlayerPtr
	inc de
	ld c, a
	ld a, [de]
	inc de
.innerLoop::
	ld [hli], a
	push af
	ld a, $E0
	cp h
	call z, .changeBank
	pop af
	dec c
	jr nz, .innerLoop
	jr .loop
.changeBank::
	jp crash

calcPlayerPtr::
	ld hl, loadedMapPart1
	ld b, 0
	ld a, [player + PLAYER_POSY]
	ld c, a
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b

	ld a, [player + PLAYER_POSX]
	srl a
	srl a
	srl a
	add c
	ld c, a

	add hl, bc
	ld a, l
	ld b, h
	ld hl, player + PLAYER_MAP_PTR
	ld [hli], a
	ld [hl], b

	; TODO: Support other map size, different from 32x32

drawMap::
	ld b, 1
	ld a, b
	ld [WRAMBankSelect], a
	ld hl, loadedMapPart1
	ld de, VRAMBgStart
	ld bc, $400
.loopTiles::
	ld a, [hli]
	and %00111111
	ld [de], a
	inc de
	dec bc
	xor a
	or b
	or c
	jr nz, .loopTiles

	reg VRAMBankSelect, 1
	ld hl, loadedMapPart1
	ld de, VRAMBgStart
	ld bc, $400
.loopAttr::
	push bc
	ld a, [hl]
	and %00111111
	push hl
	ld hl, tilePaletteArray
	add l
	ld l, a
	ld a, h
	adc 0
	ld h, a
	ld b, [hl]
	pop hl
	ld a, [hli]
	and %11000000
	srl a
	or b
	ld [de], a
	inc de

	pop bc
	dec bc
	xor a
	or b
	or c
	jr nz, .loopAttr
	reset VRAMBankSelect

	ld hl, player + PLAYER_POSX + 1
	ld a, [hld]
	ld [hli], a
	ld b, a
	xor a
	ld [hli], a
	ld hl, player + PLAYER_POSY + 1
	ld a, [hld]
	ld [hli], a
	ld c, a
	xor a
	ld [hli], a
	jr calcCamera.calcCamera

calcCamera::
	ld a, [player + PLAYER_POSX]
	ld b, a
	ld a, [player + PLAYER_POSY]
	ld c, a

.calcCamera:
	ld a, $48
	cp b
	jr z, .calcY

	ld [player + PLAYER_POSX], a
	sub b
	neg

	ld d, a
	ld hl, bgScrollX
	ld e, [hl]
	add e
	bit 7, d
	jr z, .checkPositiveX

	cp e
	jr c, .setScrollX
	sub e
	ld hl, player + PLAYER_POSX
	add [hl]
	ld [hl], a

	xor a
	jr .setScrollX
.checkPositiveX:
	cp $60
	jr c, .setScrollX
	sub $60
	ld hl, player + PLAYER_POSX
	add [hl]
	ld [hl], a
	ld a, $60
	jr .setScrollX

.setScrollX:
	ld hl, bgScrollX
	ld [hl], a

.calcY:
	ld a, $40
	cp c
	ret z
	ld hl, player + PLAYER_POSY
	ld [hli], a
	sub c
	cpl
	inc a

	ld d, a
	ld hl, bgScrollY
	ld e, [hl]
	add e
	bit 7, d
	jr z, .checkPositiveY

	cp e
	jr c, .setScrollY
	sub e
	ld hl, player + PLAYER_POSY
	add [hl]
	ld [hl], a

	xor a
	jr .setScrollY
.checkPositiveY:
	cp $70
	jr c, .setScrollY
	sub $70
	ld hl, player + PLAYER_POSY
	add [hl]
	ld [hl], a
	ld a, $70
	jr .setScrollY

.setScrollY:
	ld hl, bgScrollY
	ld [hl], a
	ret
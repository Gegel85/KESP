mapArray::
	db BANK(mapA1_1)
	dw mapA1_1

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

	ld de, playerPosX
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
	ld a, [playerPosY]
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

	ld a, [playerPosX]
	srl a
	srl a
	srl a
	add c
	ld c, a

	add hl, bc
	ld a, l
	ld b, h
	ld hl, playerMapPtr
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
	and %111111
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
	ld a, [hli]
	and %11000000
	srl a
	ld [de], a
	inc de
	dec bc
	xor a
	or b
	or c
	jr nz, .loopAttr
	reset VRAMBankSelect

	ld hl, playerPosX + 1
	ld a, [hld]
	ld a, [hli]
	xor a
	ld [hli], a
	ld b, a
	ld hl, playerPosY + 1
	ld a, [hld]
	ld a, [hli]
	xor a
	ld [hli], a
	ld c, a
	jr calcCamera.calcCamera

calcCamera::
	ld a, [playerPosX]
	ld b, a
	ld a, [playerPosY]
	ld c, a

.calcCamera:
	ld a, $48
	cp b
	jr z, .calcY

	ld [playerPosX], a
	sub b
	cpl
	inc a

	ld d, a
	ld hl, bgScrollX
	ld e, [hl]
	add e
	bit 7, d
	jr z, .checkPositiveX

	cp e
	jr c, .setScrollX
	sub e
	ld hl, playerPosX
	add [hl]
	ld [hl], a

	xor a
	jr .setScrollX
.checkPositiveX:
	cp $60
	jr c, .setScrollX
	sub $60
	ld hl, playerPosX
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
	ld hl, playerPosY
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
	ld hl, playerPosY
	add [hl]
	ld [hl], a

	xor a
	jr .setScrollY
.checkPositiveY:
	cp $70
	jr c, .setScrollY
	sub $70
	ld hl, playerPosY
	add [hl]
	ld [hl], a
	ld a, $70
	jr .setScrollY

.setScrollY:
	ld hl, bgScrollY
	ld [hl], a
	ret
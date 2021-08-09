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
	jr z, drawMap
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
	ret
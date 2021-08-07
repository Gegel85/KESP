cmdHandlers::
	dw handlerSetFrequency
	dw handlerSetVolume
	dw handlerWait
	dw handlerJump
	dw handlerDisableTerminals
	dw handlerEnableTerminals
	dw handlerSetRegisters
	dw handlerStopMusic
	dw handlerPlay
	dw handlerRepeat
	dw handlerContinue

handlerRepeat:
	pop hl
	ld bc, NB_REPEAT - NB_REGISTERS
	add hl, bc
	ld a, [de]
	inc de
	ld [hli], a
	ld a, e
	ld [hli], a
	ld [hl], d
	xor a
	ret

handlerContinue:
	pop hl
	ld bc, NB_REPEAT - NB_REGISTERS
	add hl, bc
	xor a
	or [hl]
	ret z
	dec [hl]
	inc hl
	ld a, [hli]
	ld e, a
	ld d, [hl]
	xor a
	ret

handlerPlay:
	pop hl
	ld bc, CTRL_BYTE - NB_REGISTERS
	add hl, bc
	ld a, [hl]

	ld bc, FREQUENCY_PTR
	add hl, bc
	ld c, a

	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl

	ld a, [de]
	bit 1, c
	jr nz, .notMuted
	xor a
.notMuted:
	writeRegister a
	inc de
	xor a
	ret

handlerSetFrequency:
	pop hl
	ld bc, CTRL_BYTE - NB_REGISTERS
	add hl, bc
	ld a, [hl]

	ld bc, FREQUENCY_PTR
	add hl, bc
	ld c, a

	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld a, [de]
	inc de
	writeRegisterI a

	ld a, [de]
	inc de
	bit 1, c
	jr nz, .notMuted
	xor a
.notMuted:
	writeRegister a
	xor a
	ret

handlerSetVolume:
	pop hl
	ld bc, FREQUENCY_PTR - NB_REGISTERS
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	dec hl
	ld a, [de]
	inc de
	writeRegister a
	xor a
	ret

handlerSetRegisters:
	pop hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
.loop:
	ld a, [de]
	inc de
	writeRegisterI a
	dec c
	jr nz, .loop
	xor a
	ret

handlerDisableTerminals:
	pop hl
	push hl
	ld bc, CTRL_BYTE - NB_REGISTERS
	add hl, bc

	ld a, [de]
	ld b, a
	inc de

	ld hl, Channel1Mirror | ($FF & terminalSelect)
	and [hl]
	ld [hl], a

	pop hl
	bit 1, [hl]
	ret z

	ld a, b
	ld hl, terminalSelect
	and [hl]
	ld [hl], a
	xor a
	ret

handlerEnableTerminals:
	pop hl
	push hl
	ld bc, CTRL_BYTE - NB_REGISTERS
	add hl, bc

	ld a, [de]
	ld b, a
	inc de

	ld hl, Channel1Mirror | ($FF & terminalSelect)
	or [hl]
	ld [hl], a

	pop hl
	bit 1, [hl]
	ret z

	ld a, b
	ld hl, terminalSelect
	or [hl]
	ld [hl], a
	xor a
	ret

handlerWait:
	pop hl
	ld bc, WAITING_TIME - NB_REGISTERS
	add hl, bc

	ld a, [de]
	inc de
	ld [hli], a

	ld a, [de]
	inc de
	ld [hl], a

	or 1
	ret

handlerJump:
	pop hl
	ld a, [de]
	inc de
	ld b, a
	ld a, [de]
	ld d, a
	ld e, b
	xor a
	ret

handlerStopMusic:
	pop hl
	ld bc, CTRL_BYTE - NB_REGISTERS
	add hl, bc
	res 0, [hl]
	inc hl
	or 1
	ret

executeMusicCommand::
	push hl
	ld a, [de]
	inc de
	sla a
	ld hl, cmdHandlers
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

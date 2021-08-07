include "src/sound/constants.asm"
include "src/sound/commands.asm"

registersProperties::
	db $5
	dw $FF10
	dw $FF13

	db $4
	dw $FF16
	dw $FF18

	db $5
	dw $FF1A
	dw $FF1D

	db $4
	dw $FF20
	dw $FF22

startMusic::
	push hl
	; Setup sound
	ld a, $FF
	ld hl, channelCtrl
	writeRegisterI a
	writeRegisterI a
	writeRegisterI a
	pop hl

.noSetupSound::
	reset nbRepeated

	push de
	; Setup timer
	ld de, timerModulo
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	pop de

	ld bc, registersProperties
	push bc

	ld b, 4
.loop:
	; CTRL_BYTE
	ld a, %11
	ld [de], a
	inc de

	; WAITING_TIME
	xor a
	ld [de], a
	inc de
	ld [de], a
	inc de

	; CURRENT_ELEM_PTR
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de

	; NB_REGISTERS
	push hl
	ld hl, sp + 2
	ld a, [hli]
	ld h, [hl]
	ld l, a

	ld c, 5
.regFillLoop:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .regFillLoop

	ld c, h
	ld a, l
	ld hl, sp + 2
	ld [hli], a
	ld [hl], c
	pop hl

	; REPEAT_PTR
	inc de
	inc de

	; NB_REPEAT
	xor a
	ld [de], a
	inc de

	dec b
	jr nz, .loop
	pop bc
	ret


updateMusics::
	push hl
	inc hl
	inc hl
	inc hl
	xor a
	ld a, [hli]
	or [hl]
	pop hl
	ret z
	push hl
	call .update
	pop hl
	push hl

	ld de, MUSIC_STRUCT_SIZE
	ld b, 4
.checkLoop:
	bit 0, [hl]
	jr nz, .done
	add hl, de
	dec b
	jr nz, .checkLoop
	pop hl

	ld b, 4
	ld de, MUSIC_STRUCT_SIZE - 2
	push hl
.reactivateLoop:
	set 0, [hl]
	inc hl
	xor a
	ld [hli], a
	ld [hl], a

	add hl, de
	dec b
	jr nz, .reactivateLoop
	ld hl, nbRepeated
	inc [hl]
	pop hl
	jr .update
.done:
	pop hl
	ret

.update:
	call updateMusic
	call updateMusic
	call updateMusic

updateMusic::
	push hl
	bit 0, [hl]
	jr z, .end

	xor a
	inc hl
	or [hl]
	inc hl
	or [hl]
	inc hl
	jr nz, .end

	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl

.loop:
	pop hl
	push hl
	call executeMusicCommand
	jr z, .loop

	pop hl
	dec hl
	dec hl
	ld a, e
	ld [hli], a
	ld [hl], d

.end:
	pop hl
	inc hl
	dec [hl]
	jr nz, .noOverFlow
	inc hl
	dec [hl]
	dec hl
.noOverFlow:
	ld de, MUSIC_STRUCT_SIZE - 1
	add hl, de
	ret
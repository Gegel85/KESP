include "src/sound/constants.asm"
include "src/sound/commands.asm"

; Description of each channel
registersProperties::
	; Number of registers
	db $5
	; First register
	dw $FF10
	; Frequency set register
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

; Starts a music track
; Params:
;    hl -> Pointer to the music track header
;    de -> Pointer to the playing music struct
; Return:
;    N/A
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preverved
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

	; In the loop below, we are missing registers!
	; Instead, we store it on the stack.
	ld bc, registersProperties
	push bc

	ld b, 4
	; Initiliaze tracks for each channel
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

	push hl
	; We get the registersProperties var we stocked on the stack before the loop
	ld hl, sp + 2
	ld a, [hli]
	ld h, [hl]
	ld l, a

	; Copy 5 bytes from the registersProperties array into the struct for NB_REGISTERS, REGISTERS_PTR and FREQUENCY_PTR...
	ld c, 5
.regFillLoop:
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .regFillLoop

	; ...and save the pointer to the next element in the array back on the stack
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


; Updates a playing music struct
; Params:
;    hl -> Pointer to the playing music struct
; Return:
;    N/A
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preverved
updateMusics::
	; First, we check if the CURRENT_ELEM_PTR of the first track is NULL.
	; If so, bail out.
	push hl
	inc hl
	inc hl
	inc hl
	xor a
	ld a, [hli]
	or [hl]
	pop hl
	ret z

	; Update all the tracks once
	push hl
	call .update
	pop hl
	push hl

	; We check if all channels are disabled
	; If any channel is still playing, let's go to .done
	ld de, MUSIC_STRUCT_SIZE
	ld b, 4
.checkLoop:
	bit 0, [hl]
	jr nz, .done
	add hl, de
	dec b
	jr nz, .checkLoop
	pop hl

	; If all channels are disabled, we enable them back
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
	; Finally, we increment the number of time we repeated
	ld hl, nbRepeated
	inc [hl]
	pop hl
	jr .update
.done:
	pop hl
	ret

.update:
	; Here, we abuse the fact that updateMusic returns the next track pointer in hl
	; and call it 4 times by setting the return address back to it
	ld de, updateMusic
	push de
	push de
	push de
	; Fall through to the actual function


; Updates a music track
; Params:
;    hl -> Pointer to the music struct
; Return:
;    hl -> Pointer to the next music struct in the array
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
updateMusic::
	; Check if the channel is disabled. If so, go to the end.
	push hl
	bit 0, [hl]
	jr z, .end

	; Check if the wait timer is 0. If not, go to the end.
	xor a
	inc hl
	or [hl]
	inc hl
	or [hl]
	inc hl
	jr nz, .end

	; Store CURRENT_ELEM_PTR in de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl

	; Execute the music instructions until it should stop
.loop:
	pop hl
	push hl
	call executeMusicCommand
	jr z, .loop

	; Update the CURRENT_ELEM_PTR
	pop hl
	dec hl
	dec hl
	ld a, e
	ld [hli], a
	ld [hl], d

.end:
	; Finally, lower the WAITING_TIME by one
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
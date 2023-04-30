; Updates a music track
; Params:
;    N/A
; Return:
;    N/A
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
updateSfx::
	ld bc, $0411
	ld de, $0000
	; Loop over all 4 sfx timers
	ld hl, playingSfxTimers
.loop:
	; If the timer is already 0, skip it
	xor a
	or [hl]
	jr z, .skip

	; Decrement the timer and if it is still not zero, skip it
	dec [hl]
	jr nz, .skip

	; We unmute the channel if the sfx just stopped playing
	push hl
	ld hl, playingMusics
	add hl, de
	set 1, [hl]
	; We also restore the terminalSelect register.
	; First, we check if the terminal should stay on (because we always put it on to play the SFX).
	; If so, we leave it on, otherwise, we disable it again.
	; The C code for this would be
	; if (c & *terminalSelectMirror)
	;     *terminalSelect = *terminalSelect | c;
	; else
	;     *terminalSelect = *terminalSelect & ~c;
	ld a, [Channel1Mirror | ($FF & terminalSelect)]
	and c
	ld a, [terminalSelect]
	jr z, .resetRegister
	or c
	jr .applyRegister
.resetRegister:
	ld d, a
	ld a, c
	cpl
	and d
	ld d, 0
.applyRegister:
	ld [terminalSelect], a
	pop hl
.skip:
	; We store the offset to the next music struct in de
	ld a, e
	add MUSIC_STRUCT_SIZE
	ld e, a

	; Select the next
	inc hl
	sla c
	dec b
	jr nz, .loop
	ret

; Plays a sound effect
; Params:
;    hl -> Pointer to the SFX struct
;       Channel (0-3) 1B
;       Sound duration in frames 1B
;       Sound data copied in channel registers 4B/5B
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
playSfx::
	di
	ld a, [hli]
	; Store the channel number in c
	ld c, a
	; x5
	sla a
	sla a
	add c
	ld e, a

	; Load the duration in the proper timer
	ld a, [hli]
	push hl
	push de
	ld b, 0
	ld hl, playingSfxTimers
	add hl, bc
	ld [hl], a

	; We select the proper music struct and adjust the mask in b
	ld b, %00010001
	ld de, MUSIC_STRUCT_SIZE
	ld hl, playingMusics
	ld a, c
.addLoop:
	or a
	jr z, .endLoop
	sla b
	add hl, de
	dec a
	jr .addLoop
.endLoop:
	; We set this track as muted
	res 1, [hl]

	; We force this channel to be on
	ld a, b
	ld hl, terminalSelect
	or [hl]
	ld [hl], a

	; Select the proper offset in the registersProperties array
	pop de
	ld d, 0
	ld hl, registersProperties
	add hl, de
	ld d, h
	ld e, l
	pop hl

	; In b, the number of registers
	ld a, [de]
	inc de
	ld b, a

	; We store the first address of the register in de...
	ld a, [de]
	inc de
	ld c, a
	ld a, [de]
	ld d, a
	ld e, c

	; ...and copy the data from the sfx struct in the APU registers
.regInitLoop:
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .regInitLoop
	ei
	ret
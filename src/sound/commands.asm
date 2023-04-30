; Function for each opcode
; Unimplemented opcodes will use the handler's code as code pointers and will probably crash
; Each handlers' signature is as follows
; Params:
;   [sp]-> Pointer to the owning music struct's NB_REGISTERS field
;    de -> Pointer to the current instruction's arguments
; Return:
;    de -> Pointer to the next music instruction
;    flag z -> If set, the next instruction should also be executed
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    hl -> Not preserved
; Note: Since an argument is given on the stack, it should always be popped before returning
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


handlerSetFrequency:
	pop hl
	; Load the control byte
	ld bc, CTRL_BYTE - NB_REGISTERS
	add hl, bc
	ld a, [hl]

	; Adjust hl to the FREQUENCY_PTR
	ld bc, FREQUENCY_PTR
	add hl, bc
	; Save the control byte in c
	ld c, a

	; Load the FREQUENCY_PTR to hl
	ld a, [hli]
	ld h, [hl]
	ld l, a

	; Load the first byte and commit it in the APU register
	ld a, [de]
	inc de
	writeRegisterI a

	; Load the second byte and, if not muted, commit it in the APU register
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
	; Adjust hl to the FREQUENCY_PTR
	ld bc, FREQUENCY_PTR - NB_REGISTERS
	add hl, bc
	; Load the FREQUENCY_PTR to hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	; Write to the volume register (hl - 1) the argument
	dec hl
	ld a, [de]
	inc de
	writeRegister a
	xor a
	ret

handlerWait:
	pop hl
	; Adjust hl to the WAITING_TIME
	ld bc, WAITING_TIME - NB_REGISTERS
	add hl, bc

	; Load the 16 bits arguments into the WAITING_TIME
	ld a, [de]
	inc de
	ld [hli], a
	ld a, [de]
	inc de
	ld [hl], a

	; We unset flag Z to stop the loop
	or 1
	ret

handlerJump:
	pop hl
	; We load the argument into de
	ld a, [de]
	inc de
	ld b, a
	ld a, [de]
	ld d, a
	ld e, b
	xor a
	ret

handlerDisableTerminals:
	; We adjust hl to the CTRL_BYTE and push it onto the stack
	pop hl
	ld bc, CTRL_BYTE - NB_REGISTERS
	add hl, bc
	push hl

	; Load the argument into b
	ld a, [de]
	ld b, a
	inc de

	; And the mask with the saved channel values
	ld hl, Channel1Mirror | ($FF & terminalSelect)
	and [hl]
	ld [hl], a

	; We stop here if the channel is muted
	pop hl
	bit 1, [hl]
	ret z

	; Do the same change in the actual register
	ld a, b
	ld hl, terminalSelect
	and [hl]
	ld [hl], a
	xor a
	ret

handlerEnableTerminals:
	pop hl
	; We adjust hl to the CTRL_BYTE and push it onto the stack
	ld bc, CTRL_BYTE - NB_REGISTERS
	add hl, bc
	push hl

	; Load the argument into b
	ld a, [de]
	ld b, a
	inc de

	; Or the mask with the saved channel values
	ld hl, Channel1Mirror | ($FF & terminalSelect)
	or [hl]
	ld [hl], a

	; We stop here if the channel is muted
	pop hl
	bit 1, [hl]
	ret z

	; Do the same change in the actual register
	ld a, b
	ld hl, terminalSelect
	or [hl]
	ld [hl], a
	xor a
	ret

handlerSetRegisters:
	pop hl
	; Load NB_REGISTERS into c
	ld a, [hli]
	ld c, a
	; Load REGISTERS_PTR into c
	ld a, [hli]
	ld h, [hl]
	ld l, a
	; We load all the values
.loop:
	ld a, [de]
	inc de
	writeRegisterI a
	dec c
	jr nz, .loop
	xor a
	ret

handlerStopMusic:
	pop hl
	; Reset bit 0 to disable the channel
	ld bc, CTRL_BYTE - NB_REGISTERS
	add hl, bc
	res 0, [hl]
	inc hl
	or 1
	ret

handlerPlay:
	pop hl
	; Load the control byte
	ld bc, CTRL_BYTE - NB_REGISTERS
	add hl, bc
	ld a, [hl]

	; Adjust hl to the FREQUENCY_PTR
	ld bc, FREQUENCY_PTR
	add hl, bc
	; Save the control byte in c
	ld c, a

	; Load the FREQUENCY_PTR to hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl

	; Load the argument and, if not muted, commit it in the APU register
	ld a, [de]
	bit 1, c
	jr nz, .notMuted
	xor a
.notMuted:
	writeRegister a
	inc de
	xor a
	ret

handlerRepeat:
	pop hl
	; We adjust hl to the NB_REPEAT
	ld bc, NB_REPEAT - NB_REGISTERS
	add hl, bc
	ld a, [de]
	inc de
	; We write the first argument there
	ld [hli], a
	ld a, e
	; Store the next instruction's address at REPEAT_PTR
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
	; If NB_REPEAT is zero, we fall through
	ret z
	; Otherwise, we decrement it...
	dec [hl]
	inc hl
	; ...and jump to REPEAT_PTR
	ld a, [hli]
	ld e, a
	ld d, [hl]
	xor a
	ret

; Executes a single music instruction
; Params:
;    hl -> Pointer to the owning music struct's NB_REGISTERS field
;    de -> Pointer to the current music instruction
; Return:
;    de -> Pointer to the next music instruction
;    flag z -> If set, the next instruction should also be executed
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    hl -> Not preserved
executeMusicCommand::
	push hl
	; Read the current opcode to execute
	ld a, [de]
	inc de ; Increment de to this opcode's args
	; We handle the EXEC opcode here directly
	cp EXEC
	jr nz, .selectHandler
	ld h, d
	ld l, e
	inc de
	inc de
	jr .jmpTo
.selectHandler:
	sla a
	; Load the corresponding code pointer
	ld hl, cmdHandlers
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a
.jmpTo:
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

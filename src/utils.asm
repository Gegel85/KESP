; Uncompress compressed data
; Params:
;    a  -> Compression mode
;    hl -> Pointer to the compressed data
;    de -> Destination address
;    bc -> Data size
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
uncompress::
	push af
	push de
	ld d, h
	ld e, l
	pop hl
	push hl
	; Jump to the case based on a
	ld hl, .case0
	; Multiply a by 8 (because each case is 8 bytes long)
	rla
	rla
	rla
	; Add base offset of case0
	add a, l
	ld l, a
	ld a, h
	adc $00
	ld h, a
	jp hl

	; Each case is 8 bytes long
.case0:
	; Mode 0: Duplicate the byte.
	;         Pixel is either 3 or 0.
	pop hl
	ld a, [de]
	ld [hli], a
	ld [hli], a
	jr .endCase
	nop
	nop
.case1:
	; Mode 1: First byte is 0, second the byte inverted.
	;         Pixel is either 2 or 0.
	pop hl
	xor a
	ld [hli], a
	ld a, [de]
	cpl
	ld [hli], a
	jr .endCase
.case2:
	; Mode 2: Duplicate the byte inverted.
	;         Pixel is either 3 or 0.
	pop hl
	ld a, [de]
	cpl
	ld [hli], a
	ld [hli], a
	nop
	jr .endCase
.case3:
	; Mode 3: First byte is FF, second the byte the data.
	;         Pixel is either 3 or 1.
	pop hl
	ld a, $FF
	ld [hli], a
	ld a, [de]
	ld [hli], a
	jr .endCase
.endCase:

	inc de
	dec bc
	ld a, b
	or c
	push hl
	ld h, d
	ld l, e
	pop de
	jr nz, .continue
	pop af
	ret
.continue:
	pop af
	jr uncompress

; Generates a pseudo random number.
; Params:
;    None
; Return:
;    a -> The number generated
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
random::
	push hl

	ld a, [randomRegister]
	ld hl, divReg
	add a, [hl]
	ld [randomRegister], a

	pop hl
	ret

; Copies a chunk of memory into another
; Params:
;    bc -> The length of the chunk to copy
;    de -> The destination address
;    hl -> The source address
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
copyMemory::
	; Check if size is 0
	ld a, b
	or c
	ret z

	; Copy a byte of memory from hl to de
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	jr copyMemory ; Recurse until bc is 0

; Copies a chunk of memory and stream it into another
; Params:
;    bc -> The length of the chunk to copy
;    de -> The destination address
;    hl -> The source address
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
streamMemory::
	; Check if size is 0
	ld a, b
	or c
	ret z

	; Copy a byte of memory from hl to de
	ld a, [hli]
	ld [de], a
	dec bc
	jr streamMemory ; Recurse until bc is 0

; Fill a chunk of memory with a single value
; Params:
;    a  -> Value to fill
;    bc -> The length of the chunk to fill
;    de -> The destination address
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Preserved
fillMemory::
	push af ; Save a
	; Check if bc is 0
	ld a, b
	or c
	jr z, .return
	pop af

	; Load a into de
	ld [de], a
	inc de
	dec bc
	jr fillMemory ; Recurse intil bc is 0
.return: ; End of recursion
	pop af
	ret

; Wait for VBLANK. Only returns when a VBLANK occurs.
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
waitVBLANKInt::
	ld a, [lcdCtrl] ; Check if LCD is disabled
	bit 7, a
	ret z

	ld a, [interruptEnable] ; Save old interrupt enabled
	push af
	ld a, [interruptFlag] ; Save old interrupt flag
	push af
	reg interruptEnable, VBLANK_INTERRUPT; Enable only VBLANK interrupt
	reset interruptFlag; Clear old requests
.loop:
	halt   ; Wait for interrupt
	pop af ; Restore old interrupt flag
	ld [interruptFlag], a
	pop af ; Restore old interrupt enabled
	ld [interruptEnable], a
	ret

; Wait for VBLANK by checking the current line. Only returns when a VBLANK occurs.
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
waitVBLANKLine::
	ld hl, lcdLine
	ld a, $90 - 1
.halt::
	halt
	cp [hl]
	ret c
	jr .halt

; Wait for VBLANK. Only returns when a VBLANK occurs but don't execute the VBLANK interrupt handler.
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
waitVBLANKDi::
	ld a, [lcdCtrl] ; Check if LCD is disabled
	bit 7, a
	ret z

	di
	ld a, [interruptEnable] ; Save old interrupt enabled
	push af
	ld a, [interruptFlag] ; Save old interrupt flag
	push af
	reg interruptEnable, VBLANK_INTERRUPT; Enable only VBLANK interrupt
	reset interruptFlag; Clear old requests
.loop:
	halt   ; Wait for interrupt
	pop af ; Restore old interrupt flag
	ld [interruptFlag], a
	pop af ; Restore old interrupt enabled
	ld [interruptEnable], a
	ei
	ret

; Wait for VBLANK. Only returns when a VBLANK occurs.
; Params:
;    a -> The number of frames to wait for.
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Not preserved
waitFrames::
	ld hl, frameCounter
	ld [hl], a
	reg interruptEnable, VBLANK_INTERRUPT
	xor a
.loop:
	or [hl]
	ret z
	reset interruptFlag
	halt
	jr .loop

; Get all the pressed keys.
; Params:
;    None
; Return:
;    (Pressed when bit is 0)
;    a -> All the pressed keys
;       bit 0 -> Right
;       bit 1 -> Left
;       bit 2 -> Up
;       bit 3 -> Down
;       bit 4 -> A
;       bit 5 -> B
;       bit 6 -> Select
;       bit 7 -> Start
; Registers:
;    af -> Not preserved
;    b  -> Not preserved
;    c  -> Preserved
;    de -> Preserved
;    hl -> Not preserved
getKeys::
	ld hl, $FF00
	ld a, [hl]
	and a, $F
	ld b, a
	swap b

	ld [hl], %00100000
	ld a, [hl]
	; Delay
	ld a, [hl]
	ld a, [hl]
	ld a, [hl]
	ld a, [hl]
	and a, $F
	or b
	ld [hl], %00010000
	ret

; Get all the pressed keys but disabled ones.
; Disables all the currently pressed keys.
; Params:
;    None
; Return:
;    (Pressed when bit is 0)
;    a -> All the pressed keys
;       bit 0 -> Right
;       bit 1 -> Left
;       bit 2 -> Up
;       bit 3 -> Down
;       bit 4 -> A
;       bit 5 -> B
;       bit 6 -> Select
;       bit 7 -> Start
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Preserved
;    hl -> Not preserved
getKeysFiltered::
	call getKeys
	ld b, a
	ld hl, keysDisabled
	ld a, [hl]
	or b
	ld c, a
	ld a, b
	cpl
	ld [hl], a
	ld a, c
	ret

; Divides a number by another (c / d and c % d)
; Params:
;       c -> Dividend
;	d -> Divider
; Return:
;	e -> Modulo
;       b -> Quotient
; Registers:
;	af -> Not preserved
;	d  -> Preserved
;	c  -> Not preserved
;	hl -> Preserved
; The algorithm is as follows:
;   unsigned short divide(unsigned char dividend, unsigned char divider) {
;       unsigned char quotient = 0;
;       unsigned char modulo = 0;
;
;       for (char counter = 8; counter > 0; counter--) {
;            modulo = (modulo << 1) | (dividend >> 7);
;            dividend = (dividend << 1) | (quotient >> 7);
;            quotient = (quotient << 1) & 0xFF;
;            if (modulo > divider) {
;                 quotient++;
;                 modulo -= divider;
;            }
;       }
;       return {quotient, modulo};
;   }
divide::
	ld b, 0
	ld e, b
	ld a, 8
.loop::
	push af
	sla b
	rl c
	rl e
	ld a, e
	cp d
	jr c, .noInc

	inc b
	sub d
	ld e, a

.noInc::
	pop af
	dec a
	jr nz, .loop
	ret


; Multiplies 2 numbers
; Params:
;       c -> Number 1
;	b -> Number 2
; Return:
;	de -> result
; Registers:
;	af -> Not preserved
;	bc -> Not preserved
;	hl -> Preserved
; The algorithm is as follows:
;   unsigned short .multiplyRecurse(unsigned char c, unsigned char b) {
;       if (c == 0)
;           return 0;
;
;       unsigned short result = .multiplyRecurse(c >> 1, b) << 1;
;
;       if (c & 1)
;           return result + b;
;       return result;
;   }
;
;   unsigned short multiply(unsigned char c, unsigned char b) {
;       if (b == 0)
;           return 0;
;       return .multiplyRecurse(c, b);
;   }
multiply::
	xor a
	or b
	jr z, .zero
.multiplyRecurse::
	xor a
	or c
	jr z, .zero

	xor a
	srl c
	sbc a
	and b
	push af
	call .multiplyRecurse
	xor a
	rl e
	rl d
	pop af
	add e
	ld e, a
	ld a, d
	adc 0
	ld d, a
	ret
.zero::
	ld d, a
	ld e, a
	ret

; Uncompress the ROM font into VRAM using compression mode 3
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
;    ROM bank -> Not preserved (BANK(font))
loadFont::
	reg ROMBankSelect, BANK(font)
	ld de, VRAMStart + "A" * $10 + $1000
	ld hl, font
	ld bc, 8 * 26
	ld a, 3
	call uncompress

	ld de, VRAMStart + "." * $10 + $1000
	ld bc, 8 * 12
	call uncompress

	ld de, VRAMStart + "a" * $10 + $1000
	ld bc, 8 * 30
	jp uncompress
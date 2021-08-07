; VBLANK interrupt handler
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
vblank_interrupt::
	push af
	push hl
	push de
	push bc
	ld a, oamSrc >> 8
	call DMA
	call updateSfx
	pop bc
	pop de
	pop hl
	pop af
	reti

; HBLANK interrupt handler
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
hblank_interrupt::
	reti

; Timer interrupt handler
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
timer_interrupt::
	push af
	push bc
	push de
	push hl
	ld hl, playingMusics
	call updateMusics
	pop hl
	pop de
	pop bc
	pop af
	reti

; Serial interrupt handler
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
serial_interrupt::
	reti

; Joypad interrupt handler
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
joypad_interrupt::
	reti

DMACode::
LOAD "DMA", HRAM
DMA::
        ld [dmaTrnCtrl], a
        ld a, DMA_DELAY
.wait:
        dec a
        jr nz, .wait
        ret
ENDL
DMACodeEnd::

WPRAM_init::
	db $00, $0C, $19, $26, $33, $3F, $4C, $59
	db $66, $72, $7F, $8C, $99, $A5, $B2, $BF

; Enable interrupts and init RAM
; Params:
;    None
; Return:
;    None
; Registers:
;    af -> Preserved
;    bc -> Not preserved
;    de -> Not preserved
;    hl -> Not preserved
init::
	reg interruptEnable, VBLANK_INTERRUPT | TIMER_INTERRUPT | STAT_INTERRUPT

	call waitVBLANKInt
	reset lcdCtrl

	xor a
	ld bc, $6000
	ld de, VRAMStart
	call fillMemory

	ld b, $10
	ld hl, $FF30
.loop::
	call random
	ld [hli], a
	dec b
	jr nz, .loop

	ld bc, $10
	ld hl, WPRAM_init
	ld de, $FF30
	call copyMemory

        ld de, $FF80
        ld hl, DMACode
	ld bc, DMACodeEnd - DMACode
        call copyMemory

	pop de
	ld sp, stackBottom
	push de

	ei
	ret
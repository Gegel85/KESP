include "src/registers.asm"

SECTION "crash", ROM0
	jp crash

SECTION "vblank", ROM0
	jp vblank_interrupt

SECTION "hblank", ROM0
	jp hblank_interrupt

SECTION "timer", ROM0
	jp timer_interrupt

SECTION "serial", ROM0
	jp serial_interrupt

SECTION "joypad", ROM0
	jp joypad_interrupt

crash::
	di
	ld b, b
	ld hl, lcdLine
.loop:
	ld a, $90
	cp [hl]
	jr nc, .loop

	xor a
	dec l
	ld [hld], a
	ld [hld], a
	dec l
	ld [hl], a

	ld hl, crashText
	ld c, 16
	xor a
	ld [VRAMBankSelect], a
	ld de, $9800
.copyLoop:
	ld a, [hli]
	ld [de], a
	inc e
	dec c
	jr nz, .copyLoop

	ld a, 1
	ld [VRAMBankSelect], a
	ld c, 16
	xor a
	ld hl, $9800
.copyLoop2:
	ld [hli], a
	dec c
	jr nz, .copyLoop2
	ld a, %10010001
	ld [lcdCtrl], a
	jp lockup

SECTION "Start", ROM0
	nop
	jp main

SECTION "Header", ROM0
	ds $150 - $104

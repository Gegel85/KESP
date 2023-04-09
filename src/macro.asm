; Like doing ld [**], *
; VBLANK interrupt handler
; Params:
;    \1 -> Address to write to
;    \2 -> Value to write
; Return:
;    None
; Registers:
;    af -> Not preserved
;    bc -> Preserved
;    de -> Preserved
;    hl -> Preserved
MACRO reg
	ld a, \2
	ld [\1], a
ENDM

MACRO toggleCpuSpeed
	reg speedSwitch, 1
	stop
ENDM

MACRO neg
	cpl
	inc a
ENDM

MACRO setCpuDoubleSpeed
	ld hl, speedSwitch
	bit 7, [hl]
	jr nz, .skip\@
	set 0, [hl]
	stop
.skip\@:
ENDM

MACRO setCpuSimpleSpeed
	ld hl, speedSwitch
	bit 7, [hl]
	jr z, .skip\@
	set 0, [hl]
	stop
.skip\@:
ENDM

MACRO startGPDMA
	ld hl, newDmaSrcH
	ld [hl], (\1) >> 8
	inc l
	ld [hl], (\1) & $FF
	inc l
	ld [hl], (\2) >> 8
	inc l
	ld [hl], (\2) & $FF
	inc l
	ld [hl], (\3) / $10 - 1
ENDM

MACRO startHDMA
	ld hl, newDmaSrcH
	ld [hl], (\1) >> 8
	inc l
	ld [hl], (\1) & $FF
	inc l
	ld [hl], (\2) >> 8
	inc l
	ld [hl], (\2) & $FF
	inc l
	ld [hl], (1 << 7) | ((\3) / $10 - 1)
ENDM

MACRO reset
	xor a
	ld [\1], a
ENDM
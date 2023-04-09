; Music struct
RSRESET
; Control byte
CTRL_BYTE	  RB 1 ; Bit 0: Active (0: Off 1: On)
                       ; Bit 1: Muted  (0: Off 1: On)
; Number of ticks to wait before executing next instruction
WAITING_TIME      RW 1
; Pointer to the next instruction to execute
CURRENT_ELEM_PTR  RW 1
; Number of registers in this audio channel
NB_REGISTERS      RB 1
; Pointer to the first register of this audio channel
REGISTERS_PTR     RW 1
; Pointer to the frequency register of this audio channel
FREQUENCY_PTR     RW 1
; Number of loops remaining
NB_REPEAT	  RB 1
; Pointer to the instruction to loop to
REPEAT_PTR        RW 1
; Size of this struct (Not part of the struct itself)
MUSIC_STRUCT_SIZE RB 1

; Music
SEMIQUAVER        EQU $3
QUAVER	          EQU 2 * SEMIQUAVER
DOTTED_QUAVER     EQU QUAVER + SEMIQUAVER
CROTCHET	  EQU 2 * QUAVER
DOTTED_CROTCHET   EQU 2 * DOTTED_QUAVER
MINIM	          EQU 2 * CROTCHET
DOTTED_MINIM      EQU 2 * DOTTED_CROTCHET
SEMIBREVE	  EQU 2 * MINIM
DOTTED_SEMIBREVE  EQU 2 * DOTTED_MINIM

QUAVER3           EQU CROTCHET / 3
SEMIQUAVER3       EQU QUAVER3 / 2

; Notes
NOTE_Cb      EQU 247
NOTE_C       EQU 262
NOTE_C_SHARP EQU 277
NOTE_Db      EQU 277
NOTE_D       EQU 294
NOTE_D_SHARP EQU 311
NOTE_Eb      EQU 311
NOTE_E       EQU 330
NOTE_Fb      EQU 330
NOTE_E_SHARP EQU 349
NOTE_F       EQU 349
NOTE_F_SHARP EQU 370
NOTE_Gb      EQU 370
NOTE_G       EQU 392
NOTE_G_SHARP EQU 415
NOTE_Ab      EQU 415
NOTE_A       EQU 440
NOTE_A_SHARP EQU 466
NOTE_Bb      EQU 466
NOTE_B       EQU 494
NOTE_B_SHARP EQU 524

; Music no sound masks
TERMINAL_ONE    EQU %00010001
TERMINAL_TWO    EQU %00100010
TERMINAL_THREE  EQU %01000100
TERMINAL_FOUR   EQU %10001000

; Music track header
RSRESET
TIMER_MODULO  RB 1
TIMER_CONTROL RB 1
NB_PROGRAMS   RB 1
PROGRAMS_PTRS RW 4

; Music instructions opcodes
RSRESET
SET_FREQU     RB 1
SET_VOL       RB 1
WAIT	      RB 1
JUMP	      RB 1
DIS_TERM      RB 1
ENA_TERM      RB 1
SET_REGISTERS RB 1
STOP_MUS      RB 1
PLAY	      RB 1
REPEAT        RB 1
CONTINUE      RB 1

MACRO continue
	db CONTINUE
ENDM

MACRO repeat
	db REPEAT
	db \1 - 1
ENDM

MACRO play
	db PLAY
	db ((2048 - 131072 / (\1)) >> 8) | (\2)
ENDM

MACRO playRaw
	db PLAY
	db \1
ENDM

MACRO setFrequency ; setFrequency(byte frequency)
	ASSERT (2048 - 131072 / (\1)) > 0
	db SET_FREQU
	dw (2048 - 131072 / (\1)) | ((\2)) << 8
ENDM

MACRO setFrequencyRaw ; setFrequency(byte frequency)
	db SET_FREQU
	dw (\1) | ((\2)) << 8
ENDM

MACRO setVolume ; setVolume(byte volume)
	db SET_VOL
	db \1
ENDM

MACRO setRegisters ; setRegisters(byte values[nbRegisters])
	db SET_REGISTERS
	IF _NARG == 4
        	db \1, \2, \3, \4
	ELIF _NARG == 5
        	db \1, \2, \3, \4, \5
	ELSE
		PRINTT "setRegister should take either 4 or 5 arguments but "
		PRINTI _NARG
		PRINTT " were given."
		FAIL
        ENDC
ENDM

MACRO disableTerminals ; disableTerminals(byte terminalsMask)
	db DIS_TERM
	db ~(\1)
ENDM

MACRO enableTerminals ; enableTerminals(byte terminalsMask)
	db ENA_TERM
	db \1
ENDM

MACRO wait ; wait(unsigned short units)
	db WAIT
	dw ((\1) + $100)
ENDM

MACRO jump ; jump(unsigned addr)
	db JUMP
	dw \1
ENDM

MACRO stopMusic ; stopMusic()
	db STOP_MUS
ENDM

MACRO writeRegisterI
	push hl
	ld h, Channel1Mirror >> 8
	ld [hl], \1
	pop hl
	ldi [hl], \1
ENDM

MACRO writeRegister
	push hl
	ld h, Channel1Mirror >> 8
	ld [hl], \1
	pop hl
	ld [hl], \1
ENDM
; Music struct
RSRESET
CTRL_BYTE	  RB 1 ; Bit 0: Active (0: Off 1: On)
		       ; Bit 1: Muted  (0: Off 1: On)
WAITING_TIME      RW 1
CURRENT_ELEM_PTR  RW 1
NB_REGISTERS      RB 1
REGISTERS_PTR     RW 1
FREQUENCY_PTR     RW 1
NB_REPEAT	  RB 1
REPEAT_PTR        RW 1
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

; Music No Sound
TERMINAL_ONE    EQU %00010001
TERMINAL_TWO    EQU %00100010
TERMINAL_THREE  EQU %01000100
TERMINAL_FOUR   EQU %10001000

; Music header
RSRESET
TIMER_MODULO  RB 1
TIMER_CONTROL RB 1
NB_PROGRAMS   RB 1
PROGRAMS_PTRS RB 1

; Music commands
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

continue: MACRO
	db CONTINUE
ENDM

repeat: MACRO
	db REPEAT
	db \1 - 1
ENDM

play: MACRO
	db PLAY
	db ((2048 - 131072 / (\1)) >> 8) | (\2)
ENDM

playRaw: MACRO
	db PLAY
	db \1
ENDM

setFrequency: MACRO ; setFrequency(byte frequency)
	ASSERT (2048 - 131072 / (\1)) > 0
	db SET_FREQU
	dw (2048 - 131072 / (\1)) | ((\2)) << 8
ENDM

setFrequencyRaw: MACRO ; setFrequency(byte frequency)
	db SET_FREQU
	dw (\1) | ((\2)) << 8
ENDM

setVolume: MACRO ; setVolume(byte volume)
	db SET_VOL
	db \1
ENDM

setRegisters: MACRO ; setRegisters(byte values[nbRegisters])
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

disableTerminals: MACRO ; disableTerminals(byte terminalsMask)
	db DIS_TERM
	db ~(\1)
ENDM

enableTerminals: MACRO ; enableTerminals(byte terminalsMask)
	db ENA_TERM
	db \1
ENDM

wait: MACRO ; wait(unsigned short units)
	db WAIT
	dw ((\1) + $100)
ENDM

jump: MACRO ; jump(unsigned addr)
	db JUMP
	dw \1
ENDM

stopMusic: MACRO ; stopMusic()
	db STOP_MUS
ENDM

writeRegisterI: MACRO
	push hl
	ld h, Channel1Mirror >> 8
	ld [hl], \1
	pop hl
	ldi [hl], \1
ENDM

writeRegister: MACRO
	push hl
	ld h, Channel1Mirror >> 8
	ld [hl], \1
	pop hl
	ld [hl], \1
ENDM
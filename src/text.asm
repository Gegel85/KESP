SECTION "Text", ROMX[$7EE0], BANK[1]

NEWCHARMAP default
CHARMAP " ", "~"
CHARMAP ":", "\{"
CHARMAP "'", $7F

crashText::
	db "FATAL:PC at 0x38"

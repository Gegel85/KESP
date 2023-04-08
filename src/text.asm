SECTION "Text", ROMX[$7EE0], BANK[1]

NEWCHARMAP default, main
for x, $60
	charmap STRSUB(STRCAT(   \
		" !\"#$%&'()*+,-./", \
		"0123456789:;<=>?",  \
		"@ABCDEFGHIJKLMNO",  \
		"PQRSTUVWXYZ[\\]^_", \
		"`abcdefghijklmno",  \
		"pqrstuvwxyz\{|}~"   \
	), x + 1, 1), x + $20
endr
CHARMAP " ", 126
CHARMAP ":", 123
CHARMAP "'", 127

crashText::
	db "FATAL:PC at 0x38"

musicChan1KoishiTheme::
	setRegisters $00, $46, $F3, $00, $00
.loop::
	repeat 2
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_G, $80
	wait QUAVER
	setFrequency NOTE_E, $80
	wait QUAVER
	setFrequency NOTE_D * 2, $80
	wait DOTTED_QUAVER
	setFrequency NOTE_C * 2, $80
	wait DOTTED_QUAVER
	setFrequency NOTE_D * 2, $80
	wait QUAVER

	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_G, $80
	wait QUAVER
	setFrequency NOTE_E, $80
	wait QUAVER
	setFrequency NOTE_Bb, $80
	wait QUAVER
	setFrequency NOTE_G, $80
	wait QUAVER
	setFrequency NOTE_Eb, $80
	wait QUAVER
	setFrequency NOTE_Bb, $80
	wait QUAVER
	continue

	; change volume
	setFrequency NOTE_G, $80
	wait QUAVER
	setFrequency NOTE_E, $80
	wait QUAVER
	setFrequency NOTE_C, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait DOTTED_QUAVER
	setFrequency NOTE_A, $80
	wait DOTTED_QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER

	setFrequency NOTE_G, $80
	wait QUAVER
	setFrequency NOTE_E, $80
	wait QUAVER
	setFrequency NOTE_C, $80
	wait QUAVER
	setFrequency NOTE_F_SHARP, $80
	wait QUAVER
	setFrequency NOTE_D_SHARP, $80
	wait QUAVER
	setFrequency NOTE_A_SHARP / 2, $80
	wait QUAVER
	setFrequency NOTE_F_SHARP, $80
	wait QUAVER


	setFrequency NOTE_G, $80
	wait QUAVER
	setFrequency NOTE_E, $80
	wait QUAVER
	setFrequency NOTE_C, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait DOTTED_QUAVER
	setFrequency NOTE_A, $80
	wait DOTTED_QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER

	setFrequency NOTE_G, $80
	wait QUAVER
	setFrequency NOTE_E, $80
	wait QUAVER
	setFrequency NOTE_C, $80
	wait QUAVER
	; change volume
	setFrequency NOTE_F_SHARP, $80
	wait QUAVER
	setFrequency NOTE_D_SHARP, $80
	wait QUAVER
	setFrequency NOTE_Bb / 2, $80
	wait QUAVER
	setFrequency NOTE_D_SHARP, $80
	wait QUAVER

	repeat 2
	setFrequency NOTE_E, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_A, $80
	wait QUAVER
	setFrequency NOTE_A, $80
	wait QUAVER
	setFrequency NOTE_D * 2, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait QUAVER
	setFrequency NOTE_A, $80
	wait QUAVER

	setFrequency NOTE_E, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_A, $80
	wait QUAVER
	setFrequency NOTE_G, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_D_SHARP * 2, $80
	wait QUAVER
	setFrequency NOTE_F_SHARP * 2, $80
	wait QUAVER
	continue

	setFrequency NOTE_E, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_A, $80
	wait QUAVER
	setFrequency NOTE_A, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait QUAVER
	setFrequency NOTE_A * 2, $80
	wait QUAVER

	setFrequency NOTE_E * 2, $80
	wait QUAVER
	setFrequency NOTE_G * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER
	setFrequency NOTE_D_SHARP * 2, $80
	wait QUAVER
	setFrequency NOTE_F_SHARP * 2, $80
	wait QUAVER
	setFrequency NOTE_A_SHARP * 2, $80
	wait QUAVER
	setFrequency NOTE_D_SHARP * 4, $80
	wait QUAVER

	setFrequency NOTE_E, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_A, $80
	wait QUAVER
	setFrequency NOTE_A, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait QUAVER
	setFrequency NOTE_A * 2, $80
	wait QUAVER

	setFrequency NOTE_E * 2, $80
	wait QUAVER
	setFrequency NOTE_G * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER
	setFrequency NOTE_D_SHARP * 2, $80
	wait QUAVER
	setFrequency NOTE_F_SHARP * 2, $80
	wait QUAVER
	setFrequency NOTE_A_SHARP * 2, $80
	wait SEMIQUAVER
	setFrequency NOTE_F_SHARP * 2, $80
	wait SEMIQUAVER
	setFrequency NOTE_D_SHARP * 2, $80
	wait QUAVER

	repeat 2
	setFrequency NOTE_E, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_E * 2, $80
	wait CROTCHET
	setFrequency NOTE_F, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait CROTCHET
	continue

	repeat 2
	setFrequency NOTE_F_SHARP, $80
	wait QUAVER
	setFrequency NOTE_C_SHARP * 2, $80
	wait QUAVER
	setFrequency NOTE_F_SHARP * 2, $80
	wait CROTCHET
	setFrequency NOTE_G, $80
	wait QUAVER
	setFrequency NOTE_C_SHARP * 2, $80
	wait QUAVER
	setFrequency NOTE_G * 2, $80
	wait CROTCHET
	continue

	repeat 2
	setFrequency NOTE_E, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_E * 2, $80
	wait CROTCHET
	setFrequency NOTE_F, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait CROTCHET
	continue

	setFrequency NOTE_F_SHARP, $80
	wait QUAVER
	setFrequency NOTE_C_SHARP * 2, $80
	wait QUAVER
	setFrequency NOTE_F_SHARP * 2, $80
	wait CROTCHET
	setFrequency NOTE_G, $80
	wait QUAVER
	setFrequency NOTE_C_SHARP * 2, $80
	wait QUAVER
	setFrequency NOTE_G * 2, $80
	wait CROTCHET

	setFrequency NOTE_G_SHARP, $80
	wait QUAVER
	setFrequency NOTE_D_SHARP * 2, $80
	wait QUAVER
	setFrequency NOTE_G_SHARP * 2, $80
	wait CROTCHET
	setFrequency NOTE_A, $80
	wait QUAVER
	setFrequency NOTE_D * 2, $80
	wait QUAVER
	setFrequency NOTE_A * 2, $80
	wait CROTCHET

	setFrequency NOTE_A_SHARP * 2, $80
	wait MINIM + DOTTED_CROTCHET * 2
	setFrequency NOTE_A * 2, $80
	wait MINIM

	setFrequency NOTE_A_SHARP * 2, $80
	wait MINIM + DOTTED_CROTCHET * 2
	setFrequency NOTE_A * 2, $80
	wait MINIM

	setFrequency NOTE_F_SHARP * 2, $80
	wait MINIM + DOTTED_CROTCHET * 2
	setFrequency NOTE_E * 2, $80
	wait MINIM

	setFrequency NOTE_F_SHARP * 2, $80
	wait MINIM + DOTTED_CROTCHET * 2
	setFrequency NOTE_E * 2, $80
	wait MINIM

	repeat 2
	setFrequency NOTE_Eb, $80
	wait QUAVER
	setFrequency NOTE_Bb, $80
	wait QUAVER
	setFrequency NOTE_Ab, $80
	wait QUAVER
	setFrequency NOTE_Ab, $80
	wait QUAVER
	setFrequency NOTE_Db * 2, $80
	wait QUAVER
	setFrequency NOTE_E * 2, $80
	wait QUAVER
	setFrequency NOTE_Ab, $80
	wait QUAVER

	setFrequency NOTE_Gb, $80
	wait QUAVER
	setFrequency NOTE_Bb, $80
	wait QUAVER
	setFrequency NOTE_Ab, $80
	wait QUAVER
	setFrequency NOTE_Gb, $80
	wait QUAVER
	setFrequency NOTE_Bb, $80
	wait QUAVER
	setFrequency NOTE_D * 2, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait QUAVER
	continue

	setFrequency NOTE_Eb, $80
	wait QUAVER
	setFrequency NOTE_Bb, $80
	wait QUAVER
	setFrequency NOTE_Ab, $80
	wait QUAVER
	setFrequency NOTE_Ab, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_E * 2, $80
	wait QUAVER
	setFrequency NOTE_Ab * 2, $80
	wait QUAVER

	setFrequency NOTE_Eb * 2, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_D * 2, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait QUAVER
	setFrequency NOTE_A * 2, $80
	wait QUAVER
	setFrequency NOTE_D * 4, $80
	wait QUAVER

	setFrequency NOTE_Eb, $80
	wait QUAVER
	setFrequency NOTE_Bb, $80
	wait QUAVER
	setFrequency NOTE_Ab, $80
	wait QUAVER
	setFrequency NOTE_Ab, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_E * 2, $80
	wait QUAVER
	setFrequency NOTE_Ab * 2, $80
	wait QUAVER

	setFrequency NOTE_Eb * 2, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_D * 2, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait QUAVER
	setFrequency NOTE_A * 2, $80
	wait SEMIQUAVER
	setFrequency NOTE_F * 2, $80
	wait SEMIQUAVER
	setFrequency NOTE_D * 2, $80
	wait QUAVER

	repeat 2
	setFrequency NOTE_Bb * 2, $80
	wait QUAVER
	setFrequency NOTE_Gb * 2, $80
	wait QUAVER
	setFrequency NOTE_Eb * 2, $80
	wait QUAVER
	setFrequency NOTE_Db * 4, $80
	wait DOTTED_QUAVER
	setFrequency NOTE_B * 2, $80
	wait DOTTED_QUAVER
	setFrequency NOTE_Db * 4, $80
	wait QUAVER

	setFrequency NOTE_Bb * 2, $80
	wait QUAVER
	setFrequency NOTE_Gb * 2, $80
	wait QUAVER
	setFrequency NOTE_Eb * 2, $80
	wait QUAVER
	setFrequency NOTE_A * 2, $80
	wait QUAVER
	setFrequency NOTE_Gb * 2, $80
	wait QUAVER
	setFrequency NOTE_Db * 2, $80
	wait QUAVER
	setFrequency NOTE_A * 2, $80
	wait QUAVER
	continue

	repeat 2
	setFrequency NOTE_Gb * 2, $80
	wait QUAVER
	setFrequency NOTE_Eb * 2, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_Bb * 2, $80
	wait DOTTED_QUAVER
	setFrequency NOTE_Ab * 2, $80
	wait DOTTED_QUAVER
	setFrequency NOTE_Bb * 2, $80
	wait QUAVER

	setFrequency NOTE_Eb * 2, $80
	wait QUAVER
	setFrequency NOTE_Gb * 2, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait QUAVER
	setFrequency NOTE_Eb * 2, $80
	wait QUAVER
	setFrequency NOTE_A * 2, $80
	wait QUAVER
	setFrequency NOTE_D * 4, $80
	wait QUAVER
	continue

	repeat 2
	setFrequency NOTE_E, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_E * 2, $80
	wait CROTCHET
	setFrequency NOTE_F, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait CROTCHET
	continue

	repeat 2
	setFrequency NOTE_F_SHARP, $80
	wait QUAVER
	setFrequency NOTE_C_SHARP * 2, $80
	wait QUAVER
	setFrequency NOTE_F_SHARP * 2, $80
	wait CROTCHET
	setFrequency NOTE_G, $80
	wait QUAVER
	setFrequency NOTE_C_SHARP * 2, $80
	wait QUAVER
	setFrequency NOTE_G * 2, $80
	wait CROTCHET
	continue

	repeat 2
	setFrequency NOTE_E, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_E * 2, $80
	wait CROTCHET
	setFrequency NOTE_F, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait CROTCHET
	continue

	setFrequency NOTE_F_SHARP, $80
	wait QUAVER
	setFrequency NOTE_C_SHARP * 2, $80
	wait QUAVER
	setFrequency NOTE_F_SHARP * 2, $80
	wait CROTCHET
	setFrequency NOTE_G, $80
	wait QUAVER
	setFrequency NOTE_C_SHARP * 2, $80
	wait QUAVER
	setFrequency NOTE_G * 2, $80
	wait CROTCHET

	setFrequency NOTE_G_SHARP, $80
	wait QUAVER
	setFrequency NOTE_D_SHARP * 2, $80
	wait QUAVER
	setFrequency NOTE_G_SHARP * 2, $80
	wait CROTCHET
	setFrequency NOTE_A, $80
	wait QUAVER
	setFrequency NOTE_D * 2, $80
	wait QUAVER
	setFrequency NOTE_A * 2, $80
	wait CROTCHET

	setFrequency NOTE_A * 2, $80
	wait QUAVER
	setFrequency NOTE_G * 2, $80
	wait QUAVER
	setFrequency NOTE_A * 2, $80
	wait QUAVER
	setFrequency NOTE_E * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER
	setFrequency NOTE_A, $80
	wait SEMIQUAVER
	setFrequency NOTE_B, $80
	wait SEMIQUAVER

	setFrequency NOTE_C * 2, $80
	wait CROTCHET
	setFrequency NOTE_C * 4, $80
	wait CROTCHET
	setFrequency NOTE_B * 2, $80
	wait CROTCHET
	setFrequency NOTE_G * 2, $80
	wait CROTCHET

	setFrequency NOTE_A * 2, $80
	wait QUAVER
	setFrequency NOTE_B * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER
	setFrequency NOTE_E * 4, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER
	setFrequency NOTE_B * 2, $80
	wait QUAVER
	setFrequency NOTE_G * 2, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER

	setFrequency NOTE_C * 2, $80
	wait CROTCHET
	setFrequency NOTE_G * 2, $80
	wait CROTCHET
	setFrequency NOTE_A * 2, $80
	wait DOTTED_CROTCHET
	setFrequency NOTE_E * 2, $80
	wait SEMIQUAVER
	setFrequency NOTE_G * 2, $80
	wait SEMIQUAVER

	setFrequency NOTE_A * 2, $80
	wait QUAVER
	setFrequency NOTE_G * 2, $80
	wait QUAVER
	setFrequency NOTE_A * 2, $80
	wait QUAVER
	setFrequency NOTE_B * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER
	setFrequency NOTE_B * 2, $80
	wait QUAVER
	setFrequency NOTE_D * 4, $80
	wait QUAVER
	setFrequency NOTE_B * 2, $80
	wait QUAVER

	setFrequency NOTE_C * 4, $80
	wait QUAVER
	setFrequency NOTE_B * 2, $80
	wait QUAVER
	setFrequency NOTE_A * 2, $80
	wait QUAVER
	setFrequency NOTE_G * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait CROTCHET
	setFrequency NOTE_B, $80
	wait CROTCHET

	setFrequency NOTE_A, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER
	setFrequency NOTE_E * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER
	setFrequency NOTE_E * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER

	setFrequency NOTE_A, $80
	wait QUAVER
	setFrequency NOTE_G, $80
	wait QUAVER
	setFrequency NOTE_E, $80
	wait QUAVER
	setFrequency NOTE_G, $80
	wait QUAVER
	setFrequency NOTE_A, $80
	wait CROTCHET
	setFrequency NOTE_B, $80
	wait CROTCHET

	setFrequency NOTE_A * 2, $80
	wait QUAVER
	setFrequency NOTE_G * 2, $80
	wait QUAVER
	setFrequency NOTE_A * 2, $80
	wait QUAVER
	setFrequency NOTE_E * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER
	setFrequency NOTE_A, $80
	wait SEMIQUAVER
	setFrequency NOTE_B, $80
	wait SEMIQUAVER

	setFrequency NOTE_C * 2, $80
	wait CROTCHET
	setFrequency NOTE_C * 4, $80
	wait CROTCHET
	setFrequency NOTE_B * 2, $80
	wait CROTCHET
	setFrequency NOTE_G * 2, $80
	wait CROTCHET

	setFrequency NOTE_A * 2, $80
	wait QUAVER
	setFrequency NOTE_B * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER
	setFrequency NOTE_E * 4, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER
	setFrequency NOTE_B * 2, $80
	wait QUAVER
	setFrequency NOTE_G * 2, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER

	setFrequency NOTE_C * 2, $80
	wait CROTCHET
	setFrequency NOTE_G * 2, $80
	wait CROTCHET
	setFrequency NOTE_A * 2, $80
	wait DOTTED_CROTCHET
	setFrequency NOTE_E * 2, $80
	wait SEMIQUAVER
	setFrequency NOTE_G * 2, $80
	wait SEMIQUAVER

	setFrequency NOTE_A * 2, $80
	wait QUAVER
	setFrequency NOTE_G * 2, $80
	wait QUAVER
	setFrequency NOTE_A * 2, $80
	wait QUAVER
	setFrequency NOTE_B * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER
	setFrequency NOTE_B * 2, $80
	wait QUAVER
	setFrequency NOTE_D * 4, $80
	wait QUAVER
	setFrequency NOTE_B * 2, $80
	wait QUAVER

	setFrequency NOTE_C * 4, $80
	wait QUAVER
	setFrequency NOTE_B * 2, $80
	wait QUAVER
	setFrequency NOTE_A * 2, $80
	wait QUAVER
	setFrequency NOTE_G * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait CROTCHET
	setFrequency NOTE_B, $80
	wait CROTCHET

	setFrequency NOTE_A, $80
	wait QUAVER
	setFrequency NOTE_B, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER
	setFrequency NOTE_E * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER
	setFrequency NOTE_E * 2, $80
	wait QUAVER
	setFrequency NOTE_B * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER

	setFrequency NOTE_A * 2, $80
	wait QUAVER
	setFrequency NOTE_G * 2, $80
	wait QUAVER
	setFrequency NOTE_E * 2, $80
	wait QUAVER
	setFrequency NOTE_G * 2, $80
	wait QUAVER
	setFrequency NOTE_A * 2, $80
	wait CROTCHET
	setFrequency NOTE_A * 2, $80
	wait SEMIQUAVER
	setFrequency NOTE_E * 2, $80
	wait SEMIQUAVER
	setFrequency NOTE_C * 2, $80
	wait SEMIQUAVER
	setFrequency NOTE_A, $80
	wait SEMIQUAVER



	setFrequency NOTE_Bb * 2, $80
	wait QUAVER
	setFrequency NOTE_Ab * 2, $80
	wait QUAVER
	setFrequency NOTE_Bb * 2, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait QUAVER
	setFrequency NOTE_Db * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER
	setFrequency NOTE_Db * 2, $80
	wait QUAVER
	setFrequency NOTE_Bb, $80
	wait SEMIQUAVER
	setFrequency NOTE_C * 2, $80
	wait SEMIQUAVER

	setFrequency NOTE_Db * 2, $80
	wait CROTCHET
	setFrequency NOTE_Db * 4, $80
	wait CROTCHET
	setFrequency NOTE_C * 4, $80
	wait CROTCHET
	setFrequency NOTE_Ab * 2, $80
	wait CROTCHET

	setFrequency NOTE_Bb * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER
	setFrequency NOTE_Db * 4, $80
	wait QUAVER
	setFrequency NOTE_F * 4, $80
	wait QUAVER
	setFrequency NOTE_Db * 4, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER
	setFrequency NOTE_Ab * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER

	setFrequency NOTE_Db * 2, $80
	wait CROTCHET
	setFrequency NOTE_Ab * 2, $80
	wait CROTCHET
	setFrequency NOTE_Bb * 2, $80
	wait DOTTED_CROTCHET
	setFrequency NOTE_F * 2, $80
	wait SEMIQUAVER
	setFrequency NOTE_Ab * 2, $80
	wait SEMIQUAVER

	setFrequency NOTE_Bb * 2, $80
	wait QUAVER
	setFrequency NOTE_Ab * 2, $80
	wait QUAVER
	setFrequency NOTE_Bb * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER
	setFrequency NOTE_Db * 4, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER
	setFrequency NOTE_Eb * 4, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER

	setFrequency NOTE_Db * 4, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER
	setFrequency NOTE_Bb * 2, $80
	wait QUAVER
	setFrequency NOTE_Ab * 2, $80
	wait QUAVER
	setFrequency NOTE_Db * 2, $80
	wait CROTCHET
	setFrequency NOTE_C * 2, $80
	wait CROTCHET

	setFrequency NOTE_Bb, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER
	setFrequency NOTE_Db * 2, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait QUAVER
	setFrequency NOTE_Db * 2, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait QUAVER
	setFrequency NOTE_Db * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER

	setFrequency NOTE_Bb, $80
	wait QUAVER
	setFrequency NOTE_Ab, $80
	wait QUAVER
	setFrequency NOTE_F, $80
	wait QUAVER
	setFrequency NOTE_Ab, $80
	wait QUAVER
	setFrequency NOTE_Bb, $80
	wait CROTCHET
	setFrequency NOTE_C * 2, $80
	wait CROTCHET

	setFrequency NOTE_Bb * 2, $80
	wait QUAVER
	setFrequency NOTE_Ab * 2, $80
	wait QUAVER
	setFrequency NOTE_Bb * 2, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait QUAVER
	setFrequency NOTE_Db * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER
	setFrequency NOTE_Db * 2, $80
	wait QUAVER
	setFrequency NOTE_Bb, $80
	wait SEMIQUAVER
	setFrequency NOTE_C * 2, $80
	wait SEMIQUAVER

	setFrequency NOTE_Db * 2, $80
	wait CROTCHET
	setFrequency NOTE_Db * 4, $80
	wait CROTCHET
	setFrequency NOTE_C * 4, $80
	wait CROTCHET
	setFrequency NOTE_Ab * 2, $80
	wait CROTCHET

	setFrequency NOTE_Bb * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER
	setFrequency NOTE_Db * 4, $80
	wait QUAVER
	setFrequency NOTE_F * 4, $80
	wait QUAVER
	setFrequency NOTE_Db * 4, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER
	setFrequency NOTE_Ab * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER

	setFrequency NOTE_Db * 2, $80
	wait CROTCHET
	setFrequency NOTE_Ab * 2, $80
	wait CROTCHET
	setFrequency NOTE_Bb * 2, $80
	wait DOTTED_CROTCHET
	setFrequency NOTE_F * 2, $80
	wait SEMIQUAVER
	setFrequency NOTE_Ab * 2, $80
	wait SEMIQUAVER

	setFrequency NOTE_Bb * 2, $80
	wait QUAVER
	setFrequency NOTE_Ab * 2, $80
	wait QUAVER
	setFrequency NOTE_Bb * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER
	setFrequency NOTE_Db * 4, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER
	setFrequency NOTE_Eb * 4, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER

	setFrequency NOTE_Db * 4, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER
	setFrequency NOTE_Bb * 2, $80
	wait QUAVER
	setFrequency NOTE_Ab * 2, $80
	wait QUAVER
	setFrequency NOTE_Db * 2, $80
	wait CROTCHET
	setFrequency NOTE_C * 2, $80
	wait CROTCHET

	setFrequency NOTE_Bb, $80
	wait QUAVER
	setFrequency NOTE_C * 2, $80
	wait QUAVER
	setFrequency NOTE_Db * 2, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait QUAVER
	setFrequency NOTE_Db * 2, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait QUAVER
	setFrequency NOTE_C * 4, $80
	wait QUAVER
	setFrequency NOTE_Db * 4, $80
	wait QUAVER

	setFrequency NOTE_Bb * 2, $80
	wait QUAVER
	setFrequency NOTE_Ab * 2, $80
	wait QUAVER
	setFrequency NOTE_F * 2, $80
	wait QUAVER
	setFrequency NOTE_Ab * 2, $80
	wait QUAVER
	setFrequency NOTE_Bb * 2, $80
	wait MINIM

	stopMusic
	jump .loop
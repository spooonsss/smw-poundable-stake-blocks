;this routine fixes vertical level block-positioning issues after you change map16.
	LDA $5B				;\Check if vertical level = true
	AND #$01			;|
	BEQ +				;/
	LDA $99				;\Prevent strange behavor on top-left subscreen of vertical level.
	BNE ++				;|(such as interact with the wrong blocks; 2 blocks at same time)
	LDA $9B				;|This also leads to penetration through without stopping the groundpound.
	BNE ++				;|
	BRA +				;/
++
	PHY
	LDA $99				;\Fix the $99 and $9B from glitching up if placed
	LDY $9B				;|other than top-left subscreen boundaries of vertical
	STY $99				;|levels!!!!! (barrowed from the map16 change routine of GPS).
	STA $9B				;|(this switch values $99 <-> $9B, since the subscreen boundaries are sideways).
	PLY
+					;/
	RTL
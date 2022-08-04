;Act as $130

!GroundPoundPatch	= 1		;>0 = if you haven't installed it, 1 otherwise.

 !Freeram_GroundPownFlg	= $1E00|!addr
 ;^GroundPound's flag for determining if player is ground pounding. This is basically
 ;fixed_ground_pound's "!Freeram" (without any character added to it), do not use the
 ;other freeram.

!HeadTile		= $0500		;>The topmost tile the player pound this block.
!BodyTile		= $0510		;>The body tile(s) under the head tile
!Flatten		= $0501		;>Tile turns into after pounded to the bottommost.
!RequirePowerup		= 1		;>0 = none, 1 = at least super.

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside

MarioAbove:
TopCorner:
	if !RequirePowerup != 0
		LDA $19		;\Requires big AND super, not OR.
		BEQ Ret		;/
	endif
	if !GroundPoundPatch == 0
		LDA $140D|!addr
		BEQ Ret
		STZ $140D|!addr		;>Stop spinjumping
	else
		LDA !Freeram_GroundPownFlg	;\Don't pound down if not ground pound.
		BEQ Ret				;/
	endif
	REP #$20		;
	LDA $98			;\Save block current Y position.
	PHA			;/
	CLC			;\Check block number under the head block
	ADC #$0010		;|
	STA $98			;/
	SEP #$20		;
	%get_map16()		;>Routine that reads the map16 number
	STA $00			;\Write so that the 16-bit can read properly
	STY $01			;/
	REP #$20
	LDA $00			;\If the tile under it is a body tile, turn that into a head
	CMP.w #!BodyTile	;/tile.
	BEQ OneTileDown

ReachedBottom: ;>Otherwise if reach the ground, turn only itself into a flat tile.
	PLA			;\Restore current block Y pos
	STA $98			;|
	SEP #$20		;/
	REP #$10		;\Turn into flat tile if there are no
	LDX.w #!Flatten		;|pounds left.
	%change_map16()		;|
	SEP #$10		;/
	RTL

OneTileDown:
	PLA			;\Restore current block Y pos
	STA $98			;|
	SEP #$20		;/
	%erase_block()		;>Turn upper head block into blank...
	%swap_XY()
	REP #$20		;\...While the tile below it...
	LDA $98			;|
	CLC			;|
	ADC #$0010		;|
	STA $98			;|
	SEP #$20		;/
	REP #$10		;\...Turns into a head tile.
	LDX #!HeadTile		;|
	%change_map16()		;|
	SEP #$10		;/

MarioBelow:
MarioSide:
BodyInside:
HeadInside:
SpriteV:
SpriteH:
MarioCape:
MarioFireball:
Ret:
	RTL
if !GroundPoundPatch == 0
	print "A stake head that can be shorten by spinjump"
else
	print "A stake head that can be shorten by ground pound"
endif
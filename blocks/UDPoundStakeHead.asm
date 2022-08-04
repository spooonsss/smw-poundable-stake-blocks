;Act as $130

!HeadTile		= $0520		;>The bottom tile (hanging) the player pound this block.
!BodyTile		= $0510		;>The body tile(s) above the head tile
!Flatten		= $0511		;>Tile turns into after pounded to the topmost.
!RequirePowerup		= 1		;>0 = none, 1 = at least super.

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside

MarioBelow:
	if !RequirePowerup != 0
		LDA $19		;\If at least super
		BEQ Ret		;/
	endif
	REP #$20		;
	LDA $98			;\Save block current Y position.
	PHA			;/
	SEC			;\Check block number above the head block
	SBC #$0010		;|
	STA $98			;/
	SEP #$20		;
	%get_map16()		;>Routine that reads the map16 number
	STA $00			;\Write so that the 16-bit can read properly
	STY $01			;/
	REP #$20
	LDA $00			;\If the tile above it is a body tile, turn that into a head
	CMP.w #!BodyTile	;/tile.
	BEQ OneTileUp

ReachTop:
	PLA			;\Restore current block Y pos
	STA $98			;|
	SEP #$20		;/
	REP #$10		;\Turn into flat tile if there are no
	LDX.w #!Flatten		;|hits left.
	%change_map16()		;|
	SEP #$10		;/
	RTL

OneTileUp:
	PLA			;\Restore current block Y pos
	STA $98			;|
	SEP #$20		;/
	%erase_block()		;>Turn bottom head block into blank...
	%swap_XY()
	REP #$20		;\...While the tile above it...
	LDA $98			;|
	SEC			;|
	SBC #$0010		;|
	STA $98			;|
	SEP #$20		;/
	REP #$10		;\...Turns into a head tile.
	LDX #!HeadTile		;|
	%change_map16()		;|
	SEP #$10		;/

MarioAbove:
MarioSide:
TopCorner:
BodyInside:
HeadInside:
SpriteV:
SpriteH:
MarioCape:
MarioFireball:
Ret:
	RTL

print "An upside down stake head block"
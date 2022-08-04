Should be 7 items in main folder.

Tired of having stake blocks that can get cutoffs when you pound them and wishing someone would make an ASM that
would "move" the head of the stake block (and stops when it hits the floor)? Well here it is.

It is a simple code to pull off, with only the vertical level being the most tricky.


Instructions:
 1) Graphics:

  1.1) Insert the graphics (named "ExGFX80_BG2.bin"). It is basically the log graphic on the rope tileset of smw.
  Insert that as "BG2" in Lunar Magic.

  1.2) Then insert the map16 data (StakeBlock16.map16) into your map16. By default, both the GPS blocks and the
  map16 uses page 5.


 2) ASM:

  2.1) copy-paste the text from "list.txt" to GPS's list. copy-paste the blocks into GPS's blocks, and all the asm
  files in routines into GPS's routines folder.

  2.2) Make any !Defines changes needed in the blocks:

   -!HeadTile the block number it turns into when pounded, it would either disappear and spawn another head tile
   under it to simulate the appearence that the head block have moved downward, or turn into a flat tile once it
   reaches the bottom without affecting the tile under it.

   -!BodyTile is the stem part of the stake. This is not a custom block, but you must have its block number so that
   the stake head knows what to turn into when you place this under the head.

   -!Flatten is the tile it turns into after the head reaches the bottommost.

   -!RequirePowerup is an option to require the player to be at least super in order to effect the block.

   -!GroundPoundPatch (exclusive to PoundStakeHead.asm) is an option if you want the player to ground pound
   the stake to shorten it instead of a spinjump. If = 1, you must have the freeram use of whats labeled
   "!Freeram" (without any character added to it) to make it properly work.

   -!Freeram_GroundPownFlg Explained above.

  Note that the UD version, is upside down, meaning that the stem would be on top and "moves" upward instead.  

 3) Block placement

  Place the blocks like this (best in monospace character width mode):
  ;----ASCII_art----;

   Normal:     Upsidedown:
   [H]         [-]         [H] = PoundStakeHead.asm (the poundable block)
   [B]         [B]         [B] = the body section (the "neck"), not a custom block.
   [B]         [B]         [U] = UDPoundStakeHead.asm (upsidedown version of [H]).
   [B]         ...         [-] = Floor/ground/ceiling, where the stake becomes flat and cannot be further pounded
   ...         [B]
   [-]         [U]
  ;----end_ASCII_art----;

 4) Now you are done.

Credits:
 -Akaginite (ID:8691) for the subroutine that gets the map16 number at a given 16x16 block grid position, without
 this, the head stake block would be possible to continue going, even past the floor/ceiling blocks.
 -GreenHammerBro (ID:18802) for creating this block.

-----------------------------
Version history:
1/9/2017
	-Removed by Erik557 (ID:17672) because:
		-Fix a potential glitch that can crash the game. This is caused by the getblock routine using an RTS when
		 it should be a RTL (I only replace one RTS, but forgot that there's another one).
		-Removed some unnecessary opcodes; REP #$20 and then SEP #$20 right after, LDA $98 : PHA : LDA $98 since
		 the value in $98 still lies in A.
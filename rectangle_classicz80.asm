; draws rectangle on screen using algorithm to calculate PIXELADDRESS (can be used with any classic ZX Spectrum, no PIXELAD/PIXELDN commands as in Spectrum NEXT
org 30000 
start:
;border color
	   LD A,6
	   OUT ($FE),A ; 254,a
; attributes (code by Spiteworx https://www.youtube.com/watch?v=jE8ksX8_0No&t=352s)
	   LD HL,$5800 ; start of attribute memory (SCREEN MEMORY COLOR DATA)
 	   LD A, 0+0+56+3 ;64+48+2 attributes FLASH *128 + BRIGHT *64 + PAPER *8 + INK
	   LD (HL),A   ; Set first byte of attribute memory
; set attributes for the whole screen (Copies first byte to the following 767 bytes)
	   ; DRAW HORIZONTAL LINE
	   LD DE, $5801 ; First destination address of LDIR
	   LD BC, 767 ; 767 number of bytes to copy to display memory (23x32 characters on screen)
	   LDIR
; END OF ATTRIBUTE ROUTINE
COORDS:
	   LD D,100 ; X (vertical) 0-178
	   LD C,100 ; Y (horizontal) 0-255
    	   PUSH BC ; stores initial position      
	   PUSH DE ; of left lower corner

	   LD B,100 ; rectangle width
LOWERHORIZONTAL:
	   CALL Get_Pixel_Address
	   LD(HL),%11111111
	   INC C
	   DJNZ LOWERHORIZONTAL
	   DEC C

	   LD B,35 ;rectangle height
RIGHTVERTICAL:
           CALL PIXELUP
	   LD(HL),%00000001
	   DJNZ RIGHTVERTICAL
; cursor restored to left lower corner  
	   POP DE
	   POP BC
	   CALL Get_Pixel_Address 

	   LD B,35 ; rectangle height 
LEFTVERTICAL:
           CALL PIXELUP
	   LD(HL),%10000000
           DEC D
	   DJNZ LEFTVERTICAL
	
	   LD B,100 ; rectangle width
UPPERHORIZONTAL:
	   CALL Get_Pixel_Address
	   LD(HL),%11111111
	   INC C
	   DJNZ UPPERHORIZONTAL
	      
; returns to BASIC
	   RET

Get_Pixel_Address:	; routine borrowed from http://www.breakintoprogram.co.uk/hardware/computers/zx-spectrum/screen-memory-layout
			LD A,D				; Calculate Y2,Y1,Y0
			AND %00000111			; Mask out unwanted bits
			OR %01000000			; Set base address of screen
			LD H,A				; Store in H
			LD A,D				; Calculate Y7,Y6
			RRA				; Shift to position
			RRA
			RRA
			AND %00011000			; Mask out unwanted bits
			OR H				; OR with Y2,Y1,Y0
			LD H,A				; Store in H
			LD A,D				; Calculate Y5,Y4,Y3
			RLA				; Shift to position
			RLA
			AND %11100000			; Mask out unwanted bits
			LD L,A				; Store in L
			LD A,C				; Calculate X4,X3,X2,X1,X0
			RRA				; Shift into position
			RRA
			RRA
			AND %00011111			; Mask out unwanted bits
			OR L				; OR with Y5,Y4,Y3
			LD L,A				; Store in L
			;LD A,C
			;AND %0111
			RET
PIXELUP:                ; routine borrowed from Alvin Albrecht's Display File Organization - http://www.geocities.com/aralbrec/spritepack/ )
			LD A,H ; A=H=010BBSSS
			DEC H ; DECREASESSS
			AND $07 ; IF SSS WAS NOT ORIGINALLY000
			RET NZ ; WE'REDONE
			LD A,$08 ; OTHERWISESSS=111(CORRECT)
			ADD A,H ; AND WE FIX BB IN H (ONE WAS SUBTRACTED)
			LD H,A
			LD A,L ; A=X COORD=LLLCCCCC
			SUB $20 ; DECREASELLL
			LD L,A
			RET NC ; IF NO CARRY,LLL WAS NOT ORIGINALLY000, OK
			LD A,H ; OTHERWISELLL=111NOW, THAT'SOKAY
			SUB $08 ; BUT NEED TO DECREASESCREENBLOCK
			LD H,A
			RET

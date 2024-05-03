; draws rectangle on screen using algorithm to calculate PIXELADDRESS (can be used with any classic ZX Spectrum, no PIXELAD/PIXELDN commands as in NEXT)
org 30000 
start:
;border color
	   ;LD a,0
	   ;OUT ($FE),a ; 254,a
; attributes (code by Spiteworx https://www.youtube.com/watch?v=jE8ksX8_0No&t=352s)
	   LD HL,$5800 ; start of attribute memory (SCREEN MEMORY COLOR DATA)
 	   LD A, 0+0+56+3 ;64+48+2 attributes FLASH *128 + BRIGHT *64 + PAPER *8 + INK
	   LD (HL),a   ; Set first byte of attribute memory
; set attributes for the whole screen (Copies first byte to the following 767 bytes)
	   ; DRAW HORIZONTAL LINE
	   LD DE, $5801 ; First destination address of LDIR
	   LD BC, 767 ; 767 number of bytes to copy to display memory (23x32 characters on screen)
	   LDIR
; END OF ATTRIBUTE ROUTINE

DRAW_UPPER_HORIZONTAL_LINE:
	   LD D,40 ; X (vertical)
	   LD C,50 ; Y (horizontal)
	   CALL Get_Pixel_Address
	   ;PUSH HL
	   ;LD HL, 16384
	   LD B,20 ; line length *8pixel/ rectangle width
	   LD A,%11111111; 8 pixel graphic line
	   LD E,8
LOOP:
	   LD(HL),A
	   INC HL
	   LD A,C ; using A for the addition
	   ADD A,E
	   LD C,A
	   LD A,%11111111; restores function of A
	   DJNZ LOOP
	   LD E,7 ; corrects rightmost position of the cursor
           LD A,C
	   SUB E
	   LD C,A
           ;POP HL

DRAW_RIGHT_VERTICAL_LINE:
	   LD B,10
	   LD A,%11111111
LOOPV1:
	   INC D
           CALL Get_Pixel_Address       
	   LD (HL),A
	   DJNZ LOOPV1

DRAW_LOWER_HORIZONTAL_LINE:
	   ;LD D,50 ; X (vertical)
	   ;LD C,50 ; Y (horizontal)
	   ;CALL Get_Pixel_Address
	   ;PUSH HL
	   LD B,20 ; line length *8pixel/ rectangle width
	   LD A,255
	   LD E,8
LOOP2:
	   LD(HL),A
	   DEC HL
	   LD A,C ; using A for the addition
	   SUB E
	   LD C,A
	   LD A,%11111111; restores function of A
	   DJNZ LOOP2
	   ;POP HL

DRAW_LEFT_VERTICAL_LINE:
	   LD B,10
	   LD A,%11111111
LOOPV2:
	   DEC D
           CALL Get_Pixel_Address       
	   LD (HL),A
	   DJNZ LOOPV2




	   RET


Get_Pixel_Address:	; Code kindly borrowed (and modified) from http://www.breakintoprogram.co.uk/hardware/computers/zx-spectrum/screen-memory-layout
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
			LD A,C
			AND %0111
			RET

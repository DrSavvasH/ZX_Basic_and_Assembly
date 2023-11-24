;;--------------------------------------------------------------------
;; sjasmplus setup
;;--------------------------------------------------------------------
	
	; Allow Next paging and instructions
	DEVICE ZXSPECTRUMNEXT
	SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
	
	; Generate a map file for use with Cspect
	CSPECTMAP "build/test.map"

;;--------------------------------------------------------------------
;; Note : In order to call different rectangles from BASIC with POKE x: POKE y we have to use HEX values for PIXELAD according to the instructions below !
;;        A HEX calculator will be needed from BASIC (with care for correct syntax for four digit HEX numbers according to the examples below)
;;        We simply copy the code below to our BASIC program and call with different values as needed
;;        POKE 30022,%$44 : REM x(horizontal position)
;;        POKE 30023,%$50 : REM y(vertical position)
;;        POKE 30015,8   : REM rectangle height
;;        POKE 30017,100 : REM rectangle width
;; Note 2: In order to erase the rectangle (INVERSE INK), you have to poke color of attributes in line 29 of this program, with POKE 300008, 0+0+56+7 (white INK)
;;--------------------------------------------------------------------
	ORG 30000
start:
;border color
	LD a,0
	OUT ($FE),a ; 254,a
; attributes (code by Spiteworx https://www.youtube.com/watch?v=jE8ksX8_0No&t=352s)
	   LD HL,$5800 ; start of attribute memory (SCREEN MEMORY COLOR DATA)
 	   LD A, 0+0+56 ;64+48+2 attributes FLASH *128 + BRIGHT *64 + PAPER *8 + INK
	   LD (HL),a   ; Set first byte of attribute memory
; set attributes for the whole screen (Copies first byte to the following 767 bytes)
	   LD DE,$5801 ; First destination address of LDIR
	   LD BC,767 ; 767 number of bytes to copy to display memory (23x32 characters on screen)
	   LDIR
; ************************************MY CODE
; Set height and width of rectangle 
	   LD C,50   ; POKE 30014,8
	   LD A,20  ; POKE 30016,80
	   PUSH BC ; store for later use
	   PUSH AF ; store for later use
	   ;LD HL, $4000   Starting Pixel. Instead of giving a specific screen address, we will ask PIXELAD to calculate it for us (more convenient)	  
       LD DE, $0A0A; Starting pixel (in 4-digit HEX) prepared for PIXELAD . D=Y (Vertical) and E=X (horizontal). 
	   				; How to calculate: put Y coordinates in calc as DEC and write down HEX. Repeat with X. Then put both HEX values next to each other --> magic!  
					;eg DECIMAL 16 and 32 (Y=16, X=32) --> HEX 10 and 20 --> type 1020
					;0,0 --> 00   191,255 --> BFFF  160,160 -->0A0A  10,10 --> 0A0A  20,20 -->1414  30,30 -->1E1E  40,40 -->2828 
					; 50,50 -->3232 70,70 --> 4646  80,80-->5050 90,90 -->
;60,60-->3C3C (SPECIAL CASE - specific position doesn't like fixation of last horizontal line, so we'll have to send it to 
;              a separate execution code)
	   LD A,$3C
	   CP D
	   JR Z,CompareE
	   JR DrawWithFixation
CompareE:
	   LD A,$3C
       CP E
	   JR Z,DrawWithoutFixation
DrawWithFixation:
drawVerticalLIne1:
       LD B,C ; program will loop 8 times and continue (For B=8 to 1 step -1) 0-191 or 0-255
loop1: 
	   PIXELAD		  ; calculate new pixel location on memory
	   LD A, %10000000; bits  128 64 32 16 8 4 2 1  
	   LD (HL),A      ; draw pixel
	   INC D          ; increase Y
	   DJNZ loop1     ; loop

drawHorizontalLIne1:
       POP AF
       LD B,A ; (bytes*8) -- > program will loop 80 times and continue (For B=80 to 1 step -1) 0-191 or 0-255
	   PUSH AF
loop2: 
	   PIXELAD
	   LD A, %11111111; bits  128 64 32 16 8 4 2 1
	   LD (HL),A
	   INC E
	   DJNZ loop2	   
       
drawVerticalLIne2: 
       POP AF
	   POP BC
       LD B,C 
	   PUSH AF
loop3:  
	   PIXELAD
	   LD A, %10000000; bits  128 64 32 16 8 4 2 1  
	   LD (HL),A
	   DEC D
	   DJNZ loop3

drawHorizontalLIne2:

prepare_for_final_loop: 
	   POP AF
       LD B,A 
	   LD A, %11111111; bits  128 64 32 16 8 4 2 1
	  ;F I X A T I O N   O F   L A S T   H O R I Z O N T A L   L I N E
	  ;on final horizontal line, avoid drawing one more line on the upper right or left corners. 
	  ;Following routine brings PLOTTING 8 pixels to the left, at the correct position, and compensates for the extra 8 pixels on the left.
	  ;This is a strange bug occuring only at specific locations of memory (or specific locations of screen eg 10,10 -->0A0A)
correct_coords:	 
       DEC B
	   DEC B
	   DEC B
	   DEC B
	   DEC B
	   DEC B
	   DEC B
	   DEC B
       DEC E
	   DEC E
	   DEC E
	   DEC E
	   DEC E
	   DEC E
	   DEC E
	   DEC E ;cannot use djnz for B !!!!! Any other way ????
loop4: 
	   DEC E
	   PIXELAD
	   LD (HL),A
	   DJNZ loop4	   
       ;RET ;--> crashes to 48k mode, when running as standalone MC. Should be active when called from BASIC
       JR $ ; to loop forever. Crashes when used with BASIC

DrawWithoutFixation:

drawVerticalLInew1:
       LD B,C ; program will loop 8 times and continue (For B=8 to 1 step -1) 0-191 or 0-255
loopw1: 
	   PIXELAD		  ; calculate new pixel location on memory
	   LD A, %10000000; bits  128 64 32 16 8 4 2 1  
	   LD (HL),A      ; draw pixel
	   INC D          ; increase Y
	   DJNZ loopw1     ; loop

drawHorizontalLInew1:
       POP AF
       LD B,A ; (bytes*8) -- > program will loop 80 times and continue (For B=80 to 1 step -1) 0-191 or 0-255
	   PUSH AF
loopw2: 
	   PIXELAD
	   LD A, %11111111; bits  128 64 32 16 8 4 2 1
	   LD (HL),A
	   INC E
	   DJNZ loopw2	   
       
drawVerticalLInew2: 
       POP AF
	   POP BC
       LD B,C 
	   PUSH AF
loopw3:  
	   PIXELAD
	   LD A, %10000000; bits  128 64 32 16 8 4 2 1  
	   LD (HL),A
	   DEC D
	   DJNZ loopw3

drawHorizontalLInew2:

wprepare_for_final_loop: 
	   POP AF
       LD B,A 
	   LD A, %11111111; bits  128 64 32 16 8 4 2 1
	  ;F I X A T I O N   O F   L A S T   H O R I Z O N T A L   L I N E
	  ;on final horizontal line, avoid drawing one more line on the upper right or left corners. 
	  ;Following routine brings PLOTTING 8 pixels to the left, at the correct position, and compensates for the extra 8 pixels on the left.
	  ;This is a strange bug occuring only at specific locations of memory (or specific locations of screen eg 10,10 -->0A0A)

loopw4: 
	   DEC E
	   PIXELAD
	   LD (HL),A
	   DJNZ loopw4	   
       ;RET ;--> crashes to 48k mode, when running as standalone MC. Should be active when called from BASIC
       JR $ ; to loop forever. Crashes when used with BASIC
;;--------------------------------------------------------------------
;; Set up .nex output
;;--------------------------------------------------------------------

	; This sets the name of the project, the start address, 
	; and the initial stack pointer.
	SAVENEX OPEN "project.nex", start, $ff40

	; This asserts the minimum core version.  Set it to the core version 
	; you are developing on.
	SAVENEX CORE 2,0,0

	; This sets the border colour while loading (in this case white),
	; what to do with the file handle of the nex file when starting (0 = 
	; close file handle as we're not going to access the project.nex 
	; file after starting.  See sjasmplus documentation), whether
	; we preserve the next registers (0 = no, we set to default), and 
	; whether we require the full 2MB expansion (0 = no we don't).
	SAVENEX CFG 7,0,0,0

	; Generate the Nex file automatically based on which pages you use.
	SAVENEX AUTO

    SAVEBIN "Draw.bin",45000,70 ;- save $4000 begin from $C000 of RAM to file

;;--------------------------------------------------------------------
;; sjasmplus setup
;;--------------------------------------------------------------------
	
	; Allow Next paging and instructions
	DEVICE ZXSPECTRUMNEXT
	SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
	
	; Generate a map file for use with Cspect
	CSPECTMAP "build/test.map"


;;--------------------------------------------------------------------
;; program
;;--------------------------------------------------------------------
	ORG 30000
start:

; attributes (initialization code from Spiteworx https://www.youtube.com/watch?v=jE8ksX8_0No&t=352s)
	   LD HL,$5800 ; start of attribute memory
	   LD A, 56 ;64+48+2 attributes FLASH *128 + BRIGHT *64 + PAPER *8 + INK
	   LD (HL),a   ; Set first byte of attribute memory
; set attributes for the whole screen
	   LD DE,$5801 ; First destination address of LDIR
	   LD BC,767 ; 767 number of bytes to copy to display memory
	   LDIR
;My Code
	   LD C,8   ; POKE 30014,8
	   LD A,80  ; POKE 30016,80
	   PUSH BC
	   PUSH AF
drawVerticalLIne1:
       LD B,C ; program will loop 8 times and continue (For B=8 to 1 step -1) 0-191 or 0-255
       ;LD HL, $4000    Instead of giving a specific screen address, we will ask PIXELAD to calculate it for us (convenient)
	   LD DE, $A0 ; D=Y and E=X --> DECIMAL 1632 Y=16, X=32
	   LD A, %10000000; bits  128 64 32 16 8 4 2 1  
loop1: 
	   PIXELAD
	   LD (HL),A
	   INC D
	   DJNZ loop1
drawHorizontalLIne1:
       POP AF
       LD B,A ; (bytes*8) -- > program will loop 80 times and continue (For B=80 to 1 step -1) 0-191 or 0-255
	   PUSH AF
       ;LD HL, $4000    Instead of giving a specific screen address, we will ask PIXELAD to calculate it for us (convenient)
	   ;LD DE, $BF00 ; (Y,X) --> D=Y and E=X --> HEX 1020 OR DECIMAL 1632 Y=16, X=32
	   LD A, %11111111; bits  128 64 32 16 8 4 2 1
loop2: 
	   PIXELAD
	   LD (HL),A
	   INC E
	   DJNZ loop2	   
       ;RET --> crashes to 48k mode
       
drawVerticalLIne2:  ; My code
       POP AF
	   POP BC
       LD B,C ; program will loop 8 times and continue (For B=8 to 1 step -1) 0-191 or 0-255
	   PUSH AF
       ;LD HL, $4000    Instead of giving a specific screen address, we will ask PIXELAD to calculate it for us (convenient)
	   ;LD DE, $AA ; D=Y and E=X --> DECIMAL 1632 Y=16, X=32
	   LD A, %10000000; bits  128 64 32 16 8 4 2 1  
loop3:  
	   PIXELAD
	   LD (HL),A
	   DEC D
	   DJNZ loop3
drawHorizontalLIne2:
	   POP AF
       LD B,A ; (bytes*8) -- > program will loop 80 times and continue (For B=80 to 1 step -1) 0-191 or 0-255
       ;LD HL, $4000    Instead of giving a specific screen address, we will ask PIXELAD to calculate it for us (convenient)
	   ;LD DE, $BF00 ; (Y,X) --> D=Y and E=X --> HEX 1020 OR DECIMAL 1632 Y=16, X=32
	   LD A, %11111111; bits  128 64 32 16 8 4 2 1
loop4: 
	   DEC E
	   PIXELAD
	   LD (HL),A
	   DJNZ loop4	   
       ;RET --> crashes to 48k mode
       JR $ ; to loop forever
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

    SAVEBIN "Code.bin",30000,1000 ;- save $4000 begin from $C000 of RAM to file

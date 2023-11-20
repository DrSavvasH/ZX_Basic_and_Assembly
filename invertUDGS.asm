; Invert UDGs by inverting the bytes one-by-one
; A useful snippet for app/game graphics on the ZX Spectrum (tested in 128k,48k)
org 30000
	ld a,2
	call 5633  ;open channel 2- write to screen	
	call 3505 ;CLS
	ld hl,udgs     ;hl,de,bc,ix,iy also work; assigns an address to udgs (eg 30032)
        ld(23675),hl
; copy first UDG to second UDG slot (+8)
	 ld hl,30056
	 ld de,30064
         ld bc,8
         ldir
; invert second UDG
   	; With xor alone the graphic is completely inverted (black becomes white), but nor mirrored (left to right)
	;ld a,(30027)      ; dont use de here
	;ld c,%11111111
	;xor c
	; so, I used another method from http://www.retroprogramming.com/2014/01/fast-z80-bit-reversal.html
	ld de,30064
	ld b,8
loop:	
	ld a,(de)
	ld l,a    ; a = 76543210
 	rlca
 	rlca      ; a = 54321076
 	xor l
  	and 0xAA
 	xor l     ; a = 56341270
  	ld l,a
 	rlca
 	rlca
 	rlca      ; a = 41270563
 	rrc l     ; l = 05634127
  	xor l
  	and 0x66
  	xor l     ; a = 01234567
	ld (de),a
	inc de
	djnz loop
main
	call PRTPLAY
	ret
udgs   ;"a" (CHR144)
        defb %11111101
	defb %11111101
	defb %11111101
	defb %11111101
	defb %11111101
	defb %11111101
	defb %11111101
	defb %11111101
PRINT       EQU 8252          ; This means the label PRINT equates to 8252.
            XOR a             ; quick way to load accumulator with zero.
            LD A, 2           ; set print channel to screen
            CALL 5633         ; Open channel two (ie, write to screen)
            CALL 3503         ; clear the screen. CLS
PRTPLAY     LD DE, PLAYER           ; print player graphic
            LD BC, EOPLAYR-PLAYER
            CALL PRINT
	    RET
PLAYER      DEFB 22, 5, 15, 144 ; print at Y, X, char 144 UDG (A)
	    DEFB 22, 6, 15, 145
	    DEFB 22, 7, 15, 144
	    DEFB 22, 8, 15, 145
            DEFB 22, 9, 15, 144 ; print at Y, X, char 144 UDG (A)
	    DEFB 22, 10, 15, 145
	    DEFB 22, 11, 15, 144
	    DEFB 22, 12, 15, 145
EOPLAYR EQU $

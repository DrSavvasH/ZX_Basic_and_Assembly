; draws rectangle on screen using algorithm to calculate PIXELADDRESS (can be used with any classic ZX Spectrum, no PIXELAD/PIXELDN commands as in Spectrum NEXT
;
ORG 30000
SCREEN  EQU $4000                   ; Location of screen
COLOR   EQU $5800                   ; Location of color array
; Get screen address
;  d = Y pixel position
;  e = X pixel position
; GETPIXEL Returns address in HL
		
	ld d,0
	ld e,200
	call GETPIXEL

	ld b,20
DrawHLine:
	inc l
	ld (hl),255
	djnz DrawHLine
	
	ld b,5
DrawVLine:
	inc h
	ld (hl),$00000001
	djnz DrawVLine

	ld b,20
BackDrawHLine:
	ld (hl),255
	dec l
	djnz BackDrawHLine
             
	ld b,5
BackDrawVLine:
	ld (hl),$00000001
	dec h
	djnz BackDrawVLine
	ld (hl),$00000001
	ret

GETPIXEL:   	;code below kindly borrowed from https://wiki.speccy.org/_media/cursos/ensamblador/zx_display.pdf 
        ld a, e
        add a, a
        ld e, a 
        ; next, rotate the coordinate right three bits (to get to Y3, Y4, Y5 in L)
        rrca
        rrca
        rrca        
        ; AND any additional bits off
        and 0xe0
        ; Add in the x offset twice for 16 pixel step
        add a, d
        add a, d        
        ld l, a  ; coordinate bottom byte done
        ; next we do the same for Y6 and Y7; no need to shift because we're in the
        ; right place.
        ld a, e
        and 0x18 ; AND extra bits off, and h is done.
        ld h, a
        ld de, SCREEN
        add hl, de  ; now hl points at the screen offset we want
	ld a,255  ; Get character to print                      ; See if it '$' terminator
	ret

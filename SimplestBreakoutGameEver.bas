1 SAVE "bouncing.bas" : REM Begginer Code for easy animation in BASIC. Also a good practice for NEXT Windows Messaging Channels.
2 LAYER 0 : CLOSE #4: CLOSE #6
3 POKE USR "a", BIN 11111111
4 POKE USR "a"+1, BIN 11111111
5 POKE USR "a"+2, BIN 11111111
6 POKE USR "a"+3, BIN 11111111
7 POKE USR "a"+4, BIN 11111111
8 POKE USR "a"+5, BIN 11001111
9 POKE USR "a"+6, BIN 11110011
10 POKE USR "a"+7, BIN 11111111
12 OPEN # 4,"w>8,8,6,15,8"
13 a$ = "                                                                                       "
15 BORDER 0: PAPER 7: CLS : PRINT #4; paper 0; ink 5;chr$14;chr$1,chr$30;chr$1;"NEXT Bouncer"''"    by Savvas & Mike 2023": pause 200
16 PRINT #4; PAPER 7; CHR$ 1; CHR$ 30; CHR$ 0;a$
17 PRINT #4; PAPER 7; CHR$ 1; CHR$ 30; CHR$ 0;a$
19 PRINT #4 ;chr$14;chr$1;chr$30;chr$1;"Press any key to Start"'"Use 'z' and 'm' to hit the ball": pause 0
21 PRINT #4; PAPER 7; CHR$ 1; CHR$ 30; CHR$ 0;a$
22 PRINT #4; PAPER 7; CHR$ 1; CHR$ 30; CHR$ 0;a$
24 CLOSE # 4: RANDOMIZE: CLS
25 FOR i =1 TO 28 STEP 3
30 FOR j =1 TO 5
35 LET col= INT ( RND *7)
40 PRINT AT j,i; INK col; PAPER col;"[[[";
50 NEXT j
60 NEXT i
70 LET score =0
150 LET x=5: LET y=6
160 LET px=10: LET py=21
190 REM **********MAIN*******
195 REM
196 PRINT AT 0,1;"Score:";score
200 PRINT AT y,x; INK 1;" o "
205 PRINT AT py,px; " "; CHR$ (131); CHR$ (131);" "
210 REM BEEP .3,2
220 PAUSE 1: PRINT AT y,x; "   "
250 LET y=y+1: LET x=x+1
251 REM PRINT AT 21,0; INK 0; SCREEN$ (y-1,x)
252 IF SCREEN$ (y,x)= "[" THEN LET x=-x : LET y=-y: LET score=score+1: BEEP .1,.5
255 IF y=20 AND x=px THEN y=-y: BEEP .1,.2
256 IF y=20 AND x=-px THEN y=-y: BEEP .1,.2
257 IF y=20 AND x=px+1 THEN y=-y: BEEP .1,.2
259 IF y=20 AND x=px+1 THEN y=-y: BEEP .1,.2
260 IF y=20 AND x=-px-1 THEN y=-y: BEEP .1,.2
264 IF y=20 AND x=px+2 THEN y=-y: BEEP .1,.2
265 IF y=20 AND x=-px-2 THEN y=-y: BEEP .1,.2
269 IF y=21 THEN OPEN # 6,"w>10,12,10,10,8" : PRINT #6; INK 2; paper 4; "YOU LOSE" : BORDER 2 : BEEP .5,.9: PAUSE 0: GO TO 10
270 IF x=30 THEN LET x=-x
280 IF y=0 THEN LET y=-y
300 IF x=0 THEN LET x=-x
310 IF INKEY$ ="z" THEN px=px-1
320 IF INKEY$ ="m" THEN px=px+1
330 IF px=-1 THEN LET px=0
340 IF px=29 THEN LET px=28
400 GO TO 190

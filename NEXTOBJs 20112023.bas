10 SAVE "NEXTOBJECTS.bas"
20 LAYER 1,2: BORDER 7: PAPER 7: INK 0: OVER 0: CLS
30 REM NEXT OBJECTS - Development Platform for ZX Spectrum Next v0.1
40 REM
50 REM Menu Init Variables***********************************
60 STARTMENU=9000
70 menuSelect=1
80 dragLock = 0
90 REM ******************************************************
100 REM ObjectMap Array
110 DIM o(64,23): REM table of screen positions of objects x (horizontal), y(vertical). Cannot dim 23,64 (crashes)
120 FOR d=1 TO 64: FOR e=1 TO 23
130 o(d,e)=0 : REM stores all y,x positions as zero
140 NEXT e: NEXT d
150 objIndx=0
160 REM Array of forms (maximum 10)****************************
170 form=0
173 DIM f(10,5): dim f$(10,10): REM 1=x (horizontal), 2=y (vertical), 3 = width, 4 = height, 5= objindx $=label
175 REM Array of Buttons **************************************
176 bttn = 0
177 DIM b(20,5): DIM b$(10,15): REM 1=x (horizontal), 2=y (vertical), 3 = width, height is standard, 4 = parent 5=objindx form $=label
183 REM Types of Objects 1=Form 2=Button 3=TxtBox
190 REM UDGs**************************************************
200 POKE USR "a", BIN 00000001
210 POKE USR "a"+1, BIN 00000011
220 POKE USR "a"+2, BIN 00000111
230 POKE USR "a"+3, BIN 00001111
240 POKE USR "a"+4, BIN 00011111
250 POKE USR "a"+5, BIN 00111111
260 POKE USR "a"+6, BIN 01111111
270 POKE USR "a"+7, BIN 11111111
280 POKE USR "b", BIN 11111110
290 POKE USR "b"+1, BIN 11111100
300 POKE USR "b"+2, BIN 11111000
310 POKE USR "b"+3, BIN 11110000
320 POKE USR "b"+4, BIN 11100000
330 POKE USR "b"+5, BIN 11000000
340 POKE USR "b"+6, BIN 10000000
350 POKE USR "b"+7, BIN 00000000
360 PRINT AT 21,0; INVERSE 1;"NEXT OBJs v1.0                                            "; CHR$ (144); CHR$ (145); CHR$ (144); CHR$ (145); CHR$ (144); CHR$ (145)
370 GO SUB STARTMENU: REM SHOW TOOLS
380 REM Temporary storage of mouse coordinates to assist during drag and drop
390 remx=0:remy=0: remx2=0: remy2=0: w=0
400 REM *************MOUSE ROUTINES
410 PROC init()
420 C=0:S=0:P=0:A=16
430 REM **********************MAIN****************************
440 REM *************Mouse Moves******************************
550 LET xx=%x: LET yy=%y
551 DRIVER 126,1 TO %s,%x,%y: LET %z=%s&@111
553 PRINT AT 23,0;%x;",";%y;" btn ";%z;"     "
555 IF %z=2 THEN GO SUB 900: REM ON LEFT MOUSE CLICK
565 IF %z=0 THEN dragLock = 0 
645 DRIVER 126,2,A,0
650 IF INKEY$ <> " " THEN GO TO 550
660  .uninstall /nextzxos/mouse.drv
670 STOP
680 DEFPROC init()
684 PROC installdriver()
790 SPRITE PRINT 0
800 LOAD "/savvas/MOUSE.SPR" BANK 10
820 SPRITE BANK 10
825 SPRITE 0,0,0,0,0
835 REM FOR s=0 TO 63
840 REM SPRITE s,0,0,0,0
845 REM NEXT s
846 SPRITE PRINT 1: SPRITE BORDER 1
850 ENDPROC
855 DEFPROC installdriver()
860 REM PRINT AT 2,0; "Reinstalling driver...": ON ERROR GO TO 870
862 ON ERROR GO TO 870
865  .uninstall /nextzxos/mouse.drv
870  .install /nextzxos/mouse.drv
875 ON ERROR
876 REM PRINT AT 2,0;"                          "
880 ENDPROC
890 STOP
900 REM ***********************************************On Mouse Click
910 IF dragLock=0 THEN GO TO 940
920 GO SUB 2000 : REM DRAGDROP
930 RETURN
940 IF xx < 66 OR xx > 577 THEN RETURN
950 IF yy < 32 OR yy > 206 THEN RETURN
960 newSel=o ( INT ((xx-64)/8)+1, INT ((yy-32)/8)+1): REM print at 16,0; "Selection:";newsel
970 REM PLOT %x-64,%y-32
980 REM PRINT AT 22,0;"Obj at x:"; INT ((xx-64)/8)+1;" y:"; INT ((yy-32)/8)+1;" Val:";newSel;"  "
990 IF newSel >0 And newSel <13 THEN menuSelect=newSel: GO SUB 9080: REM REFRESH HOME bttnS
1000 IF newSel=2 THEN SAVE "ZXOS.bas": PRINT AT 23,50;"File Saved": PAUSE 200: REM PRINT AT 23,50;"          "
1010 IF newsel=3 THEN GO SUB 7000: REM CREATE NEW FORM
1020 IF newsel=12 THEN GO SUB 6000 : REM CREATE NEW FORM
1100 IF newsel >12 THEN remx=xx:remy=yy:dragLock=1: REM INITIATE DRAG
1900 REM PRINT AT 18,0;"Active Form:";form;" ,bttn:";bttn
1990 RETURN
2000 REM **************DRAG AND DROP OBJECT*************************************************************
2001 REM IDENTIFY TYPE OF OBJECT TO PROCEED
2002 FOR l=1 TO form
2003 IF f(l,5)=newsel THEN d= l: GO TO 2010: REM FORM FOUND
2004 NEXT l
2005 FOR m=1 TO bttn
2006 IF b(m,5)=newsel THEN d=m: GO TO 2200: REM BUTTON FOUND
2007 NEXT m 
2008 RETURN
2010 REM MOVING A FORM
2015 REM Normally it should be done in two steps. MouseClick locks object. MouseMove with click down should drag the form to a new position.
2020 REM d= newsel -12
2060 PRINT AT f(d,2), f(d,1); OVER 1; f$(d)  :REM PRINT AT y,x
2070 OVER 1: PLOT f(d,1)*8,f(d,2)*8: DRAW f(d,3),0: DRAW 0,f(d,4): DRAW -f(d,3),0: DRAW 0,-f(d,4) : REM PLOT y,x
2080 PLOT f(d,1)*8,(f(d,2)*8)+7: DRAW f(d,3),0 : OVER 0
2100 charx= INT ((xx-remx)/8)
2110 chary= INT ((yy-remy)/8)
2130 f(d,1)= f(d,1)+ int(charx): REM x
2140 f(d,2)= f(d,2)+ int(chary): REM y
2150 GO SUB 7130
2170 remx=xx:remy=yy: REM DragLock =0
2180 RETURN
2190 REM MOVING A BUTTON ************************************************************
2205 PRINT AT b(d,2), b(d,1); OVER 1; b$(d) :REM PRINT AT y,x: pause 0
2210 OVER 1:PLOT (b(d,1)*8),(b(d,2)*8): DRAW b(d,3),0: DRAW 0,8: DRAW -b(d,3),0: DRAW 0,-8 : REM PLOT y,x
2230 charx= INT ((xx-remx)/8)
2240 chary= INT ((yy-remy)/8)
2250 b(d,1)= b(d,1)+ int(charx): REM x
2260 b(d,2)=b(d,2)+ INT (chary): REM y
2270 GO SUB 6070
2275 return
2280 PRINT AT b(d,2),b(d,1);b$(d)
2290 PLOT (b(d,1)*8),(b(d,2)*8): DRAW b(d,3),0: DRAW 0,8: DRAW -b(d,3),0: DRAW 0,-8
2300 PLOT b(d,1)*8,(b(d,2)*8): DRAW b(d,3),0
2310 REM assign only new object to screen map
2320 FOR h=1 TO LEN b$(d)
2330 o(h+b(d,1),b(d,2)+1)=newsel : REM Attention 1 was added to x because arrays cannot store 0 values as indices.
2340 NEXT h
2380 remx=xx:remy=yy: REM DragLock =0
2990 RETURN
3000 REM ***********************************************************************************************
6000 REM C R E A T E   B U T T O N ********************************************************************
6010 bttn=bttn+1: objindx = objindx +1 : d= bttn
6020 b$(bttn) = "Button "+ STR$ (bttn) + " F:"+ STR$(form)
6030 b(bttn,1)=f(form,1)+bttn+1: b(bttn,2)=f(form,2)+bttn: b(bttn,3)= LEN (b$(bttn))*8
6040 b(bttn,4)=form
6050 b(bttn,5)=objindx
6060 newsel = objindx
6070 For n= 1 to bttn
6080 OVER 0: PRINT AT b(n,2),b(n,1);b$(n)
6090 PLOT (b(n,1)*8),(b(n,2)*8): DRAW b(n,3),0: DRAW 0,8: DRAW -b(n,3),0: DRAW 0,-8
6100 Next n
6110 REM assign only new object to screen map
6120 FOR h=1 TO LEN b$(d)
6130 o(h+b(d,1),b(d,2)+1)=newsel : REM Attention 1 was added to x because arrays cannot store 0 values as indices. Remember to decrement x by 1 when using this array
6140 NEXT h
6145 remx=xx:remy=yy: REM DragLock =0
6150 RETURN
6999 REM **********************************************************************************************
7000 REM C R E A T E   F O R M : resemble style of starting ZX screen menu (with sinclair logo colours)
7010 REM ideally this code should be written in Assembly
7030 REM CONFIGURE NEW FORM
7040 form=form+1: REM PRINT AT 19,0;"Creating Form ";form
7045 objindx=objindx+1
7050 f(form,1)=2 + form : REM upper left horizontal coordinates y. Is it multpile of 8? (1-63)
7060 f(form,2)=2 + form: REM upper left vertical coordinates (1-23) x
7070 f(form,3)=240: REM form width
7080 f(form,4)=80: REM form height
7090 f(form,5)=objindx
7100 f$(form)="Form "+ STR$ (form)
7105 newsel = objindx
7110 REM Assign Object to Map (y,x)
7130 REM DRAW ALL FORMS IN APP
7140 FOR d=1 TO form
7150 PRINT OVER 0;AT f(d,2), f(d,1);f$(d)  :REM PRINT AT y,x
7160 PLOT OVER 0; f(d,1)*8,f(d,2)*8: DRAW f(d,3),0: DRAW 0,f(d,4): DRAW -f(d,3),0: DRAW 0,-f(d,4) : REM PLOT y,x
7170 PLOT OVER 0; f(d,1)*8,(f(d,2)*8)+7: DRAW f(d,3),0
7180 NEXT d
7190 REM UPDATE SCREEN MAP WITH COORDS OF NEW FORM
7200 FOR e=0 TO (f(form,3)/8)-2
7210 o (e+f(form,1),f(form,2)+1)= newsel
7220 REM PRINT AT f(form,2),f(form,1)+e;f(form,1)+e  : REM y,x
7230 NEXT e
7240 REM PRINT AT 19,0:;"                      "
7990 RETURN
7999 REM ****************************************************
9000 REM DRAW HOME MENU
9040 RESTORE 9100
9050 FOR a=1 TO 12
9060 READ a$,x,y: PRINT AT x,y; INVERSE (a=menuSelect);a$ : REM With Print At we make sure that Characters are aligned to the 23x64 map
9062 PLOT (y*8),(x*8): DRAW LEN (a$)*8,0: DRAW 0,8: DRAW - LEN (a$)*8,0: DRAW 0,-8
9063 REM Assign Full Area Covered by New Object to Map (array o)
9064 objindx=objindx+1
9065 FOR b=1 TO LEN a$
9067 o(y+b,x+1)=objindx : REM Attention 1 was added to x because arrays cannot store 0 values as indices. Remember to decrement x by 1 when using this array
9068 NEXT b
9070 NEXT a
9075 PLOT 0,0: DRAW 511,0: DRAW 0,175: DRAW -511,0: DRAW 0,-175
9079 RETURN
9080 REM REDRAW/REFRESH HOME MENU bttnS **********************
9081 RESTORE 9100
9082 FOR c=1 TO 12
9083 READ a$,x,y: PRINT AT x,y; INVERSE (c=menuSelect);a$
9084 PLOT (y*8),(x*8): DRAW LEN (a$)*8,0: DRAW 0,8: DRAW - LEN (a$)*8,0: DRAW 0,-8
9086 NEXT c
9087 PLOT 0,0: DRAW 511,0: DRAW 0,175: DRAW -511,0: DRAW 0,-175
9089 RETURN
9090 REM ;firstline lists customizable components
9099 REM Next line is for future use for rapid drawing in Assembly Language: Code reads parameters starting after the first REM following RANDOMIZE USR
9100 REM RANDOMIZE USR Drawbttn: REM 0,0,"Load",RedBorder,PinkPaper ; Drawbttn will be an assembly address with the Drawbttn Routine. On calling it it will read attributes of creating a bttn
9110 DATA "Load",0,0: REM For the BASIC Version we will simply use PRINT by reading data following line 520
9120 REM Drawbttn 0,5,"Save",RedBorder,PinkPaper
9130 DATA "Save",0,5
9140 REM Drawbttn 0,10,"Form",RedBorder,PinkPaper
9150 DATA "Form",0,10
9160 REM Drawbttn 0,14,"SMenu",RedBorder,PinkPaper : Attach form submenu
9170 DATA "SMenu",0,14
9180 REM Drawbttn 0,19,"Label",RedBorder,PinkPaper
9190 DATA "Label",0,19
9200 REM Drawbttn 0,24,"Text",RedBorder,PinkPaper
9210 DATA "Text",0,24
9220 REM Drawbttn 0,28,"List",RedBorder,PinkPaper : List box that loads values from array, table, or data file and stores selected value
9230 DATA "List",0,28
9240 REM Drawbttn 0,32,"DropDn",RedBorder,PinkPaper : Dropdown box  that loads values from array, table, or data file, storing selected value
9250 DATA "DropDn",0,32
9260 REM Drawbttn 0,38,"ImgBox",RedBorder,PinkPaper : Simple image box that loads Next Images (even better if it could convert from other types)
9270 DATA "ImgBox",0,38
9280 REM Drawbttn 0,44,"DataTabl",RedBorder,PinkPaper : REM Special form with autoIndex Key, empty records, and customizable fields for storing user's data
9290 DATA "DataTabl",0,44
9300 REM Drawbttn 0,52,"MemMap",RedBorder,PinkPaper : Special list of memory addresses and their PEEK values that allows editing memory locations, or copying whole areas of memories to another memory location. User may load more than one selecting specific slots and banks, so that he can copy, paste among them!
9310 DATA "MemMap",0,52
9320 REM Drawbttn 0,58,"bttn",RedBorder,PinkPaper
9330 DATA "Button",0,58
9340 REM Drawbttn 1,58 "Edit Code",RedBorder,PinkPaper : opens BASIC editor to write code for the objects (prerequisite is that the objects create their own subroutines upon action)
9350 DATA "Edit Code",1,58
9360 REM ;second line lists apps
9370 REM Drawbttn 1,0,"Calcu",RedBorder,PinkPaper : loads system calculator
9380 REM Drawbttn 1,5,"TimeD",RedBorder,PinkPaper : analog clock app with adjustment of system time and worldmap/location select capabilities
9390 REM Drawbttn 1,10,"Docum",RedBorder,PinkPaper : Simple typewriter app
9400 REM Drawbttn 1,15,"Sprea",RedBorder,PinkPaper : Simple spreadsheet app using data (array) files
9410 REM Drawbttn 1,20,"Slide",RedBorder,PinkPaper : Slideshow app for photos but also 'powerpoint'-like capabilities
9420 REM Drawbttn 1,25,"Games",RedBorder,PinkPaper : Popular Next Game Links, including RAMS arcades
9430 REM Drawbttn 1,30,"Assmb",RedBorder,PinkPaper : Simple Assembler
9440 REM Drawbttn 1,35,"Gphcs",RedBorder,PinkPaper : Sprite Creator
9450 REM Drawbttn 1,40,"Netwr",RedBorder,PinkPaper : Wifi connection
; PauseMod.asm - TVi
#align16
#data "UNLOCKS START"
#data 0x00
#align16
Jed_Unlocks_Main:
    mov.l @(Jed_Unlocks_Data01,PC),r0
    mov.l r0,@(0x30,r2)
    mov.l r0,@(0x38,r2)
    mov.l @(Jed_Unlocks_Data02,PC),r0
    mov.l r0,@(0x34,r2)
    mov.l r0,@(0x3c,r2)
    mov 0x51,r0
    add r0,r2
    mov 0x08,r0
    mov.b r0,@r2
    rts
    nop
    #align4_nop

Jed_Unlocks_Data01:
    #data 0xF8FFFFFF
Jed_Unlocks_Data02:
    #data 0x07FFFFFF

#align16
#data "REMATCH START"
#data 0x00
#align16

;      R0  00000074      R1  00000004      R2  8C2895F0      R3  8C0469C8
;      R4  8C2895F0      R5  8C287DDD      R6  8C287DDE      R7  00000001
;      R8  8C2681DC      R9  8C11D420     R10  8C0274B0     R11  8C2895F0
;     R12  8C0395AC     R13  8C26823C     R14  8C2896B0     R15  8C00F3D0
; loc_8c0469d4
rematchMenu_beginV2:
    mov.l @(rematch_P1_Flags_loc,PC),r0
    mov.b @r0,r0
    tst 0x08,r0
    bt normalCode_exit

; rematch is allowed
	mov.l r7,@-r15
	mov.l r6,@-r15
	mov.l r4,@-r15
	sts.l pr,@-r15
    nop

    ; p1 code
    ;-------------------------------------
    bsr rematchMenu_p1_inputRead
    nop 
    bsr rematchMenu_p1_textDisplay
    nop

    ; p2 code
    ;-------------------------------------
    bsr rematchMenu_p2_inputRead
    nop
    bsr rematchMenu_p2_textDisplay
    nop

    ; check if picked
    ;-------------------------------------
    bsr rematch_OptionReadingNonDraw
    nop

    ; if not picked (rts)
    ;-----------------------------------
    nop
    lds.l @r15+,PR
    nop
    bra rV2_dontEndMatch
    nop

rematch_OptionReadingNonDraw:
    ; start, check P1 flag
    mov.l @(rematch_P1_Flags_loc),r2  ; r2 -> rematch_P1_Flags
    mov.b @r2,r0
    extu.b r0,r0                     ; r2 = havePickedFlag
    tst 0x02,r0
    bf rematch_p1Picked_checkP2

    ; P1 hasnt picked
    ; we should keep running until both players have picked
    bra returnFromRematchReading
    nop

rematch_p1Picked_checkP2:
    mov.l @(rematch_P2_Flags_loc,PC),r1  ; r1 = rematch_P2_Flags
    mov.b @r1,r0
    extu.b r0,r0                     ; r2 = havePickedFlag
    tst 0x02,r0
    bf rematch_finishMatch

    ; we should keep running until both players have picked
    bra returnFromRematchReading
    nop

rematch_finishMatch:
    ; save player match data
    ;------------------------------------------------------------
    bsr rematch_setCharacterData
    nop

    ; clear row values
    ;------------------------------------------------------------
    mov.l @(ptr_p1_RowValue,PC),r2
    mov 0x00,r0
    extu.w r0,r0
    mov.w r0,@r2

    mov.l @(ptr_p2_RowValue,PC),r2
    mov.w r0,@r2
    
    ; check if both hit rematch
    mov.l @(rematch_P1_Flags_loc),r2  ; r2 -> rematch_P1_Flags
    mov.b @r2,r0
    extu.b r0,r1                     ; r2 = havePickedFlag

    mov.l @(rematch_P2_Flags_loc),r2  ; r2 -> rematch_P2_Flags
    mov.b @r2,r0
    and r1,r0
    tst 0x01,r0
    bt bothDidNotPickRematch

bothPickedRematch:
    mov 0x0D,r0
    extu.b r0,r0
    mov.l @(rematch_P1_Flags_loc),r2  ; r2 -> rematch_P1_Flags
    mov.b r0,@r2
    mov.l @(rematch_P2_Flags_loc),r2  ; r2 -> rematch_P2_Flags
    mov.b r0,@r2

bothDidNotPickRematch:
    ; prep r1 for reset of picks
    ;------------------------------------------------------------
    mov 0x0D,r1 ; 0b0000 1101
    extu.b r1,r1
    ; reset p1 flags [hasPicked, rowValuePicked] for p1
    ;------------------------------------------------------------
    mov.l @(rematch_P1_Flags_loc),r0  ; pointer to P1_Flags
    mov.b @r0,r2
    extu.b r2,r2
    and r1,r2
    mov.b r2,@r0

    ; reset p2 flags [hasPicked, rowValuePicked] for p2
    ;------------------------------------------------------------
    mov.l @(rematch_P2_Flags_loc),r0  ; pointer to P2_Flags
    mov.b @r0,r2
    extu.b r2,r2
    and r1,r2
    mov.b r2,@r0

    lds.l @r15+,pr
    nop
    mov.l @r15+,r4
	mov.l @r15+,r6
	mov.l @r15+,r7

normalCode_exit:
	mov 0x32,r0
	mov 0x00,r5
	mov.b r5,@(r0,r4)
	mov 0x31,r0
	mov.b r5,@(r0,r4)
	mov 0x30,r0
	mov.b r5,@(r0,r4)
	mov r5,r0
	nop
	mov.l @(GGP_PTR,PC),r1    
    mov.l @(rematch_endMatchNormalCode_ptr,PC),r3
    jmp @r3
	mov 09,r3
    bra normalCode_exit
    nop

returnFromRematchReading:
    nop
    rts
    nop

rV2_dontEndMatch:
    mov.l @r15+,r4
    mov.w @(0x12,r4),r0
    mov 0xFF,r0
    mov.w r0,@(0x12,r4)
	mov.l @r15+,r6
	mov.l @r15+,r7
    
    ; (rts)
    lds.l @r15+,pr
    nop
	rts
	nop
    #align4_nop

GGP_PTR:
	#data 0x8c26823c ; 0x8c26823c
rematch_endMatchNormalCode_ptr:
    #data pauseEditing_bank04.rematch_endMatchNormalCode    
ptr_p1_RowValue:
	#data rematchMenu_p1_rowValue
ptr_p2_RowValue:
	#data rematchMenu_p2_rowValue

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~





;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; DRAW GAME
; from loc_8c0468e0
; for games that end in DRAW
;-------------------------------------
rematchMenu_drawStart:
    mov.l @(rematch_P1_Flags_loc,PC),r0
    mov.b @r0,r0
    tst 0x08,r0
    bt rematchMenu_drawGame_normalCode

    bra rematchMenu_drawGame_crashTest
    mov 0x08,r3

rematchMenu_drawGame_normalCode:
	mov 0x09,r3
rematchMenu_drawGame_crashTest:
	mov.b r3,@r14
	mov 0x48,r0 
	mov.b @(r0,r14),r0
	extu.b r0,r0
	cmp/eq 0x08,r0
	bf rematchMenu_8c04690a_exit

    bra rematchMenu_8c0468ee_exit
    nop

rematchMenu_8c04690a_exit:
    mov.l @(rematchMenu_8c04690a_exitPtr,PC),r13
    jmp @r13
    nop

rematchMenu_8c0468ee_exit:
    mov.l @(rematchMenu_8c0468ee_exitPtr,PC),r3
    jmp @r3
    nop
    #align4_nop

rematch_P1_Flags_loc:
    #data 0x8C268887 ; 8c268340 + (547*1) + (5A4*0)
rematch_P2_Flags_loc:
    #data 0x8C268E2B  ; 8c268340 + (547*1) + (5A4*1)
rematchMenu_8c0468ee_exitPtr:
    #data pauseEditing_bank04.loc_8c0468ee
rematchMenu_8c04690a_exitPtr:
    #data pauseEditing_bank04.loc_8c04690a

;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
; P1 REMATCH CODE STARTS HERE
;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
rematchMenu_p1_textDisplay:
	mov.l r14,@-r15 ; prep
	mov.l r13,@-r15
	mov.l r12,@-r15
	mov.l r11,@-r15
	mov.l r10,@-r15
	mov.l r9,@-r15
	mov.l r8,@-r15
	sts.l pr,@-r15
	add 0xFC,r15

; NO IDEA, Some kind of color option select
; reading values
	; load main game pointer into r0
    mov.l @(rematch_p1Text_globalPointer,PC),r0
	mov.l @r0,r3                  ; load current game pointer into r3
	mov 0x2F,r0                   ; r0 = 0x2F
	mov.b @(r0,r3),r2             ; r2 = B@[0x8c268240 + 0x2F] = 0x00
	tst r2,r2                     ; r2 == 0 ?
	bt rematch_p1Text_color01     ; if r2 == 0, branch to rematch_p1Text_color00

	mov.l @(rematch_p1Text_colorOption00,PC),r14  ; if r2 != 0, load r14 with 0xff3f3f7f
	bra rematch_p1Text_someFunc
	nop

rematch_p1Text_color01:
	mov.l @(rematch_p1Text_colorOption01,PC),r14  ; if r2 == 0, load r14 with 0xff7f3f3f

rematch_p1Text_someFunc:
	mov.l @(rematch_p1Text_someFunction,PC),r3   ; loc_8c11c420
	mov r14,r5
	mov r14,r6
	jsr @r3
	mov r14,r4

;VVVVVVVVVVVVVVVVVVVVVVV
; Real Text Starts Here 
;VVVVVVVVVVVVVVVVVVVVVVV

	mov 0x00,r11 ; r11 = 0x00 , r11 (loopRow)
	mov 0x00,r13 ; r13 = 0x00 , r13 (displayRow)

; Header Text
;--------------------------------------------------------
    mov 0x02,r4 ; (xPos)
    mov 0x34,r5 ; (yPos)
    mov 0x34,r6 ; (colorID/fontID)
    mov.l @(ptr_rematchMenu_p1_headerText,PC),r2 ; Menu Header
	mov.l r2,@-r15              ; push ptr into STACK

    mov.l @(rematch_p1Text_textFunction,PC),r3 ; Text Function [r4: xpos, r5: ypos, r6: colorID/fontID]
	jsr @r3
	nop
    add 0x04,r15
0x8C268E8E
0x8C269602
0x8C268575
0x00 ; stage
0x01 ; stage
0x02 ; stage
0x03 ; stage
0x04 ; stage
0x05 ; stage
0x06 ; stage
0x07 ; stage
0x08 ; stage
0x09 ; stage
0x0A ; stage
0x0B ; stage
0x0C ; stage
0x0d ; stage
0x0E ; stage
0x0F ; stage
0x10 ; stage

; Row Start

;-------------------------------------------------    
rematchMenu_p1_rowTextStart:
	mov r13,r9   ; 
    mov r13,r10
    ; shll r10
	shll2 r9      ;
    add r10,r9
	add 0x3A,r9  ; TopSpacing
    ; r9 (yPos)  = (2 * displayRow) + TopSpacing

    exts.b r11,r10  ; r10 (loopRow)
    ; shll2 r10, originally (itemsB4CurrentRow) since loopRow * 4 items/row
	
    mov 0x00,r14
    ; r14 (loopColumn) = 0x00
; Column Start
;-------------------------------------------------    
rematchMenu_p1_columnTextStart:
    ; push colorID to STACK
	mov 0x12,r3    ; non cursor fontID/colorID
	mov.b r3,@r15  ; r3 into STACK

    ; since current max of string size is 16, offset by maxStringSize
    mov r14,r8                    ; r8 (xPos) = r14 (loopColumn)
	shll2 r8                      ; r8 (xPos) = 4 * loopColumn
	shll2 r8                      ; r8 (xPos) = 16 * loopColumn 
    add 0x02,r8


; load cursorColumn
; ----------------------------------------------------------
    mov.l @(ptr_p1ColValue,PC),r2  ; r2 -> cursorColumn
	mov.b @r2,r3                   ; r3 = cursorColumn
    ; r3 (cursorColumn)

    ; compare cursorColumn and loopColumn
    ; ----------------------------------------------------------
    exts.b r14,r12             ; r12 = r14 (loopColumn)
	cmp/eq r3,r12              ; r3 (cursorColumn) == r12 (loopColumn) ?
	bf rematch_p1Text_CheckPicked  ; if r3 (cursorColumn) != r12 (loopColumn), text only no cursor


; load cursorRow
; ----------------------------------------------------------
    ; if r3 (cursorColumn) == r12 (loopColumn), check row
	mov.l @(ptr_p1RowValue,PC),r0  ; r0 -> cursorRow
	mov.b @r0,r3                   ; r3 = cursorRow

    ; compare cursorRow and loopRow
    ; ----------------------------------------------------------
	exts.b r11,r1                  ; r1 = r11 (loopRow)
	cmp/eq r3,r1                   ; r3 (cursorRow) == r1 (loopRow) ?
	bf rematch_p1Text_CheckPicked      ; if r3 (cursorRow) != r1 (loopRow), text only no cursor

; if (cursorRow == loopRow) and (hasPicked == 1):
; ----------------------------------------------------------
    mov.l @(ptr_rematch_p1_Flags,PC),r0
    mov.b @r0,r0
    tst 0x02,r0
    bf rematchMenu_p1Text_prepCursorText ; have picked, show cursor text but not cursor

; show cursor
; ----------------------------------------------------------
    ; print cursor on curRow and curColm
    ; r8 (xPos), r9 (yPos), r6 (colorID/fontID)
	mov r8,r4                   ; r4: xPos
    bsr rematchMenu_p1_checkIfPickedSubroutine
    mov r9,r5                   ; r5: yPos
    mov r0,r6                   ; r6: colorID/fontID

	mov.l @(rematch_p1Text_cursorStringLoc,PC),r2 ; ">"
	mov.l r2,@-r15              ; push ">" ptr into STACK

    mov.l @(rematch_p1Text_textFunction,PC),r3 ; Text Function [r4: xpos, r5: ypos, r6: colorID/fontID]
	jsr @r3
	nop
    
    add 0x04,r15
    
rematchMenu_p1Text_prepCursorText:
    bsr rematchMenu_p1_checkIfPickedSubroutine
	nop

    bra rematchMenu_p1MainText
    mov.b r0,@r15

rematch_p1Text_CheckPicked:
    mov.l @(ptr_rematch_p1_Flags,PC),r0
    mov.b @r0,r0
    tst 0x02,r0
    bf rematchMenu_p1Text_incrCol ; have picked, no text

; show text
; ----------------------------------------------------------
rematchMenu_p1MainText:
; load string for current loopRow and loopColumn
; ----------------------------------------------------------
    mov.l @(ptr_p1_textItems,PC),r2 ; r2 = tableStart = rematchMenu_textItems
    mov r12,r3  ; r3 = loopColumn
	add r10,r3  ; r3 = itemsB4Row + loopColumn
	shll2 r3    
	shll2 r3
    ; r3 (desired string offset)
	add r3,r2       ; add r3 (desired string offset) to r2 (string table start)
	mov.l r2,@-r15  ; push string location to STACK

	mov r12,r1  ; r1 = loopColumn
	add r10,r1  ; r1 = itemsB4Row + loopColumn

    ; mov.l @(ptr_rematch_p1_Flags,PC),r0  ; r0 -> p1_flags_start
	; mov.b @(r0,r1),r3                    ; r3 = B@[p1_flags_start + itemOffset]
	; mov.l r3,@-r15                       ; push flag value into STACK

    mov.l @(rematch_p1Text_justString,PC),r2 ; "%s", r2 -> string loc
    ; mov.l @(rematch_p1Text_valueString,PC),r2 ; "%1d %s", r2 -> string loc
	mov.l r2,@-r15              ; push string into STACK

    ; load colorID from STACK
	mov.b @(0x8,r15),r0
	mov r0,r6

	mov r8,r4  ; r4 (xPos)
	mov r9,r5  ; r5 (yPos)
	mov.l @(rematch_p1Text_textFunction,PC),r3 ; Text Function [r4: xpos, r5: ypos, r6: colorID]
	jsr @r3
	add 0x04,r4  ; LeftSpacing for Main Text

    add 0x08,r15

rematchMenu_p1Text_incrCol:
    ; move to next colm
    ; ----------------------------------------------------------
	add 0x01,r14        ; increment r14 (loopColumn)
	mov 0x01,r3         ; r3 (maxColumn)
	exts.b r14,r2       ; r2 = r14 (loopColumn)
	cmp/ge r3,r2        ; r2 (loopColumn) >= r3 (maxColumn) ?
	bf rematchMenu_p1_columnTextStart  ; if not reached maxColumn, write on column
	
    ; maxColumn reached
    ; ----------------------------------------------------------
    add 0x01,r11        ; increment r11 (loopRow)
    add 0x01,r13        ; increment r13 (displayRow)
    ; check display row 8
	; exts.b r13,r0       ; r0 = r13 (displayRow)
	; cmp/eq 0x08,r0      ; r0 (displayRow) == 0x08 ?
	; bf rematchMenu_p1Text_checkDRow ; if r0 (displayRow) != 0x08, check if higher

	; if r0 == 0x08, add row gap
    ; ----------------------------------------------------------
	; add 0x01,r13        ; increment r13 (displayRow)

rematchMenu_p1Text_checkDRow:
	; exts.b r13,r0       ; r0 = r13 (displayRow)
	; cmp/eq 0x0D,r0      ; r0 (displayRow) == 0x0D ?
	; bf rematchMenu_p1Text_checkMaxRow ; if r0 (displayRow) != 0x08, check if higher

	; if r0 == 0x0D, add row gap
	; add 0x01,r13        ; increment r13 (displayRow)

rematchMenu_p1Text_checkMaxRow:
	mov 0x02,r3         ; r3 = 0x02 (maxRows)
	exts.b r11,r2       ; r2 = r11 (loopRow)
	cmp/ge r3,r2        ; r2 (loopRow) >= r3 (maxRows) ? 
	bf rematchMenu_p1_rowTextStart ; if not reached maxRows, start next row

    ; max row and max column reached
	; exit
	add 0x04,r15
	lds.l @r15+,pr
	mov.l @r15+,r8
	mov.l @r15+,r9
	mov.l @r15+,r10
	mov.l @r15+,r11
	mov.l @r15+,r12
	mov.l @r15+,r13
	rts
	mov.l @r15+,r14

rematchMenu_p1_checkIfPickedSubroutine:
    ; change color if already picked
    mov.l @(ptr_rematch_p1_Flags,PC),r0
    mov.b @r0,r0
    tst 0x02,r0
    bf rematchMenu_p1_alreadyPickedColor
    rts
	mov 0x35,r0 ; not picked

rematchMenu_p1_alreadyPickedColor:
    rts
    mov 0x13,r0 ; picked
    #align4_nop
;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

rematchMenu_p1_rowValue:
    #data 0x0000
rematchMenu_p1_colValue:
    #data 0x0000  
    #align4

ptr_rematch_p1_Flags:
    #data 0x8C268887 ; 8c268340 + (547*1) + (5A4*0)
;	#data 0x8c13fb90	; new, devMenu_byteFlagArray_locStart, 
					 	; uses NaomiDebugFont area
	; #data 0x8c2896b4  ; original devMenu_byteFlagArray_locStart
rematch_p1Text_globalPointer:
	#data 0x8c26823c ; 0x8c26823c
rematch_p1Text_colorOption00:
	#data 0xff3f3f7f
rematch_p1Text_colorOption01:
	#data 0xff7f3f3f
rematch_p1Text_someFunction:
	#data pauseEditing_bank11.loc_8c11c420
ptr_p1RowValue:
	#data rematchMenu_p1_rowValue
ptr_p1ColValue:
	#data rematchMenu_p1_colValue
rematch_p1Text_cursorStringLoc:
	#data pauseEditing_bank13.loc_8c136990 ; ">"
rematch_p1Text_textFunction:
	#data pauseEditing_bank03.loc_8c0395c6
	; Text Function [r4: xpos, r5: ypos, r6: colorID]
ptr_p1_textItems:
	#data rematchMenu_textItems ; rematchMenu_textItems
ptr_rematchMenu_p1_headerText:
    #data rematchMenu_headerText
;rematch_p1Text_valueString:
;	#data pauseEditing_bank13.loc_8c136994   ; "%1d %s"
rematch_p1Text_justString:
    #data pauseEditing_bank13.loc_8c13ecc8  ; "%s"

;==============================================
rematchMenu_p1_inputRead:
	sts.l pr,@-r15 ; prep
	add 0xF0,r15

    mov.l @(rematch_p1Input_Flags_loc,PC),r0 ; r0 -> auto pick byte (APB)
    mov.b @r0,r0
    extu.b r0,r0
    tst 0x02,r0
    bf rematch_p1Input_exit ; if already picked, stop polling input

    ; if havent picked yet, continue polling input
	mov.l @(rematch_p1Input_inputMem,PC),r4
	
	; r5 (p1_inputMem)
	mov r4,r5
	mov.w @(0x4,r5),r0
	extu.w r0,r3

	mov.w @(0x10,r5),r0
	extu.w r0,r0
	or r0,r3

	mov.w @(rematch_p1input_Up,PC),r2     ; 0x2000 (up)
	mov.l @(rematch_p1rowValue_loc,PC),r6   ; r6 = rematch_p1_rowValue

	tst r2,r3
	bt.s rematchMenu_p1Input_Down
	mov r4,r5                     ; r5 = 0x8c2681dc , p1_inputMem

    ; if up was pressed
	mov.b @r6,r0   ; load value
    exts.b r0,r0
    cmp/eq 0x00,r0
    bt rematchMenu_p1Input_Down
	add 0xFF,r0    ; decrement rematchMenu_p1_rowValue ; row value
	mov.b r0,@r6   ; save changes

rematchMenu_p1Input_Down:
	mov r4,r3
	mov.w @(0x4,r3),r0
	mov.l r3,@(0x8,r15)
	extu.w r0,r2
	
	; r3 p1
	mov.l @(0x8,r15),r3
	mov.w @(0x10,r3),r0
	extu.w r0,r0
	or r0,r2

	mov.w @(rematch_p1Input_Down,PC),r3  ; #data 0x1000 (down)
	tst r3,r2
	bt rematch_p1_rowFilter

	mov.b @r6,r0   ; load value
    tst 0x01,r0    ; check if at bottom
    bf rematch_p1_rowFilter
	add 0x01,r0    ; increment rematchMenu_p2_rowValue ; row value
	mov.b r0,@r6   ; save changes

rematch_p1_rowFilter:
	mov.b @r6,r0
	and 0x01,r0
	mov.b r0,@r6

rematch_p1Input_A:
    mov.w @(0x4,r4),r0
    mov.w @(rematch_p1Input_bttnV_Start,PC),r3
	extu.w r0,r0
    extu.w r3,r3
	tst r3,r0
	bt rematch_p1Input_exit

	; if "A" was pressed, write value
	mov.b @r6,r3       ; r3 = rowValue
    
    mov.l @(rematch_p1Input_Flags_loc,PC),r0
    mov 0x01,r4
    xor r4,r3
    add 0x0A,r3
    mov.b r3,@r0 ; set rowValuePicked to rowValue

rematch_p1Input_exit:
	add 0x10,r15
	lds.l @r15+,pr
	rts
	nop
    #align4_nop

;##############################################
rematch_p1Input_Up:
	#data 0x2000 ; Up
rematch_p1Input_Down:
	#data 0x1000 ; Down
rematch_p1Input_bttnV_Start:
	#data 0x8090 ; Start    
	#align4

rematch_p1Input_inputMem:
	#data 0x8c2681dc  ; p1_inputMem
rematch_p1Input_Flags_loc:
    #data 0x8C268887 ; 8c268340 + (547*1) + (5A4*0)
rematch_p1rowValue_loc:
	#data rematchMenu_p1_rowValue  ; row value


;VVVVVVVVVVVVVVVVVVVVVVV
; P2 REMATCH CODE START
;VVVVVVVVVVVVVVVVVVVVVVV
rematchMenu_p2_textDisplay:
	mov.l r14,@-r15 ; prep
	mov.l r13,@-r15
	mov.l r12,@-r15
	mov.l r11,@-r15
	mov.l r10,@-r15
	mov.l r9,@-r15
	mov.l r8,@-r15
	sts.l pr,@-r15
	add 0xFC,r15

; NO IDEA, Some kind of color option select
; reading values
	; load main game pointer into r0
    mov.l @(rematch_p2Text_globalPointer,PC),r0
	mov.l @r0,r3                  ; load current game pointer into r3
	mov 0x2F,r0                   ; r0 = 0x2F
	mov.b @(r0,r3),r2             ; r2 = B@[0x8c268240 + 0x2F] = 0x00
	tst r2,r2                     ; r2 == 0 ?
	bt rematch_p2Text_color01     ; if r2 == 0, branch to rematch_p2Text_color00

	mov.l @(rematch_p2Text_colorOption00,PC),r14  ; if r2 != 0, load r14 with 0xff3f3f7f
	bra rematch_p2Text_someFunc
	nop

rematch_p2Text_color01:
	mov.l @(rematch_p2Text_colorOption01,PC),r14  ; if r2 == 0, load r14 with 0xff7f3f3f

rematch_p2Text_someFunc:
	mov.l @(rematch_p2Text_someFunction,PC),r3   ; loc_8c11c420
	mov r14,r5
	mov r14,r6
	jsr @r3
	mov r14,r4

;VVVVVVVVVVVVVVVVVVVVVVV
; Real Text Starts Here 
;VVVVVVVVVVVVVVVVVVVVVVV

	mov 0x00,r11 ; r11 = 0x00 , r11 (loopRow)
	mov 0x00,r13 ; r13 = 0x00 , r13 (displayRow)

; Header Text
;--------------------------------------------------------
    mov 0x6E,r4 ; (xPos)
    mov 0x34,r5 ; (yPos)
    mov 0x34,r6 ; (colorID/fontID)
    mov.l @(ptr_rematchMenu_p2_headerText,PC),r2 ; Menu Header
	mov.l r2,@-r15              ; push ptr into STACK

    mov.l @(rematch_p2Text_textFunction,PC),r3 ; Text Function [r4: xpos, r5: ypos, r6: colorID/fontID]
	jsr @r3
	nop
    add 0x04,r15

; Row Start
;-------------------------------------------------   
rematchMenu_p2_rowTextStart:
	mov r13,r9   ; 
    mov r13,r10
    ; shll r10
	shll2 r9      ;
    add r10,r9
	add 0x3A,r9  ; TopSpacing
    ; r9 (yPos)  = (2 * displayRow) + TopSpacing

    exts.b r11,r10  ; r10 (loopRow)
    ; shll2 r10, originally (itemsB4CurrentRow) since loopRow * 4 items/row
	
    mov 0x00,r14
    ; r14 (loopColumn) = 0x00

rematchMenu_p2_columnTextStart:
    ; push colorID to STACK
	mov 0x12,r3    ; non cursor fontID/colorID
	mov.b r3,@r15  ; r3 into STACK

    ; since current max of string size is 16, offset by maxStringSize
    mov r14,r8                    ; r8 (xPos) = r14 (loopColumn)
	shll2 r8                      ; r8 (xPos) = 4 * loopColumn
	shll2 r8                      ; r8 (xPos) = 16 * loopColumn 
    add 0x6E,r8


; load cursorColumn
; ----------------------------------------------------------
    mov.l @(ptr_p2ColValue,PC),r2  ; r2 -> cursorColumn
	mov.b @r2,r3                   ; r3 = cursorColumn
    ; r3 (cursorColumn)

    ; compare cursorColumn and loopColumn
    ; ----------------------------------------------------------
    exts.b r14,r12             ; r12 = r14 (loopColumn)
	cmp/eq r3,r12              ; r3 (cursorColumn) == r12 (loopColumn) ?
	bf rematch_p2Text_CheckPicked  ; if r3 (cursorColumn) != r12 (loopColumn), text only no cursor


; load cursorRow
; ----------------------------------------------------------
    ; if r3 (cursorColumn) == r12 (loopColumn), check row
	mov.l @(ptr_p2RowValue,PC),r0  ; r0 -> cursorRow
	mov.b @r0,r3                   ; r3 = cursorRow

    ; compare cursorRow and loopRow
    ; ----------------------------------------------------------
	exts.b r11,r1                  ; r1 = r11 (loopRow)
	cmp/eq r3,r1                   ; r3 (cursorRow) == r1 (loopRow) ?
	bf rematch_p2Text_CheckPicked      ; if r3 (cursorRow) != r1 (loopRow), text only no cursor

; if (cursorRow == loopRow) and (hasPicked == 1):
; ----------------------------------------------------------
    mov.l @(ptr_rematch_p2_Flags,PC),r0
    mov.b @r0,r0
    tst 0x02,r0
    bf rematchMenu_p2Text_prepCursorText ; have picked, show cursor text but not cursor

; show cursor
; ----------------------------------------------------------
    ; print cursor on curRow and curColm
    ; r8 (xPos), r9 (yPos), r6 (colorID/fontID)
	mov r8,r4                   ; r4: xPos
    bsr rematchMenu_p2_checkIfPickedSubroutine
    mov r9,r5                   ; r5: yPos
    mov r0,r6                   ; r6: colorID/fontID

	mov.l @(rematch_p2Text_cursorStringLoc,PC),r2 ; ">"
	mov.l r2,@-r15              ; push ">" ptr into STACK

    mov.l @(rematch_p2Text_textFunction,PC),r3 ; Text Function [r4: xpos, r5: ypos, r6: colorID/fontID]
	jsr @r3
	nop
    
    add 0x04,r15
    
rematchMenu_p2Text_prepCursorText:
    bsr rematchMenu_p2_checkIfPickedSubroutine
	nop

    bra rematchMenu_p2MainText
    mov.b r0,@r15

rematch_p2Text_CheckPicked:
    mov.l @(ptr_rematch_p2_Flags,PC),r0
    mov.b @r0,r0
    tst 0x02,r0
    bf rematchMenu_p2Text_incrCol ; have picked, no text

; show text
; ----------------------------------------------------------
rematchMenu_p2MainText:
; load string for current loopRow and loopColumn
; ----------------------------------------------------------
    mov.l @(ptr_p2_textItems,PC),r2 ; r2 = tableStart = rematchMenu_textItems
    mov r12,r3  ; r3 = loopColumn
	add r10,r3  ; r3 = itemsB4Row + loopColumn
	shll2 r3    
	shll2 r3
    ; r3 (desired string offset)
	add r3,r2       ; add r3 (desired string offset) to r2 (string table start)
	mov.l r2,@-r15  ; push string location to STACK

	mov r12,r1  ; r1 = loopColumn
	add r10,r1  ; r1 = itemsB4Row + loopColumn

    ; mov.l @(ptr_rematch_p2_Flags,PC),r0  ; r0 -> p2_flags_start
	; mov.b @(r0,r1),r3                    ; r3 = B@[p2_flags_start + itemOffset]
	; mov.l r3,@-r15                       ; push flag value into STACK

    mov.l @(rematch_p2Text_justString,PC),r2 ; "%s", r2 -> string loc
    ; mov.l @(rematch_p2Text_valueString,PC),r2 ; "%1d %s", r2 -> string loc
	mov.l r2,@-r15              ; push string into STACK

    ; load colorID from STACK
	mov.b @(0x8,r15),r0
	mov r0,r6

	mov r8,r4  ; r4 (xPos)
	mov r9,r5  ; r5 (yPos)
    
	mov.l @(rematch_p2Text_textFunction,PC),r3 ; Text Function [r4: xpos, r5: ypos, r6: colorID]
	jsr @r3
	add 0x04,r4  ; LeftSpacing for Main Text

    add 0x08,r15

rematchMenu_p2Text_incrCol:
    ; move to next colm
    ; ----------------------------------------------------------
	add 0x01,r14        ; increment r14 (loopColumn)
	mov 0x01,r3         ; r3 (maxColumn)
	exts.b r14,r2       ; r2 = r14 (loopColumn)
	cmp/ge r3,r2        ; r2 (loopColumn) >= r3 (maxColumn) ?
	bf rematchMenu_p2_columnTextStart  ; if not reached maxColumn, write on column
	
    ; maxColumn reached
    ; ----------------------------------------------------------
    add 0x01,r11        ; increment r11 (loopRow)
    add 0x01,r13        ; increment r13 (displayRow)
    ; check display row 8
	; exts.b r13,r0       ; r0 = r13 (displayRow)
	; cmp/eq 0x08,r0      ; r0 (displayRow) == 0x08 ?
	; bf rematchMenu_p2Text_checkDRow ; if r0 (displayRow) != 0x08, check if higher

	; if r0 == 0x08, add row gap
    ; ----------------------------------------------------------
	; add 0x01,r13        ; increment r13 (displayRow)

rematchMenu_p2Text_checkDRow:
	; exts.b r13,r0       ; r0 = r13 (displayRow)
	; cmp/eq 0x0D,r0      ; r0 (displayRow) == 0x0D ?
	; bf rematchMenu_p2Text_checkMaxRow ; if r0 (displayRow) != 0x08, check if higher

	; if r0 == 0x0D, add row gap
	; add 0x01,r13        ; increment r13 (displayRow)

rematchMenu_p2Text_checkMaxRow:
	mov 0x02,r3         ; r3 = 0x02 (maxRows)
	exts.b r11,r2       ; r2 = r11 (loopRow)
	cmp/ge r3,r2        ; r2 (loopRow) >= r3 (maxRows) ? 
	bf rematchMenu_p2_rowTextStart ; if not reached maxRows, start next row

    ; max row and max column reached
	; exit
	add 0x04,r15
	lds.l @r15+,pr
	mov.l @r15+,r8
	mov.l @r15+,r9
	mov.l @r15+,r10
	mov.l @r15+,r11
	mov.l @r15+,r12
	mov.l @r15+,r13
	rts
	mov.l @r15+,r14

rematchMenu_p2_checkIfPickedSubroutine:
    ; change color if already picked
    mov.l @(ptr_rematch_p2_Flags,PC),r0
    mov.b @r0,r0
    tst 0x02,r0
    bf rematchMenu_p2_alreadyPickedColor
    rts
	mov 0x35,r0 ; not picked

rematchMenu_p2_alreadyPickedColor:
    rts
    mov 0x13,r0 ; picked
    #align4_nop
;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

rematchMenu_p2_rowValue:
    #data 0x0000
rematchMenu_p2_colValue:
    #data 0x0000  
    #align4

ptr_rematch_p2_Flags:
    #data 0x8C268E2B  ; 8c268340 + (547*1) + (5A4*1)
rematch_p2Text_globalPointer:
	#data 0x8c26823c ; 0x8c26823c
rematch_p2Text_colorOption00:
	#data 0xff3f3f7f
rematch_p2Text_colorOption01:
	#data 0xff7f3f3f
rematch_p2Text_someFunction:
	#data pauseEditing_bank11.loc_8c11c420
ptr_p2RowValue:
	#data rematchMenu_p2_rowValue
ptr_p2ColValue:
	#data rematchMenu_p2_colValue
rematch_p2Text_cursorStringLoc:
	#data pauseEditing_bank13.loc_8c136990 ; ">"
rematch_p2Text_textFunction:
	#data pauseEditing_bank03.loc_8c0395c6
	; Text Function [r4: xpos, r5: ypos, r6: colorID]
ptr_p2_textItems:
	#data rematchMenu_textItems ; rematchMenu_textItems
ptr_rematchMenu_p2_headerText:
    #data rematchMenu_headerText    
;rematch_p2Text_valueString:
;	#data pauseEditing_bank13.loc_8c136994   ; "%1d %s"
rematch_p2Text_justString:
    #data pauseEditing_bank13.loc_8c13ecc8  ; "%s"

;==============================================
rematchMenu_p2_inputRead:
	sts.l pr,@-r15 ; prep
	add 0xF0,r15

    mov.l @(rematch_p2Input_Flags_loc,PC),r0  ; r0 -> hasPicked
    mov.b @r0,r0
    tst 0x02,r0
    bf rematch_p2Input_exit ; if already picked, stop polling input

    ; if havent picked yet, continue polling input

	mov.l @(rematch_p2Input_inputMem,PC),r4
	
	; r5 (p2_inputMem)
	mov r4,r5
	mov.w @(0x4,r5),r0
	extu.w r0,r3

	mov.w @(0x10,r5),r0
	extu.w r0,r0
	or r0,r3

	mov.w @(rematch_p2input_Up,PC),r2     ; 0x2000 (up)
	mov.l @(rematch_p2rowValue_loc,PC),r6   ; r6 = rematch_p2_rowValue

	tst r2,r3
	bt.s rematchMenu_p2Input_Down
	mov r4,r5                     ; r5 = 0x8c2681dc , p2_inputMem

    ; if up was pressed
	mov.b @r6,r0   ; load value
    exts.b r0,r0
    cmp/eq 0x00,r0
    bt rematchMenu_p2Input_Down
    
	add 0xFF,r0    ; decrement rematchMenu_p2_rowValue ; row value
	mov.b r0,@r6   ; save changes

rematchMenu_p2Input_Down:
	mov r4,r3
	mov.w @(0x4,r3),r0
	mov.l r3,@(0x8,r15)
	extu.w r0,r2
	
	; r3 p2
	mov.l @(0x8,r15),r3
	mov.w @(0x10,r3),r0
	extu.w r0,r0
	or r0,r2

	mov.w @(rematch_p2Input_Down,PC),r3  ; #data 0x1000 (down)
	tst r3,r2
	bt rematch_p2_rowFilter

    ; if down was pressed
	mov.b @r6,r0   ; load value
    tst 0x01,r0    ; check if at bottom
    bf rematch_p2_rowFilter
	add 0x01,r0    ; increment rematchMenu_p2_rowValue ; row value
	mov.b r0,@r6   ; save changes

rematch_p2_rowFilter:
	mov.b @r6,r0
	and 0x01,r0
	mov.b r0,@r6

rematch_p2InputCheck_A:
    mov.w @(0x4,r4),r0
    mov.w @(rematch_p2Input_bttnV_Start,PC),r3
	extu.w r0,r0
    extu.w r3,r3
	tst r3,r0
	bt rematch_p2Input_exit

	; if "A" was pressed, write value
	mov.b @r6,r3       ; r3 = rowValue
    mov.l @(rematch_p2Input_Flags_loc,PC),r0
    mov 0x01,r4
    xor r4,r3
    add 0x0A,r3
    mov.b r3,@r0 ; set rowValuePicked to rowValue


rematch_p2Input_exit:
	add 0x10,r15
	lds.l @r15+,pr
	rts
	nop
    #align4_nop

;##############################################
rematch_p2Input_Up:
	#data 0x2000 ; Up
rematch_p2Input_Down:
	#data 0x1000 ; Down
rematch_p2Input_bttnV_Start:
    #data 0x8090
	#align4

rematch_p2Input_inputMem:
	#data 0x8C2681F0  ; p2_inputMem
rematch_p2Input_Flags_loc:
    #data 0x8C268E2B  ; 8c268340 + (547*1) + (5A4*1)
rematch_p2rowValue_loc:
	#data rematchMenu_p2_rowValue  ; row value
    #align4

;-------------------------------------------------------------------------
; bankbank_APC00
; from loc_8c03b4aa
; use r0 to leave
; auto char pick
;-------------------------------------------------------------------------
AutoPickCheck_00:
; Original Code
    mov.w @(APC_Data0524,PC),r0
    mov.b @(r0,r14),r0
    shll r0
    mov.w @(r0,r11),r3
    extu.w r3,r3

; Custom Code

    mov.w @(APC_ButtonMaskXYABLR,PC),r2    ; 12 Color
;    mov.w @(APC_ButtonMaskXYAB,PC),r2       ; 16 Color
    mov.w @(APC_autoPickByte_offset,pc),r0
    mov.b @(r0,r14),r0
    tst 0x01,r0 ; is autopick off?
    bt bankbank_APC00_AP_Off

bankbank_APC00_AP_On:
    mov.l @(bankbank_APC00_LeaveOn,pc),r0
    jmp @r0
    nop

bankbank_APC00_AP_Off:
    mov.l @(bankbank_APC00_LeaveOff,pc),r0
    jmp @r0
    nop


;-------------------------------------------------------------------------
; bankbank_APC01
; from loc_8c03b6c8
; auto pick assist
;-------------------------------------------------------------------------
bankbank_AutoPickCheck01:
    mov r0,r3
    mov.w @(APC_autoPickByte_offset,pc),r0
    mov.b @(r0,r14),r0
    tst 0x01,r0 ; is autopick off?
    bf bankbank_APC01_PickAssist

APC01_normalRoute:
; OriginalCode
    mov r3,r0 
    shll r0                              ; 8c03b6c8
    mov.w @(APC_ButtonMaskXYABLR,PC),r2 ; 8c03b6ca
    mov.w @(r0,r9),r3
    extu.w r3,r3
    tst r2,r3
    bf bankbank_APC01_PickAssist         ; changed from bt at 8c03b6d2

; No Input, No Pick
    mov.l @(bankbank_APC01_LeaveNoPick,pc),r9
    jmp @r9
    nop

bankbank_APC01_PickAssist:
    mov.l @(bankbank_APC01_LeavePickAssist,pc),r0
    jmp @r0
    nop
    #align4_nop

;-----------------------------------------------------
; from loc_8c03b592
; Auto Pick Check 02
; load palettes
;-----------------------------------------------------
AutoPickCheck02:
    mov r0,r8
    mov.w @(APC_autoPickByte_offset,pc),r0
    mov.b @(r0,r14),r0
    tst 0x01,r0 ; is autopick off?
    bt APC02_DefaultCode

APC02_AP_On:
; check chrSlot for which paletteID
    mov r3,r0   ; r0 = plXmem + 0x052d [X:A,B,C,D,E]
    mov.w @(APC_paletteID_offset,PC),r9
    sub r9,r0   ; r0 = plXmem [X:A,B,C,D,E]
	mov.w @(APC_chrSlotID_offset,PC),r9
    add r0,r9   ; r9 -> chrSlot
	mov.b @r9,r0 ; r0 is now chrSlot
    shlr r0

;if p2
    mov.l @(APC_p2_paletteIDPicksLoc,PC),r9
    bt writeSavedPaletteID

; if p1
    mov.l @(APC_p1_paletteIDPicksLoc,PC),r9

writeSavedPaletteID:
    add r0,r9     ; offset by chrSlot
    mov.b @r9,r9  ; load saved paletteID
    mov.b r9,@r3

APC02_DefaultCode:
    mov r8,r0
	lds.l @r15+,pr
	mov.l @r15+,r8
	mov.l @r15+,r9
	mov.l @r15+,r10
	mov.l @r15+,r11
	mov.l @r15+,r12
	mov.l @r15+,r13
	rts
	mov.l @r15+,r14

;-------------------------------------------------------------------------
; bankbank_APC03
; from loc_8c03b5c8
; speed up, dont wait for assit pick to move portrait
;-------------------------------------------------------------------------
APC03_Start:
    mov.w @(APC_autoPickByte_offset,pc),r0
    mov.b @(r0,r14),r0
    tst 0x01,r0 ; is autopick off?
    bf APC03_8c03b5d8_Exit              ; if no bit set, execute normal route

APC03_normalRoute:
	mov.w @(APC_Data0524,PC),r0
	mov.b @(r0,r14),r0
	mov.b @(r0,r13),r0
	extu.b r0,r0
	cmp/eq 0x02,r0
	bt APC03_8c03b5d8_Exit

    mov.l @(APC03_8c03b77c_exitPtr,PC),r0
    jmp @r0
    nop

APC03_8c03b5d8_Exit:
    mov.l @(APC03_8c03b5d8_exitPtr,PC),r0
    jmp @r0
    nop

;-------------------------------------------------------------------------
; APC04
; from loc_8c03abe0
; auto pick stage if both hit rematch
;-------------------------------------------------------------------------
APC04_StageSelect_Start:
    mov.w @(APC_autoPickByte_offset,pc),r0
    mov.b @(r0,r14),r0
    tst 0x04,r0 ; did both set autopick?
    bf APC04_AutoPickStage

APC04_StageSelect_normalCode:
    mov.w @(APC_Data0524,PC),r0
	mov.b @(r0,r14),r0
	shll r0
	mov.w @(r0,r12),r3
    extu.w r3,r3

	mov.l @(APC04_StateSelect_ReturnLoc,PC),r2
    jmp @r2
    nop
    ; mov.w @(APC_ButtonMaskXYAB,PC),r2


APC04_AutoPickStage:
    mov 0x03,r0
	mov.b r0,@(0x3,r6)
    mov.w @(APC_Data0524,PC),r0
	mov.b @(r0,r14),r0
	shll r0
	mov.w @(r0,r12),r3
    extu.w r3,r3
    mov.w @(APC_ButtonMaskXYAB,PC),r2
    tst r2,r3
    mov.l @(APC04_StateSelect_PickStageLoc,PC),r4
    jmp @r4
    nop

;-------------------------------------------------------------------------
; APC05
; from loc_8c03b38c
; disable cursor movements
;-------------------------------------------------------------------------
APC05_noDirectionsStart:
    mov.w @(APC_autoPickByte_offset,pc),r0
    mov.b @(r0,r14),r0
    tst 0x01,r0 ; is autopick off?
    bf APC05_8c03b464_exit   ; if no bit set, execute normal route

; Original code
APC05_normalDirections:
	mov.w @(APC_Data0524,PC),r0
	mov.w @(APC_directionalMask,PC),r2
	mov.b @(r0,r14),r0
	shll r0
	mov.w @(r0,r4),r3
	extu.w r3,r3
	tst r2,r3
	bt APC05_8c03b464_exit

; return to normal execution
    mov.l @(APC05_directionPressedLoc,PC),r0
    jmp @r0
    nop

APC05_8c03b464_exit:
    mov.l @(APC05_8c03b464_exitPtr,PC),r0
    jmp @r0
    nop

;-------------------------------------------------------------------------
; APC06
; from loc_8c03b670
; disable cursor movements (for assists)
;-------------------------------------------------------------------------
; loc_8c03b670:
APC06_assistMovementStart:
    mov.w @(APC_autoPickByte_offset,pc),r0
    mov.b @(r0,r14),r0
    tst 0x01,r0 ; is autopick off?
    bf APC06_skipAssistDPad        ; if no bit set, execute normal route

ACP06_defaultCode:
	mov.w @(APC_Data0524,PC),r0
	mov.w @(APC_bttnV_Up,PC),r2 ; bttnV_up
	mov.b @(r0,r14),r0          ; r0 is now playerID
	shll r0                		; offset playerID*2
    mov.l @(loc_8c03b67c_ptr,PC),r3
    mov.w @(r0,r4),r0           ; r3 is now playerInput
    jmp @r3
	extu.w r0,r3

APC06_skipAssistDPad:
    mov.l @(loc_8c03b6b0_ptr,PC),r3
    jmp @r3
    nop

;-------------------------------------------------------------------------
; APC07
; from loc_8c03a46e
; skips stage select screen
;-------------------------------------------------------------------------
ACP07_SkipStageSelect_Start:
    mov.l @r12,r2
	mov 0x00,r13
    
    mov.w @(APC_autoPickByte_offset,pc),r0
    mov.b @(r0,r3),r0
    tst 0x04,r0 ; is autopick off?
    bf ACP07_SkipStageSelect_Skip

; Normal Code
	mov.b @(0x3,r2),r0
	add 0x01,r0
    bra ACP07_SkipStageSelect_ExitJump
    mov.b r0,@(0x3,r2)

ACP07_SkipStageSelect_Skip:
	mov 0x03,r0
	mov.b r0,@(0x3,r2)

ACP07_SkipStageSelect_ExitJump:
    mov.l @(APC07_loc_8c03a47a_exitPtr),r3
    jmp @r3
    mov.l @r12,r3

;-------------------------------------------------------------------------
; APC08
; from loc_8c03a4b4
; skips stage select screen
;-------------------------------------------------------------------------
APC08_StageSelectStartValue_Start:
    mov.l @(APC_plMemStart,PC),r2
    mov.w @(APC_autoPickByte_offset,pc),r0
    mov.b @(r0,r2),r0
    tst 0x04,r0
    bf APC08_RandomPickStage

    mov.l @(APC_StageID_PTR,PC),r2
	mov 0x11,r3
    bra APC08_loc_8c03a4c0_exit
    mov.b r3,@r2

APC08_RandomPickStage:
    mov.l r4,@-r15
    mov.l @(APC_RNG_FunctionPTR,PC),r3
	jsr @r3
	nop
    mov.l @r15+,r4
	cmp/pz r0
	bf APC08_SkipStageSelect_NegValue

	bra APC08_SkipStageSelect_WriteVal
	and 0x07,r0

APC08_SkipStageSelect_NegValue:
	not r0,r0
	add 0x01,r0
	and 0x07,r0
	not r0,r0
	add 0x01,r0

APC08_SkipStageSelect_WriteVal:
    mov.l @(APC_StageID_PTR,PC),r2
	mov.b r0,@r2
    mov 0x11,r3
APC08_loc_8c03a4c0_exit:
    mov 0x4F,r0
    mov.l @(APC08_loc_8c03a558,PC),r1
	mov.b r13,@(r0,r14)
    mov.l @(APC08_loc_8c03a4c0_exitPtr,PC),r3
    jmp @r3
    nop

APC09_AssistDrawSkip_Start:
    mov.w @(APC_autoPickByte_offset,pc),r0
    mov.b @(r0,r13),r0
    tst 0x01,r0 ; is autopick off?
    bf APC09_AssistSelectDrawing_NoAssistSelectExit

	mov.l @(APC09_loc_8C0F5D10,pc),r3 ; r3 set to 0x8C1294C8, r3 set to 0x8C1294C8
	jsr @r3
	mov 0x0C,r0 ; r0 set to 0x0C, r0 set to 0x0c

    mov.l @(APC09_loc_8C0F5D14,pc),r4 ; r4 set to 0x8C16262C, r4 set to 0x8C16262c

    mov.l @(APC09_AssistSelectDrawingReturnExitPtr,PC),r0
    jmp @r0
    mov 0x20,r0 ; r0 set to 0x20, r0 set to 0x20

APC09_AssistSelectDrawing_NoAssistSelectExit:
    mov.l @(APC09_AssistSelectDrawing_NoAssistSelectPtr,PC),r0
    jmp @r0
    nop

APC0A_BannerSkip:
    ; check if both
    mov.w @(APC_autoPickByte_offset,pc),r0
    mov.b @(r0,r11),r0
    tst 0x04,r0
    bt APC0A_NormalCode
    bra APC0A_exitJmp
    mov 0x01,r0 ; r0 set to 0x01
APC0A_NormalCode:
    mov 0x00,r0 ; r0 set to 0x00
APC0A_exitJmp:
    mov.b r0,@(0x05,r4)
    mov.l @(APC0A_loc_8C0F532e_exitPtr,PC),r0
    jmp @r0
    nop

APC_ButtonMaskXYAB:
    #data 0x0360
APC_ButtonMaskXYABLR:
    #data 0x03f0
APC_Data0524:
    #data 0x0524
APC_paletteID_offset:
    #data 0x052d
APC_autoPickByte_offset:
    #data 0x0547
APC_chrSlotID_offset:
    #data 0x055c
APC_directionalMask:
    #data 0x3C00
APC_bttnV_Up:
    #data 0x2000
    #align4
   
APC_p1_paletteIDPicksLoc:
    #data rematch_p1_paletteIDs
APC_p2_paletteIDPicksLoc:
    #data rematch_p2_paletteIDs

bankbank_APC00_LeaveOff:
    #data pauseEditing_bank03.loc_8c03b4b6
bankbank_APC00_LeaveOn:
    #data pauseEditing_bank03.loc_8c03b4ba

bankbank_APC01_LeaveNoPick:
    #data pauseEditing_bank03.loc_8c03b77c
bankbank_APC01_LeavePickAssist:
    #data pauseEditing_bank03.loc_8c03b6d4

APC03_8c03b5d8_exitPtr:
    #data pauseEditing_bank03.loc_8c03b5d8
APC03_8c03b77c_exitPtr:
    #data pauseEditing_bank03.loc_8c03b77c

APC04_StateSelect_ReturnLoc:
    #data pauseEditing_bank03.APC04_StateSelect_Return    
APC04_StateSelect_PickStageLoc:
    #data pauseEditing_bank03.APC04_StateSelect_PickStage

APC05_directionPressedLoc:
    #data pauseEditing_bank03.APC05_directionPressed
APC05_8c03b464_exitPtr:
    #data pauseEditing_bank03.loc_8c03b464
loc_8c03b67c_ptr:
    #data pauseEditing_bank03.loc_8c03b67c    
loc_8c03b6b0_ptr:
    #data pauseEditing_bank03.loc_8c03b6b0

APC_RNG_FunctionPTR:
    #data pauseEditing_bank11.loc_8c11e730
APC07_loc_8c03a47a_exitPtr:
    #data pauseEditing_bank03.loc_8c03a47a
APC_StageID_PTR:
    #data 0x8C26A95C
APC_plMemStart:
    #data 0x8C268340
APC08_loc_8c03a4c0_exitPtr:
    #data pauseEditing_bank03.loc_8c03a4c0
APC08_loc_8c03a558:
	#data 0x8c26a960
APC09_AssistSelectDrawingReturnExitPtr:
    #data pauseEditing_bank0f.AssistSelectDrawingReturn

APC09_AssistSelectDrawing_NoAssistSelectPtr:
    #data pauseEditing_bank0f.loc_8c0f5cd4

APC09_loc_8C0F5D10:
	#data pauseEditing_bank12.loc_8c1294C8
APC09_loc_8C0F5D14:
	#data pauseEditing_bank16.loc_8c16262c

APC0A_loc_8C0F532e_exitPtr:
    #data pauseEditing_bank0f.loc_8C0F532e

; from 8c03cece
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Default Picks                                                                ;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cust_DefPick_Begin:
    bra TAP_Begin
    nop
custDefPick_BeginReal:
    mov.l @(defPicks_modeLoc,PC),r0
    mov.b @r0,r0
    exts.b r0,r0
    cmp/eq 0x03,r0
    mov.w @(defPicks_autoPickByte_offset,pc),r0
    mov.b @(r0,r4),r0
    bt defPicks_enableRematchMenu
    

    and 0xF7,r0
    extu.b r0,r2
    mov.w @(defPicks_autoPickByte_offset,pc),r0
    mov.b r2,@(r0,r14)
    bra defPicks_baseGamePicks
    nop

defPicks_enableRematchMenu:
    or 0x08,r0
    extu.b r0,r2
    mov.w @(defPicks_autoPickByte_offset,pc),r0
    mov.b r2,@(r0,r14)
    extu.b r2,r0
    tst 0x01,r0
    bt defPicks_baseGamePicks

defPicks_loadCustom:
; check chrSlot for which assist
	mov.w @(defPicks_chrSlot_offset,PC),r0  
    ; r0 (chrSlot plmem offset)
	mov.b @(r0,r14),r0
    ; r0 is now chrSlot    
    shlr r0
    mov.l @(defPicks_p2_assistPicksLoc,PC),r2
    bt writeSavedAssist
    mov.l @(defPicks_p1_assistPicksLoc,PC),r2

writeSavedAssist:
    add r0,r2     ; offset by chrSlot
    mov.b @r2,r2  ; load saved assist
    mov.w @(defPicks_assistType_offset,PC),r0  ; r0 (assistID plmem offset)
    mov.b r2,@(r0,r14)  ; write saved assist to plmem

; Write Default Character Picks
	mov.w @(defPicks_chrSlot_offset,PC),r0  ; r0 (pX_ID plmem offset)
	mov.b @(r0,r14),r0 			 ; r0 is now chrSlot
    shll2 r0                     ; r0 = chrSlot * 4 (longSize)
    
    mov.w @(defPicks_chrID_offset,PC),r2  ; r2 (2nd chrID plmem offset)
	add r14,r2					          ; r2 (chrID_offset02_loc)

	mov.l @(r0,r10),r0           ; r0 = 8c14d99c + (chrSlot * 4 (longSize))
	mov.b r0,@(0x1,r14)          ; charID to plMem + 0x01 
    bra defPicks_jumpBack
	mov.b r0,@r2                 ; charID to plMem + 0x052c

defPicks_baseGamePicks:
; assist 0x00
    mov 0x00,r2
    mov.w @(defPicks_assistType_offset,PC),r0  ; r0 (assistID plmem offset)
    mov.b r2,@(r0,r14)  ; write saved assist to plmem

; charDefault
    mov.l @(defPicks_newDefCharByteLoc,PC),r10
    mov.w @(defPicks_chrID_offset,PC),r2  ; r2 (2nd chrID plmem offset)
	add r14,r2					          ; r2 (chrID_offset02_loc)

	mov.w @(defPicks_chrSlot_offset,PC),r0  ; r0 (pX_ID plmem offset)
	mov.b @(r0,r14),r0 			 ; r0 is now chrSlot
    ; shll2 r0                     ; r0 = chrSlot * 4 (longSize)

	mov.b @(r0,r10),r0           ; r0 = defCharByteLoc + chrSlot
	mov.b r0,@(0x1,r14)          ; charID to plMem + 0x01 
	mov.b r0,@r2                 ; charID to plMem + 0x052c

    mov.l @(defPicks_autoPickCharLoc,PC),r10

defPicks_jumpBack:
    mov r11,r2
    mov.l @(defPicks_JumpBackLoc,PC),r0
    jmp @r0
	nop
    #align4_nop

;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
defPicks_assistType_offset:
    #data 0x04c9
defPicks_chrID_offset:
    #data 0x052c
defPicks_autoPickByte_offset:
    #data 0x0547
defPicks_chrSlot_offset:
    #data 0x055c
    #align4
defPicks_modeLoc:
    #data 0x8C268258

defPicks_p1_assistPicksLoc:
    #data rematch_p1_assistPicks    
defPicks_p2_assistPicksLoc:
    #data rematch_p2_assistPicks
defPicks_autoPickCharLoc:
    #data pauseEditing_bank14.loc_8c14D99C
defPicks_newDefCharByteLoc:
    #data rematch_defCharBytes
defPicks_JumpBackLoc:
    #data pauseEditing_bank03.loc_8c03cf58

;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

;~~~~~~~~~~~~~~~~~~~~~~
; Save Character Data ;
;~~~~~~~~~~~~~~~~~~~~~~
rematch_setCharacterData:
    mov.l @(saveData_pickedCharArray,PC),r3
    mov.l @(saveData_autoPickCharLoc,PC),r1
    mov 0x00,r0 ; prep chrCount

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Save Character Picks Start ;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; save p1 character picks
; ----------------------------------------------------------
saveData_loopP1CharWrite:
    mov.b @r3,r2
    extu.b r2,r2
    mov.b r2,@r1

    add 0x08,r1
    add 0x01,r3
    add 0x01,r0
    exts.b r0,r0
    cmp/eq 0x03,r0
    bf saveData_loopP1CharWrite

; save p2 character picks
; ----------------------------------------------------------
    mov.l @(saveData_autoPickCharLoc,PC),r1
    add 0x04,r1
    mov 0x00,r0 ; prep chrCount
saveData_loopP2CharWrite:
    mov.b @r3,r2
    extu.b r2,r2
    mov.b r2,@r1
    add 0x08,r1
    add 0x01,r3
    add 0x01,r0
    exts.b r0,r0
    cmp/eq 0x03,r0
    bf saveData_loopP2CharWrite

;~~~~~~~~~~~~~~~~~~~~~~~~~~
; Save Assist Picks Start ;
;~~~~~~~~~~~~~~~~~~~~~~~~~~

    mov.w @(saveData_plMemBlkSize,PC),r2

    mov.l @(saveData_plMemStart,PC),r0
    mov.w @(saveData_assistType_offset,PC),r1

; prep for p1 assist save
; ----------------------------------------------------------
    add r1,r0    ;  r0 = 0x8C268340 + 0x04c9
    mov.l @(saveData_p1_assistPicksLoc,PC),r1 ; r1 -> p1a_savedAssistType
    
; save p1 assists
; ----------------------------------------------------------
    ; p1a_assistType
    mov.b @r0,r3 ;  r3 = B@[0x8C268340 + 0x04c9] ; p1a_assistType
    mov.b r3,@r1 ;  save p1a_assistType

    sts.l pr,@-r15 ; prep
    ; p1b_assistType
    bsr saveData_SubRoutine
    add 0x01,r1  ; r1 -> p1b_savedAssistType

    ; p1c_assistType
    bsr saveData_SubRoutine
    add 0x01,r1  ; r1 -> p1c_savedAssistType

; prep for p2 assist save
; ----------------------------------------------------------
    mov.l @(saveData_plMemStart,PC),r0
    mov.w @(saveData_assistType_offset,PC),r1

    add r1,r0    ;  r0 = 0x8C268340 + 0x04c9
    add r2,r0    ;  r0 = 0x8C268340 + 0x04c9 + (1*0x05a4)

    mov.l @(saveData_p2_assistPicksLoc,PC),r1 ; r1 -> p2a_savedAssistType

; save p2 assists
; ----------------------------------------------------------
    ; p2a_assistType
    mov.b @r0,r3 ;  r3 = p2a_assistType
    mov.b r3,@r1 ;  save p2a_assistType

    ; p2b_assistType
    bsr saveData_SubRoutine
    add 0x01,r1  ; r1 -> p2b_savedAssistType

    ; p2c_assistType
    bsr saveData_SubRoutine
    add 0x01,r1  ; r1 -> p2c_savedAssistType

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Save PaletteID Picks Start ;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; prep for p1
; ----------------------------------------------------------
    mov.l @(saveData_plMemStart,PC),r0 ; r0 -> plmem_p1a_start
    mov 0x25,r1
    add r1,r0                                     ; r0 -> p1a_paletteID
    mov.l @(saveData_p1_paletteIDPicksLoc,PC),r1  ; r1 -> p1a_savedPaletteID

; save p1 paletteIDs
; ----------------------------------------------------------
    mov.b @r0,r3  ; r3 = p1a_paletteID
    mov.b r3,@r1  ; save p1a_paletteID

    ; p1b_paletteID
    bsr saveData_SubRoutine
    add 0x01,r1  ; r1 -> p1b_savedPaletteID

    ; p1c_paletteID
    bsr saveData_SubRoutine
    add 0x01,r1  ; r1 -> p1c_savedPaletteID

; prep for p2
; ----------------------------------------------------------
    mov.l @(saveData_plMemStart,PC),r0
    add r2,r0
    mov 0x25,r1
    add r1,r0  ; r0 -> p2a_paletteID
    mov.l @(saveData_p2_paletteIDPicksLoc,PC),r1

; save p2 paletteIDs
; ----------------------------------------------------------
    ; p2a_paletteID
    mov.b @r0,r3  ; r3 = p2a_paletteID
    mov.b r3,@r1  ; save p2a_paletteID

    ; p2b_paletteID
    bsr saveData_SubRoutine
    add 0x01,r1  ; r1 -> p2b_savedPaletteID

    ; p2c_paletteID
    bsr saveData_SubRoutine
    add 0x01,r1  ; r1 -> p2c_savedPaletteID
 
; exit
; ----------------------------------------------------------
    lds.l @r15+,pr
    nop
    rts
    nop

saveData_SubRoutine:
    add r2,r0
    add r2,r0
    mov.b @r0,r3
    rts
    mov.b r3,@r1
    #align4_nop

saveData_assistType_offset:
    #data 0x04c9
saveData_plMemBlkSize:
    #data 0x05a4
    #align4

saveData_plMemStart:
    #data 0x8C268340

saveData_p1_assistPicksLoc:
    #data rematch_p1_assistPicks    
saveData_p2_assistPicksLoc:
    #data rematch_p2_assistPicks

saveData_p1_paletteIDPicksLoc:
    #data rematch_p1_paletteIDs
saveData_p2_paletteIDPicksLoc:
    #data rematch_p2_paletteIDs

saveData_autoPickCharLoc:
    #data pauseEditing_bank14.loc_8c14D99C
saveData_pickedCharArray:
    #data 0x8C28C47C

;~~~~~~~~~~~~~~~~~~~~~
; REMATCH DATA BLOCK ;
;~~~~~~~~~~~~~~~~~~~~~
#align16
rematch_defCharBytes:
    #data 0x13 ; p1a, 0x00
    #data 0x17 ; p2a, 0x01
    #data 0x13 ; p1b, 0x02
    #data 0x17 ; p2b, 0x03
    #data 0x13 ; p1c, 0x04
    #data 0x17 ; p2c, 0x05
; 0x06

rematch_p1_paletteIDs:
    #data 0x00 ; p1a, 0x00, 0x00
    #data 0x00 ; p1b, 0x02, 0x01
    #data 0x00 ; p1c, 0x04, 0x02
rematch_p2_paletteIDs:
    #data 0x00 ; p2a, 0x01, 0x03
    #data 0x00 ; p2b, 0x03, 0x04
    #data 0x00 ; p2c, 0x05, 0x05
; 0x0C

rematch_APT:
    #data 0x0000 ; [aptPlayerBits, rematchMenuEnable]
                 ; [8C1CA59C, 8C1CA59D]
; 0x0E
rematch_p1_assistPicks:
    #data 0x00 ; p1a, 8C1CA59E
    #data 0x00 ; p1b, 8C1CA59F
    #data 0x00 ; p1c, 8C1CA5A0
    ; [p1a_assistType, p1b_assistType, p1c_assistType]
rematch_p2_assistPicks:
    #data 0x00 ; p2a, 8C1CA5A1
    #data 0x00 ; p2b, 8C1CA5A2
    #data 0x00 ; p2c, 8C1CA5A3
    ; [p2a_assistType, p2b_assistType, p2c_assistType]
; 0x14

rematch_P1_Flags:
    #data 0x0000 ; [hasPicked, rowValue]
                 ; [8C1CA5A4, 8C1CA5A5]
rematch_P2_Flags:
    #data 0x0000 ; [hasPicked, rowValue]
                 ; [8C1CA5A6, 8C1CA5A7]

; 0x18


#align16
rematchMenu_textItems:
    #data "YES (AUTOPICK)"
    ;      123456789ABCDEF 
    #data 0x00
    #align16

    #data "NO (CHAR. SEL)"
    ;      123456789ABCDEF 
    #data 0x00
    #align16

rematchMenu_headerText:
    #data "REMATCH?"
    #data 0x00
    #align16

#align16
#data "PAUSEMOD START"
#data 0x00
#align16
PauseMod_Start:
    mov.w @r7,r0  ; input for current player is held at this loc
    extu.w r0,r0
    mov.w @(Pause_bttnV_Start,pc),r3
    extu.w r3,r3
    tst r3,r0            ; is this player holding start currently?
    bt PauseMod_CheckAmount ; branch if not pressing start
    
    ; is pressing start
	mov.b @r4,r1
	tst r6,r1
    bt PauseMod_CheckOtherPlayer ; if not paused by current player, check other player pause status

    ; if paused
	; check if submenu
	mov 0x18,r0
	mov.b @(r0,r4),r0
	tst r0,r0
	bf PauseMod_HeldRTS ; if in submenu, then rts

    ; is paused not sub men

    mov.w @(0x04,r7),r0
    extu.w r0,r0
    mov.w @(Pause_bttnV_Start,pc),r3
    extu.w r3,r3
    tst r3,r0            ; is this player holding start currently?
    bf PauseMod_UnsetPause

PauseMod_CheckOtherPlayer:
    mov r14,r3
	mov r4,r0
    sub r5,r3
	add 0x06,r0
    nop
	mov.b @(r0,r3),r0
	cmp/eq 0x02,r0
	bt PauseMod_HeldRTS

PauseMod_StartHeldCheck:
    mov.w @r7,r0  ; input for current player is held at this loc
    extu.w r0,r0
    ; check if no face buttons (ABXYLR)
    mov.w @(Pause_bttnV_ABXYLR,pc),r3
    extu.w r3,r3
    tst r3,r0
    bf PauseMod_CheckAmount  ; face button pressed  

PauseMod_HeldIncrement:
    mov.l @(ptr_PauseCounter,pc),r3  ; r3 is start_heldCount_baseAddr
    add r5,r3                        ; player offset
    mov.b @r3,r0
    extu.b r0,r0
    add 0x01,r0                      ; r0 holds new incremented total
    mov.b r0,@r3                     ; now update start_heldCount
    mov 0x28,r3                      ; buffer amount between taunt and pause
    cmp/hi r3,r0                     ; is player's start_heldCount > buffer/threshold
    bt PauseMod_CheckAmount          ; if buffer/threshold > player's start_heldCount, pause
    bra PauseMod_Leave               ; done with incrementing, not taunting or pausing (yet)
    nop

PauseMod_CheckAmount:
    mov.l @(ptr_PauseCounter,pc),r3  ; r3 is start_heldCount_baseAddr
    add r5,r3                        ; player offset (P1: r5 = 0x00) (P2: r5 = 0x01)
    mov.b @r3,r0                     ; r3 now holds this player's start_heldCount
    extu.b r0,r0
    tst r0,r0
    bt PauseMod_Leave

PauseMod_Resolve:
    mov 0x28,r3                ; buffer amount between taunt and pause
    cmp/hi r3,r0               ; is player's start_heldCoun > buffer/threshold
    bt PauseMod_PauseActivate  ; if buffer/threshold > player's start_heldCount, pause
    bra PauseMod_TauntActivate ; if buffer/threshold <= player's start_heldCount, taunt
    nop

PauseMod_TauntActivate:
    mov.l @(ptr_PauseCounter,pc),r3  ; 0x8C268888 
    add r5,r3                        ; r5 = p1 or p2 (0x00 or 0x01)
    add 0x02,r3                      ; move two bytes down 0x8C26888a or 0x8C26888b
    mov 0x01,r0
    bra ResetPlayerPauseCounter
    mov.b r0,@r3                     ; set this individual player's taunt/pause byte to 0x01

PauseMod_PauseActivate:
    mov r4,r2
	add 0x06,r2
	mov 0x02,r3
	add r5,r2
	mov.b r3,@r2
    
    mov.l @(ptr_PauseCounter,pc),r3  ; 0x8C268888 
    add r5,r3                        ; r5 = p1 or p2 (0x00 or 0x01)
    add 0x02,r3                      ; move two bytes down
    mov 0x02,r0
    bra ResetPlayerPauseCounter
    mov.b r0,@r3                     ; set this individual player's taunt/pause byte to 0x02

PauseMod_UnsetPause:
    mov r4,r2
	add 0x06,r2
	mov 0x00,r3
	add r5,r2
    bra PauseMod_HeldRTS
	mov.b r3,@r2

ResetPlayerPauseCounter:
    mov.l @(ptr_PauseCounter,pc),r3 ; r3 = 0x8C268888
    add r5,r3                       ; r3 = r3 + r5 , r5 = p1 or p2 (0x00 or 0x01)
    mov 0x00,r0
    bra PauseMod_HeldRTS
    mov.b r0,@r3 ; reset start_heldCount (start not held down)

PauseMod_Leave:
    mov.l @(ptr_PauseCounter,pc),r3 ; 0x8C268888
    add r5,r3                       ; r5 = p1 or p2 (0x00 or 0x01)
    add 0x02,r3                     ; move two bytes down
    mov 0x00,r0
    bra PauseMod_HeldRTS
    mov.b r0,@r3                    ; set this individual player's taunt/pause byte to 0x00
                                    ; (not pressed or havent finished releasing/)

PauseMod_HeldRTS:
    nop
	rts
	mov.l @r15+,r14    
    #align4_nop

pauseMod_playerHeldAmounts:
    #data 0x0000
pauseMod_playerPauseStatus:
    #data 0x0000
Pause_bttnV_Start:
    #data 0x8000
Pause_bttnV_ABXYLR:
    #data 0x03f0    
    #align4
ptr_PauseCounter:
    #data pauseMod_playerHeldAmounts
    #align4

#align16
#data "16COLOR START"
#data 0x00
#align16
;---------------------------------------------------------------------
; Palette Expansion +Start (12 Color)
; Uses 16 Palette Mod to offset and use only 12 colors
; from loc_8c03d184
;---------------------------------------------------------------------
paletteExp_12Color_StartPtr:
	mov.w @(0x8,r15),r0
	mov.w @(buttons,pc),r5
	mov.l @(Pal_IDpnt,PC),r7;button check table
	mov.l @(Pal_Bpnt,PC),r6;button check table
	mov r11,r13
	and r5,r0

; prep for loop
	mov 0x06,r5 ; bttnComboAmount
    ; 16 Palette uses 4 + Assist Modifier
    ; 6 Palette Default uses 6
    ; 12 color uses 6 + Start Modifier

Button_Grab:
	mov.w @r6,r3
	cmp/eq r3,r0;compare with 8c14da8c table
	bf Button_Check;set next compare
	mov.b @r7,r4;p1 write
	bra AssistGrab
	nop

Button_Check:
	add 0x01,r13
	exts.b r13,r2
	cmp/ge r5,r2
	add 0x01,r7
	bf.s Button_Grab
	add 0x02,r6
	mov.b @r7,r4;give up write

AssistGrab:
    ; check if p2
	mov 0x4,r0
	tst r0,r9
	bf p2grab
	nop
; p1
p1grab:
	mov.l @(buttonpress,pc),r0
	bra cleanup
	mov.w @(0x4,r0),r0; hold p1

;p2
p2grab:
	mov.l @(buttonpress,pc),r0
	mov.w @(0x6,r0),r0 ; hold p2

; 12 Color
cleanup:
	mov.w @(startID,pc),r6
	and r6,r0
	cmp/eq 0x00,r0
	bt palselect_end ; not pressing start

; Start Check
	cmp/eq r6,r0
	add 0x06,r4
; 12 Color End

; 16 Color
;cleanup:
;	mov.w @(assistsid,pc),r6
;	and r6,r0
;	cmp/eq 0x00,r0
;	bt palselect_end

;A1+A2 Check
;	cmp/eq r6,r0
;	bf assist2_check

;	bra palselect_end
;	add 0xc,r4

;assist2_check:
;	cmp/eq 0x10,r0
;	bf assist1_colors

;	bra palselect_end
;	add 0x8,r4

;assist1_colors:
;	add 0x4,r4
; 16 Color End

palselect_end:
	mov r4,r0
	and 0x0f,r0
	mov r0,r4
	mov.l @(jumpto,pc),r7
	jmp @r7
	nop

;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
buttons:
	#data 0x03F0 ; LP,LK,HP,HK,A1,A2 (12 Color)
;    #data 0x0360 ; LP,LK,HP,HK       (16 Color)

; 12 Color
startID:
    #data 0x8000
; 16 Color
;assistsID:
;	#data 0x0090


	#align4
buttonpress:
	#data 0x8c28c474 ; +4 for hold
jumpto:
	#data pauseEditing_bank03.loc_8c03d1bc
; 12 Color
Pal_IDpnt:
	#data pauseEditing_bank14.loc_8c14DA98
Pal_Bpnt:
	#data pauseEditing_bank14.loc_8c14DA8C
#data 0x00
#align16
#data 0x00
#align16
;##############################################
;Pal_IDpnt:
;	#data Pal_ID
;Pal_Bpnt:
;	#data Pal_B

;##############################################
;Pal_B:
;	#data 0x0200 0x0100
;	#data 0x0040 0x0020

;Pal_ID:
;	#data 0x00 0x02
;	#data 0x01 0x03

;VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
;Morrigan extras palette Table
Morrigan_newTransformationTable:
	#data 0x00000060;0 42
	#data 0x00000069;1 4b
	#data 0x00000072;2 
	#data 0x0000007B;3 
	#data 0x00000084;4 
	#data 0x0000008d;5 
	#data 0x00000096;6 
	#data 0x0000009f;7 
	#data 0x000000a8;8 
	#data 0x000000b1;9 
	#data 0x000000ba;a 
	#data 0x000000c3;b 
	#data 0x000000cc;c 
	#data 0x000000d5;d 
	#data 0x000000de;e 
	#data 0x000000e7;f

Morrigan_newUnkTable:
	#data 0x00000030
	#data 0x00000033
	#data 0x00000036
	#data 0x00000039
	#data 0x0000003C
	#data 0x0000003F
	#data 0x00000042
	#data 0x00000045
	#data 0x00000048
	#data 0x0000004b
	#data 0x0000004e
	#data 0x00000051
	#data 0x00000054
	#data 0x00000057
	#data 0x0000005a
	#data 0x0000005d

;      PC  8C03159E
;      SR  60000001      PR  8C03159E     GBR  8C32B420     VBR  8C00F400
;    MACH  00000000    MACL  00000038
;      R0  0000000A      R1  000000D0      R2  00000009      R3  00000000
;      R4  8C00F338      R5  8C28A19C      R6  00000000      R7  8C00F28C
;      R8  00000038      R9  00000000     R10  000005A4     R11  0000005D
;     R12  8C2688E4     R13  00000001     R14  8C0395C6     R15  8C00F38C


;      PC  8C03159E
;      SR  60000001      PR  8C03159E     GBR  8C32B420     VBR  8C00F400
;    MACH  00000000    MACL  00000000
;      R0  0000000A      R1  000000D0      R2  00000005      R3  00000000
;      R4  8C00F338      R5  8C28A09C      R6  00000000      R7  8C00F28C
;      R8  00000000      R9  00000000     R10  000005A4     R11  00000025
;     R12  8C268340     R13  00000000     R14  8C0395C6     R15  8C00F38C
#data "NAMES START"
#data 0x00
#align16
; from loc_8c0315c6
; used for drawing text based on itemNumber
Top8Mod_Start:

; can use: r0, r2, r3, r4, r5, r6
;draw left cursor
    
    mov.l @(leftCursorPtr,PC),r2
    mov 0x3A,r5 ; 2
	mov r8,r4 ; 3
    mov 0x12,r6
	mov.l r2,@-r15 ; 5
	jsr @r14 ; 6
	add 0x1C,r4 ; 7

    ; Text Function [r4: xpos, r5: ypos, r6: colorID]
    add 0x04,r15
;draw right cursor
    
    mov.l @(rightCursorPtr,PC),r2
    mov 0x3A,r5 ; 2
	mov r8,r4 ; xPos (left alignment)
    mov 0x12,r6
	mov.l r2,@-r15 ; 5

	jsr @r14 ; 6 ; Text Function [r4: xpos, r5: ypos, r6: colorID]
	add 0x48,r4 ; xPos (shift)
    
    add 0x04,r15

; draw name

	mov.w @(NS_nameID_offset,PC),r2  ; r2 = 0x0545
    extu.w r2,r2
    add r12,r2 ; r2 -> currentPlayer_itemNumber

    mov.b @r2,r6  ; r6 = currentPlayer_itemNumber

    ; Default Value Check (0x00)
    mov 0x00,r0
    extu.b r6,r6
    extu.b r0,r0
    cmp/eq r6,r0
    bt TopN_DefaultName

    ; If not default use color list
    ;---------------------------------------------------------------
    mov.l @(ColorListPtr,PC),r2 ; r2 -> ColorList_Begin
    add 0xFF,r2
    add r6,r2  ; r2 -> colorList_Begin + itemNumber [0x01, 0x10]
    
    ; load name and push string start into stack
    ;----------------------------------------------------------------
    mov.l @(NamesPtr,PC),r3  ; r3 -> NamePTRList_Begin
    extu.b r6,r5
    shll2 r5  ; r5 = itemNumber * 4
    extu.b r5,r5
    add r5,r3  ; r3 -> NamePTRList_Begin + (4 * itemNumber)
    mov.l @r3,r3 ; r3 -> desiredString

    ; Adjust padding
    ;----------------------------------------------------------------
    mov.l @(TopNamePaddingListStart,PC),r5
    add r6,r5  ; r5 -> (TopNamePaddingListStart + r6)
    mov.b @r5,r5
    shlr r5
    add r5,r3  ; [---*---str]
    mov.l r3,@-r15

    bra StartLoadingListItem
    mov.b @r2,r6

TopN_DefaultName:
    mov.l @(str_selectscreenDefaultPtr,PC),r3
    mov 0x13,r6
    mov.l r3,@-r15
StartLoadingListItem:
    mov 0x0A,r0 ; value reset cause, thats what it was
	mov 0x3A,r5
	mov r8,r4 ; 3
	jsr @r14 ; 6
	add 0x1C,r4 ; 7
    ; Text Function [r4: xpos, r5: ypos, r6: colorID]
    add 0x04,r15

ExitTop8:
    mov.l @(jmp_backHandicapPtr,PC),r2
    jmp @r2
    nop
    #align4_nop

; loc_8c03ab2c
NameScrolling_Start:
    ; check if already picked
    jsr @r11  ; sound
	mov 0x03,r4
    
    mov.w @(NS_playerID_offset,PC),r0  ; r0 = 0x0524, control_ID_offset
    extu.w r0,r0
	mov.b @(r0,r14),r0  ; r0 = controlID
	shll r0  ; offset by word size (controlID * 2)
    mov.w @(r0,r12),r3
    extu.w r3,r3

    mov.w @(NS_nameID_offset,PC),r2  ; r2 = 0x0545
    extu.w r2,r2
    add r14,r2 ; r2 -> itemNumber

    ; r2 -> itemNumber
    ; r3 = playerInput

    ; check if left press

    ; load data
	mov.w @(NS_bttnV_left,PC),r1  ; r1 = 0x0800 , bttnV_left
    extu.w r1,r1
	tst r1,r3 ; if pressed left, t = 0
	bt.s NS_checkRightPress  ; if not left, check right
    mov 0xFF,r4

; r2 -> itemNumber
NS_Decrement:
    ; left was pressed
    mov.b @r2,r0  ; r0 (player_itemNumber)
    add 0xFF,r0
    cmp/eq 0xFF,r0
    bt NS_Underflow

    bra NS_CheckFF_D
    mov.b r0,@r2

NS_Underflow:
    mov 0x10,r0
    extu.b r0,r0
    mov.b r0,@r2

NS_CheckFF_D:
    mov 0xFF,r4
    cmp/eq 0x00,r0
    bt NS_checkRightPress

    ; player_itemNumber != 0 [0x01,0x10]
    mov.l @(ColorListPtr,PC),r3
    add 0xFF,r3
    add r0,r3
    mov.b @r3,r3
    cmp/eq r4,r3
    bt NS_Decrement

; r2 -> itemNumber
; r3 = playerInput
NS_checkRightPress:
    ; load data
    mov.w @(NS_buttV_right,PC),r1  ; r1 = 0x0400 , bttnV_right
    extu.w r1,r1
    tst r1,r3
    bt.s NS_CheckFF_I
    mov.b @r2,r0

; r2 -> itemNumber
NS_Increment:
    ; right was pressed
    mov.b @r2,r0  ; r1 (player_itemNumber)
    extu.b r0,r0
    add 0x01,r0

    cmp/eq 0x11,r0
    bt NS_Overflow

    bra NS_CheckFF_I
    mov.b r0,@r2

NS_Overflow:
    mov 0x00,r0
    extu.b r0,r0
    mov.b r0,@r2

NS_CheckFF_I:
    cmp/eq 0x00,r0
    bt NameScrolling_Exit
    ; player_itemNumber != 0
    mov.l @(ColorListPtr,PC),r3
    mov 0xFF,r4
    add r4,r3
    add r0,r3
    mov.b @r3,r3
    cmp/eq r4,r3
    bt NS_Increment


NameScrolling_Exit:
    mov.l @(loc_8c03ab7a_exitPtr,PC),r0
    jmp @r0
    nop
    #align4_nop

;------------------------------------------------------------------
; WIN COUNT P1
; from loc_8c046ff4
;------------------------------------------------------------------
WinDisplay_P1:
    add 0x08,r15
    
    mov 0x9c,r0
    extu.b r0,r0
    mov.b @(r0,r9),r2
    extu.b r2,r2
    mov.l r2,@-r15 ; wins

    mov.l @(WinD_p1_plmem,PC),r6
    mov.w @(NS_nameID_offset,PC),r2
    extu.w r2,r2
    add r2,r6
    mov.b @r6,r6  ; r6 = p1_itemNumber
    extu.b r6,r6  ; r6 = p1_itemNumber

    extu.b r6,r5  ; r5 = p1_itemNumber
    shll2 r5  ; r5 = p1_itemNumber * 4
    mov.l @(NamesPtr,PC),r3  ; r3 -> Names
    add r5,r3  ; r3 -> Names + (p1_itemNumber * 4)
    mov.l @r3,r3 ; r3 -> desiredString
    mov.l r3,@-r15 ; desiredString
    
    mov.l @(PTR_STR_NameValue,PC),r2 ; "%s %2d"
    mov.l r2,@-r15 ; "%s %2d"

    extu.b r6,r0
    mov 0x00,r3
    extu.b r3,r3
    cmp/eq r3,r0
    bf useColorList_P1
    
defaultDisplay_P1:
    bra startDrawingName_P1
    mov 0x13,r6
useColorList_P1:
    mov.l @(ColorListPtr,PC),r6
    add 0xFF,r6
    add r0,r6
    mov.b @r6,r6
startDrawingName_P1:

	mov.l @r13,r5
    mov 0xb2,r0 ; 0x00b2
    extu.b r0,r0
	mov.b @(r0,r5),r5

	jsr @r12  ; Text Function [r4: xPos, r5: yPos, r6: colorID]
	mov 0x0A,r4

WinDisplay_P1_exit:
    mov.l @(loc_8c047006_exitPtr,PC),r0
    jmp @r0
    add 0x0C,r15
    #align4_nop

loc_8c047006_exitPtr:
    #data pauseEditing_bank04.loc_8c047006


;------------------------------------------------------------------
; WIN COUNT P2
; from loc_8c047070
;------------------------------------------------------------------
WinDisplay_P2:
    add 0x08,r15

    mov.l @(WinD_p1_plmem,PC),r6
    mov.w @(NS_plMem_blkSize,PC),r2
    add r2,r6
    mov.w @(NS_nameID_offset,PC),r2
    extu.w r2,r2
    add r2,r6
    mov.b @r6,r6  ; r6 = p1_itemNumber
    extu.b r6,r6  ; r6 = p1_itemNumber

    extu.b r6,r5  ; r5 = p1_itemNumber
    shll2 r5  ; r5 = p1_itemNumber * 4
    mov.l @(NamesPtr,PC),r3  ; r3 -> Names
    add r5,r3  ; r3 -> Names + (p1_itemNumber * 4)
    mov.l @r3,r3 ; r3 -> desiredString

    ; Adjust padding
    ;----------------------------------------------------------------
    mov.l @(TopNamePaddingListStart,PC),r5
    add r6,r5  ; r5 -> (TopNamePaddingListStart + nameID)
    mov.b @r5,r5
    add r5,r3  ; [------*str]
    mov.l r3,@-r15 ; desiredString

    mov 0x9d,r0
    extu.b r0,r0
    mov.b @(r0,r9),r2
    extu.b r2,r2
    mov.l r2,@-r15 ; WINS

    mov.l @(PTR_STR_NameValue_P2,PC),r2 ; "%2d %s"
    mov.l r2,@-r15 ; "%2d %s"

    extu.b r6,r0
    mov 0x00,r3
    extu.b r3,r3
    cmp/eq r3,r0
    bf useColorList_P2

defaultDisplay_P2:
    bra startDrawingName_P2
    mov 0x13,r6

useColorList_P2:
    mov.l @(ColorListPtr,PC),r6
    add 0xFF,r6
    add r0,r6
    mov.b @r6,r6

startDrawingName_P2:
	mov.l @r13,r5
    mov 0xb2,r0 ; 0x00b2
    extu.b r0,r0
	mov.b @(r0,r5),r5

	jsr @r12  ; Text Function [r4: xPos, r5: yPos, r6: colorID]
	mov 0x5C,r4

	
WinDisplay_P2_exit:
    mov.l @(loc_8c047080_exitPtr,PC),r0
    jmp @r0
    add 0x0C,r15
    #align4_nop
loc_8c047080_exitPtr:
    #data pauseEditing_bank04.loc_8c047080

NS_playerID_offset:
    #data 0x0524
NS_plMem_blkSize:
    #data 0x05A4
NS_nameID_offset:
    #data 0x0545
NS_bttnV_left:
    #data 0x0800
NS_buttV_right:
    #data 0x0400
    #align4

leftCursorPtr:
    #data str_left_cursor
rightCursorPtr:
    #data pauseEditing_bank13.loc_8c136990
str_selectscreenDefaultPtr:
    #data str_selectscreenDefault
jmp_backHandicapPtr:
    #data pauseEditing_bank03.jmp_backHandicap


TopNamePaddingListStart:
    #data TopNamePaddingList
ColorListPtr:
    #data TopNameColorList
NamesPtr:
    #data TopNamePtrList
loc_8c03ab7a_exitPtr:
    #data pauseEditing_bank03.loc_8c03ab7a
WinD_p1_plmem:
    #data 0x8c268340
PTR_STR_NameValue:
    #data str_NameValue
PTR_STR_NameValue_P2:
    #data str_NameValue_p2_side
#align16

; 8C1CA494
;-----------------------------------------------
; Team Autopick Code
;   Parameters:
;     nameID (0x0545),
;     buttonHeld (0x8c28c474 ; +4 for hold),
;   r4 + 0x1E
;     charsPicked_P1, 8c268340 + 0x1E
;     charsPicked_P2, 8c268340 + 0x1E + 0x05A4
; r0, r2, r3, r5, r6, r11, r12
;-----------------------------------------------
TAP_EarlyExit:
    mov 0x01,r0  ; r0 reset
    mov.l @(TAP_GlobalPtr,PC),r1 ; reset
    mov.l @(TAP_plMemStart,PC),r2 ; r2 reset
    ; r4 untouched
    mov 0x4C,r3  ; r3 reset
    mov 0x00,r5  ; r5 reset
    mov 0x03,r6  ; r6 reset
    mov r2,r11   ; r11 reset


    bra custDefPick_BeginReal
    nop
    #align4_nop

TAP_Begin:
    ; check if auto pick already set
    ;-----------------------------------------------
    mov.w @(TAP_autoPickByte_offset,PC),r0
    mov.b @(r0,r4),r0
    tst 0x01,r0
    bf TAP_EarlyExit

    ; Determine if first pick
    ;-----------------------------------------------
    mov 0x1E,r0
    mov.b @(r0,r4),r0
    tst r0,r0
    bf TAP_EarlyExit ; if not first pick

 ; if first pick
 ;-----------------------------------------------
    
    ; determine player
    ;-----------------------------------------------

    mov.l @(TAP_inputMem,PC),r5  ; r5 -> inputMem_p1
    mov 0x04,r0
    tst r0,r4
    bt.s TAP_CheckHeld_P1
    add 0x04,r5
    bra TAP_CheckHeld_P2
    add 0x02,r5

TAP_CheckHeld_P1:
    bra TAP_CheckHeld
    mov 0x00,r11
TAP_CheckHeld_P2:
    mov 0x01,r11

TAP_CheckHeld:
    ; check if held button
    mov.w @r5,r0  ; r0 (inputMem_held)
    extu.w r0,r0
    mov.w @(TAP_bttnV_teamValues,PC),r2
    extu.w r2,r2
    tst r2,r0  ; check if held values
    bt TAP_EarlyExit
    

    ; one of the three held
    ; check start
    mov.w @(TAP_bttnV_Start,PC),r2
    extu.w r2,r2
    tst r2,r0  ; check if held values
    bt TAP_checkA1

    ; is holding start
    bra TAP_LoadTeam
    mov 0x00,r2

TAP_checkA1:
    tst 0x80,r0  ; check if held values
    bt TAP_checkA2

    ; is holding A1
    bra TAP_LoadTeam
    mov 0x01,r2

TAP_checkA2:
    tst 0x10,r0  ; check if held values
    bt TAP_EarlyExit

    ; is holding A2
    bra TAP_LoadTeam
    mov 0x02,r2
    
TAP_LoadTeam:
    ; load nameID
    mov.w @(TAP_nameID_offset,PC),r0
    tst r0,r0
    bt TAP_EarlyExit
    shll2 r2
    mov.b @(r0,r4),r0
    add 0xFF,r0
    shll2 r0
    mov r0,r5
    shll r0
    add r0,r5 ; r5 -> nameID_TeamDataStart
    mov.l @(TAP_TeamsListPtr,PC),r0
    add r2,r5 ; r5 -> desiredTeamData
    add r0,r5
    
    mov.l @r5,r5
    tst r5,r5
    bt TAP_Exit  ; if 0, exit

    ; set auto pick
    mov.w @(TAP_autoPickByte_offset,PC),r0
    mov 0x01,r2
    extu.b r2,r2
    mov.b r2,@(r0,r4)
    mov 0x00,r3

TAP_LoadDataLoop:
    ; Data Decode Time
    ; example #data 0x43 0x73 0x27

    mov.b @r5+,r2
    mov 0x3F,r0
    extu.b r2,r2
    mov 0xC0,r6
    extu.b r0,r0
    extu.b r6,r6
    and r2,r0  
    mov r0,r12 ; r12 is character pick
    and r2,r6
    shlr2 r6
    shlr2 r6
    shlr2 r6  ; r6 is assist value
    
    ; Write to target area
    mov.l @(TAP_autoPickCharLoc,PC),r2
    mov r3,r0
    shll r0 ; [0x00, 0x02, 0x04]
    add r11,r0 ; [P1: 0x00, 0x02, 0x04 | P2: 0x01, 0x03, 0x05]
    shll2 r0
    extu.b r12,r12
    mov.b r12,@(r0,r2)

    mov.l @(TAP_assistPicksLoc,PC),r2
    mov r11,r0
    shll r0
    add r11,r0 ; [0x00, 0x03]
    add r3,r0  ; [0x00, 0x01, 0x02]
    mov.b r6,@(r0,r2)

    mov r3,r0
    cmp/eq 0x02,r0
    bt TAP_colorData
    bra TAP_LoadDataLoop
    add 0x01,r3

;========================================================================
;     COLOR COLLISION
; Since theres 4 Cables we expect to see 4 bits set in the sameCharID bitflag.
; These bit flats are for each slot:
; 0b0000 0001 = 0x00 : slot  0x00  has charID X
; 0b0000 0010 = 0x02 : slot  0x01  has charID X
; 0b0000 0011 = 0x03 : slots[0x00, 0x01] have charID X
; ...
; 0b0010 1101 = 0x2B : slot p1a(0x00), and all p2 slots(odd : 0x01,0x03,0x05) have charID X
; ...
; 0b0011 1111 = 0x3F : all slots have charID X
; Now that we've figured out what slots have the same ID we start randomizing for them.
; We start from 0x00, so as a trial we run it now.
;     I bp at our injection @ 8C03CECE 
;============================================================================
; Example (OLD)
;============================================================================
; P1_C: PC  8c03cece , Slot: 0x04
;----------------------------------------------------------------------------
;      SR  60000200      PR  8C03B1B2     GBR  8C32B420     VBR  8C00F400
;    MACH  00000000    MACL  00001690
;----------------------------------------------------------------------------
;      R0  00000001      R1  8C26823C      R2  8C268340      R3  0000004C
;      R4  8C268340      R5  00000000      R6  00000003      R7  8C28C410
;      R8  8C2681DC      R9  8C11D420     R10  8C14D99C     R11  8C268340
;     R12  00000001     R13  000005A4     R14  8C2699D0     R15  8C00F398
;----------------------------------------------------------------------------
; 
;============================================================================
; Example (Latest)
;============================================================================
; P1_C: PC  8c03cece , Slot: 0x04
;----------------------------------------------------------------------------
;      SR  60000200      PR  8C03B1B2     GBR  8C32B420     VBR  8C00F400
;    MACH  00000000    MACL  00001690
;----------------------------------------------------------------------------
;      R0  00000001      R1  8C26823C      R2  8C268340      R3  0000004C
;      R4  8C268340      R5  00000000      R6  00000003      R7  8C28C410
;      R8  8C2681DC      R9  8C11D420     R10  8C14D99C     R11  8C268340
;     R12  00000001     R13  000005A4     R14  8C2699D0     R15  8C00F398
;----------------------------------------------------------------------------
; 

; PC  8C03CECE
; SR  60000200
; PR  8C03B1B2
; GBR  8C32B420
; VBR  8C00F400
; MACH  00000000
; MACL  00000000
; R0  00000001
; R1  8C26823C
; R2  8C268340
; R3  0000004C
; R4  8C268340
; R5  00000000
; R6  00000003
; R7  8C28C410
; R8  8C2681DC
; R9  8C11D420
; R10  8C14D99C
; R11  8C268340
; R12  00000001
; R13  000005A4
; R14  8C268340
; R15  8C00F398

; MAME debugger version 0.254 (mame0254)
; Currently targeting dc (Dreamcast (USA, NTSC))
; >wps 8c1ca5f6,6,wr
; Watchpoint 1 set
; >wps 0c1ca5f6,6,wr
; Watchpoint 2 set


; - RNG P1 Held Start for Preset Team - 
;  - Cable RNG
; Stopped at watchpoint 2 writing 00 to 0C1CA5F6 (PC=8C1CABBE) 00 : Cable
; Stopped at watchpoint 2 writing 01 to 0C1CA5F9 (PC=8C1CABBE) 01 : Cable
; Stopped at watchpoint 2 writing 03 to 0C1CA5FA (PC=8C1CABBE) 03 : Cable
; Stopped at watchpoint 2 writing 02 to 0C1CA5FB (PC=8C1CABBE) 05 : Cable
; Stopped at watchpoint 2 writing 02 to 0C1CA5F7 (PC=8C1CABBE) 02 : BH
; Stopped at watchpoint 2 writing 03 to 0C1CA5F8 (PC=8C1CABBE) 04 : Guile

; - Auto Pick for P1
; Stopped at watchpoint 2 reading 00 from 0C1CA5F6 (PC=8C1CA2E4) 00 : Cable
; Stopped at watchpoint 2 reading 02 from 0C1CA5F7 (PC=8C1CA2E4) 02 : BH
; Stopped at watchpoint 2 reading 03 from 0C1CA5F8 (PC=8C1CA2E4) 04 : Guile


; - End of Match (Save Color Picks)
;  - P1
; Stopped at watchpoint 2 writing 00 to 0C1CA5F6 (PC=8C1CA590) 00 : Cable 
; Stopped at watchpoint 2 writing 02 to 0C1CA5F7 (PC=8C1CA5C0) 02 : BH
; Stopped at watchpoint 2 writing 03 to 0C1CA5F8 (PC=8C1CA5C0) 04 : Guile
;  - P2
; Stopped at watchpoint 2 writing 01 to 0C1CA5F9 (PC=8C1CA5A6) 01 : Cable
; Stopped at watchpoint 2 writing 02 to 0C1CA5FA (PC=8C1CA5C0) 03 : Cable
; Stopped at watchpoint 2 writing 03 to 0C1CA5FB (PC=8C1CA5C0) 05 : Cable

; - RNG P1 Held Start for Preset Team -
;  - Issue here?
; Stopped at watchpoint 2 writing 05 to 0C1CA5F6 (PC=8C1CABBE) 00 : Cable
; Stopped at watchpoint 2 writing 04 to 0C1CA5F9 (PC=8C1CABBE) 01 : Cable
; Stopped at watchpoint 2 writing 03 to 0C1CA5F7 (PC=8C1CABBE) 02 : BH?
; Stopped at watchpoint 2 writing 02 to 0C1CA5FB (PC=8C1CABBE) 05 : Cable?

; Stopped at watchpoint 2 writing 02 to 0C1CA5FA (PC=8C1CABBE) 04 : Cable?
; Stopped at watchpoint 2 writing 00 to 0C1CA5F8 (PC=8C1CABBE) 03 : Guile?

; - Auto Pick for P1 & P2
; Stopped at watchpoint 2 reading 05 from 0C1CA5F6 (PC=8C1CA2E4) 00 : Cable A2
; Stopped at watchpoint 2 reading 04 from 0C1CA5F9 (PC=8C1CA2E4) 01 : Cable A1
; Stopped at watchpoint 2 reading 03 from 0C1CA5F7 (PC=8C1CA2E4) 02 : BH HK
; Stopped at watchpoint 2 reading 02 from 0C1CA5FA (PC=8C1CA2E4) 03 : Cable HP
; Stopped at watchpoint 2 reading 00 from 0C1CA5F8 (PC=8C1CA2E4) 04 : Guile LP 
; Stopped at watchpoint 2 reading 02 from 0C1CA5FB (PC=8C1CA2E4) 05 : Cable HP

S



TAP_colorData:
  ; r5: currentSlot
  ; set loop counter to 0 (slots)
    mov 0x00,r5

  ;  r6: slotCheckedBitfag
  ; set bitflag for checked slots to 0
    mov 0x00,r6

loop_checks:
    mov 0xFF,r12
    extu.b r12,r12
    ; starting next slot
    mov 0x00,r2 ; reset sameCharID_slotBitflagLog
    ; check if slot has been checked before
    extu.w r5,r1
    mov 0x01,r7
    shad r1,r7
    tst r7,r6
    bf CC_Skip ; if slot has already been dealt with move on to next slot

  ; check if invalid character
    mov 0xFF,r0
    extu.b r0,r0
    cmp/eq r12,r0
    bf CC_checkAheadSlots

  ; load new charID
    mov.l @(TAP_autoPickCharLoc),r7 ;
    extu.w r5,r11
    shll2 r11
    add r11,r7
    mov.b @r7,r12 ;  r12 holds curCharID
    mov 0x01,r3
  ; set currentSlot as checked 
    extu.w r5,r11
    mov 0x01,r7
    shad r11,r7
;   or r7,r6
    or r7,r2

    
;  r2: sameCharID_bitFlag
;  r3: sameCharID_count
;  r5: currentSlot_count
;  r6: checkedSlots_bitFlag
;  r8: paletteID_bitflag
; r11: curAheadSlot_count
; r12: curCharID
; temp regs: 
;   r0, r1, r7, r9, r10, r13

CC_checkAheadSlots:
    ; check ahead character slots against current slot
    extu.w r5,r11 ;  ex r5 is on slot 0x05
    add 0x01,r11  ;  ex r11 is on 0x06
    mov 0x06,r1   ;
    cmp/ge r1,r11
    bt CC_aheadDone
CC_checkAheadSlotsLoop:
  ; check if already dealt with
    extu.w r11,r1
    mov 0x01,r7
    shad r1,r7
    tst r7,r6
    bf CC_SkipToNextAhead

    ; aheadSlot hasnt been dealt with
    ; load charID to compare
    extu.w r11,r1
    mov.l @(TAP_plMemListPtr,PC),r7
    shll2 r1
    add r1,r7
    mov.l @r7,r7
    mov.w @(TAP_charID_offset,PC),r1
    add r1,r7
    mov.b @r7,r7

    cmp/eq r7,r12
    bf CC_SkipToNextAhead

    ; same charID
    add 0x01,r3
    extu.w r11,r1
    mov 0x01,r7
    shad r1,r7
    or r7,r2
    ; log bitflag if character IDs match

CC_SkipToNextAhead:
    add 0x01,r11
    mov 0x06,r1
    cmp/ge r1,r11
    bf CC_checkAheadSlotsLoop

CC_aheadDone:
    ; finished chaking all ahead slots
    ; deal with r2 bitflag of sameCharIDs
    extu.w r5,r11
    mov 0x00,r8

CC_bitFlagCheck:
    extu.w r11,r1
    mov 0x01,r7
    shad r1,r7
    tst r7,r2
    bt CC_goToNextBit
    
    ; current slot needs to be dealt with
    ; r8 will be bitflag for paletteIDs

RNG_PaletteID:
    ; rng paletteID
    mov.l @(TAP_r15_temp,PC),r15
    mov.l r2,@-r15
    mov.l r3,@-r15
    mov.l r4,@-r15
    sts.l pr,@-r15

    mov.l @(TAP_RNG_PTR,PC),r0
    jsr @r0
    nop

    extu.b r0,r1

    lds.l @r15+,pr
    mov.l @r15+,r4
    mov.l @r15+,r3
    mov.l @r15+,r2

    mov 0x00,r0
    mov.l r0,@-r15
    mov.l r0,@-r15
    mov.l r0,@-r15
    mov.l r0,@-r15
    mov.l r0,@-r15
    add 0x14,r15

    ;  r2: sameCharID_bitFlag
    ;  r3: sameCharID_count
    ;  r5: currentSlot_count
    ;  r6: checkedSlots_bitFlag
    ;  r8: will be bitflag for paletteIDs
    ; r11: curSlot_toPaletteID
    ; r12: curCharID
    ;  r1: now holds rng value? ex 0x6b

    ; filter rng byte and verify it isnt used already,
    mov 0x0F,r0 ; 
    and r0,r1   ; ex 0x0b

    mov.l @(TAP_PaletteAmountPtr,PC),r7
    mov.b @r7,r7
check_rng:
    cmp/ge r7,r1 ; is rng > TAP_PaletteAmount?
    bf TAP_checkBitFlag

    ; subtract TAP_PaletteAmount
    bra check_rng
    sub r7,r1 ; subtract r7 from r1

TAP_checkBitFlag:
    mov 0x01,r7
    shad r1,r7       ; shift 1 by rng
    tst r7,r8
    bf RNG_PaletteID

    
    ; not used yet, lets use it
	or r7,r8                     ; log paletteID in bitFlag as used
    ; load pointer to paleteID
    extu.w r11,r7
    mov.l @(TAP_plMemListPtr),r0
    shll2 r7
    add r7,r0
    mov.l @r0,r0  ; r0 -> curSlot_plMemStart
    mov.w @(TAP_paletteID_offset,PC),r7
    add r7,r0
    mov.b r1,@r0
    
    ; write to auto pick area
    extu.w r11,r7
    shlr r7
    bf TAP_palWrite
    bra TAP_palWrite
    add 0x03,r7
TAP_palWrite:
    mov.l @(TAP_autoPaletteIDs,PC),r0
    add r7,r0
    mov.b r1,@r0


    ; mark slot as checked
    extu.w r11,r7
    mov 0x01,r1
    shad r7,r1
    or r1,r6
    add 0xFF,r3 ; one less of the same

CC_goToNextBit:
    add 0x01,r11 ; next slot
    cmp/pl r3
    bt CC_bitFlagCheck

CC_Skip:
    ; increment loop counter
    add 0x01,r5
    mov 0x06,r0
    cmp/eq r5,r0 ; last slot?
    bf loop_checks ; not done dealing with slots

    ; we're done dealing with slots
TAP_Exit:
    mov 0x01,r0  ; r0 reset
    mov.l @(TAP_GlobalPtr,PC),r1 ; reset
    mov.l @(TAP_plMemStart,PC),r2 ; r2 reset
    ; r4 untouched
    mov 0x4C,r3  ; r3 reset
    mov 0x00,r5  ; r5 reset
    mov 0x03,r6  ; r6 reset
    mov.l @(TAP_charSelMem,PC),r7
    mov.l @(TAP_inputMem_main,PC),r8
    mov.l @(TAP_someMemory,PC),r9
    mov.l @(TAP_autoPickCharLoc,PC),r10
    mov r2,r11   ; r11 reset
    mov r0,r12   ; r12 reset
    mov.w @(TAP_plMemBlkSize,PC),r13
    ; r14 untouched
    mov.l @(TAP_r15_og,PC),r15


    bra custDefPick_BeginReal
    nop
    #align4_nop

; Example generated by TVi 
; Ex1: [ HK, HP, A1, A2+S, HK, HK ]
;    
; - Objective:
;   .    Go down the list and overwrite any Equal values ahead from current slot (curSlot).
;
; - Break down: 
;   .    We start with chrSlot 0x00, we have RNG'd for all six since all characters are the same. We could minimize the amount to check against by having less same characters. 
; plyrList:  [  P1A,   P1B,  P1C,   P2A,  P2B,   P2C ]
; charIDs:   [ 0x13,  0x13, 0x13,  0x17, 0x17,  0x17 ]
; charSlots: [ 0x00   0x02  0x04   0x01  0x03   0x05 ]
; charNames: [ Ruby, Cable, Ruby, Cable, Ruby, Cable ]
;=========================================================
; charNames: [ Ruby, Cable, Ruby, Cable, Ruby, Cable ]
;      .     [  P1A,   P2A,  P1B,   P2B,  P1C,   P2C ]
; charSlots: [ 0x00,  0x01, 0x02,  0x03, 0x04,  0x05 ]
; charIDs:   [ 0x13,  0x13, 0x13,  0x13, 0x13,  0x13 ]
; bttnName:  [   HP,    HP,   HP,    HP,   HP,    HP ]
; paletteID: [ 0x03,  0x03, 0x03,  0x03, 0x03,  0x03 ]
; 
; Plan: Start from left to right (increasing charSlot), rng the paletteID for all identical characters.
;    - Regardless of already chosenPaletteID in preset team data, all slots with identical characters must RNG.
;          Above translates to if any instance of > 2 of the same character RNG their paletteID.
;          In other words, if you are the only instance of that character, you get the color.
;    - We keep track of how many identical characters and what slots
; step  0: curSlot = 0x00, curCharID: 0x13, curPaletteID: 0x03.
; step  1: check other slots for same charID (0x13)
; sameCharSlots: 
;     [ maxValue , exampleValue ] : [ 0b0011 1111, 0b0001 0101 ] (0x13) 
;
;  sameCharSlots = 0x00
;  sameCharAmnt = 0x00
;  for l00p_charSlot in charSlotList:
;  .  if l00p_charSlot[charID] == curCharID:
;  .    sameCharSlots |= 0x01
;  .    sameCharAmnt += 1
;  .  sameCharSlots = (sameCharSlots << 1)
;  ;===================================================================================
;  #  sameCharSlots should now hold a bitflag list of charSlots that need to be RNG'd.
; t_SameCharSlots = sameCharSlots
; # generate an array of unique paletteIDs of size sameCharAmnt
; # write array into paletteIDs of sameCharSlots
; # mark slots as taken care of
; for curBit in range(0,6):
;     shlr t_sameCharSlots
;     bt forThatBit_RNG ; if currentSlot needs RNG
;     continue
; forThatBit_RNG:

#align4_nop
TAP_charID_offset:
    #data 0x052c
TAP_paletteID_offset:
    #data 0x052d
TAP_autoPickByte_offset:
    #data 0x0547
TAP_nameID_offset:
    #data 0x0545
TAP_plMemBlkSize:
    #data 0x05a4
TAP_bttnV_teamValues:
    #data 0x8090
    ; Start (0x8000) | A1 (0x0080) | A2 (0x0010)
TAP_bttnV_Start:
    #data 0x8000
    #align4
TAP_TeamsListPtr:
    #data NameID_01_TeamList
TAP_autoPickCharLoc:
    #data pauseEditing_bank14.loc_8c14D99C
TAP_assistPicksLoc:
    #data rematch_p1_assistPicks
TAP_GlobalPtr:
    #data 0x8C26823C
TAP_plMemStart:
    #data 0x8C268340
TAP_inputMem_main:
    #data 0x8C2681DC
TAP_charSelMem:
    #data 0x8C28C410
TAP_inputMem:
    #data 0x8c28c474
TAP_someMemory:
    #data 0x8C11D420
TAP_RNG_PTR:
    #data pauseEditing_bank11.loc_8c11e730
TAP_plMemListPtr:
    #data TAP_plMemList
TAP_r15_og:
    #data 0x8C00F398
TAP_r15_temp:
    #data 0x8C00F464
TAP_plMemList:
    #data 0x8c268340
    #data 0x8c2688e4
    #data 0x8c268e88
    #data 0x8c26942c
    #data 0x8c2699d0
    #data 0x8c269f74
TAP_autoPaletteIDs:
    #data rematch_p1_paletteIDs
TAP_PaletteAmountPtr:
    #data TAP_PaletteAmount    
TAP_PaletteAmount:
    #data 0x06
#align16

TopNamePtrList:
    #data TopNameDefault
    #data TopNamePlayer0
    #data TopNamePlayer1
    #data TopNamePlayer2
    #data TopNamePlayer3

    #data TopNamePlayer4
    #data TopNamePlayer5
    #data TopNamePlayer6
    #data TopNamePlayer7

    #data TopNamePlayer8
    #data TopNamePlayer9
    #data TopNamePlayerA
    #data TopNamePlayerB

    #data TopNamePlayerC
    #data TopNamePlayerD
    #data TopNamePlayerE
    #data TopNamePlayerF

str_left_cursor:
    #data "<"
    #data 0x00

str_NameValue:
    #data "%s %2d"
    #data 0x00

str_NameValue_p2_side:
    #data "%2d %s"
    #data 0x00
    #align16
str_selectscreenDefault:
    #data " NEW CHALLENGER"
    ;      0123456789ABCDEF
    #data 0x00
    #align16    
    #data "[ PLAYER NAMES ]"
    ;      0123456789ABCDEF
TopNamePlayer0:
    #data "         PAXTEZ"
    ;      123456789ABCDEF
    #data 0x00
    #align16

TopNamePlayer1:
    #data "       MAGNETRO"
    ;      123456789ABCDEF
    #data 0x00
    #align16

TopNamePlayer2:
    #data "  LAZYREAPER808"
    ;      123456789ABCDEF
    #data 0x00
    #align16

TopNamePlayer3:
    #data "   TVINDUSTRIES"
    ;      123456789ABCDEF
    #data 0x00
    #align16
    

TopNamePlayer4:
    #data "      RAWBZILLA"
    ;      123456789ABCDEF
    #data 0x00
    #align16

TopNamePlayer5:
    #data "   SpiceDiamond"
    ;      123456789ABCDEF
    #data 0x00
    #align16

TopNamePlayer6:
    #data "     G.THRILLAH"
    ;      123456789ABCDEF
    #data 0x00
    #align16

TopNamePlayer7:
    #data "       bankbank"
    ;      123456789ABCDEF
    #data 0x00
    #align16


TopNamePlayer8:
    #data " mountainmanjed"
    ;      123456789ABCDEF
    #data 0x00
    #align16

TopNamePlayer9:
    #data "         PREPPY"
    ;      123456789ABCDEF
    #data 0x00
    #align16

TopNamePlayerA:
    #data "      VincentNL"
    ;      123456789ABCDEF
    #data 0x00
    #align16

TopNamePlayerB:
    #data "        Lukepac"
    ;      123456789ABCDEF
    #data 0x00
    #align16


TopNamePlayerC:
    #data "          rob2d"
    ;      123456789ABCDEF
    #data 0x00
    #align16

TopNamePlayerD:
    #data "         DUC DO"
    ;      123456789ABCDEF
    #data 0x00
    #align16

TopNamePlayerE:
    #data "          KHAOS"
    ;      123456789ABCDEF
    #data 0x00
    #align16

TopNamePlayerF:
    #data "          JWONG"
    ;      123456789ABCDEF
    #data 0x00
    #align16


TopNameDefault:
    #data "           WINS"
    ;      123456789ABCDEF
    #data 0x00
    #align16    

TopNameColorList:
    #data 0x2C ; PlayerName0 colorID/fontID
    #data 0x2D ; PlayerName1 colorID/fontID
    #data 0xFF ; PlayerName2 colorID/fontID
    #data 0x10 ; PlayerName3 colorID/fontID
    
    #data 0x17 ; PlayerName4 colorID/fontID
    #data 0x21 ; PlayerName5 colorID/fontID
    #data 0x22 ; PlayerName6 colorID/fontID
    #data 0x23 ; PlayerName7 colorID/fontID
    
    #data 0x24 ; PlayerName8 colorID/fontID
    #data 0x25 ; PlayerName9 colorID/fontID
    #data 0x26 ; PlayerNameA colorID/fontID
    #data 0x27 ; PlayerNameB colorID/fontID

    #data 0x28 ; PlayerNameC colorID/fontID
    #data 0x29 ; PlayerNameD colorID/fontID
    #data 0x2A ; PlayerNameE colorID/fontID
    #data 0x2B ; PlayerNameF colorID/fontID
    #align4

TopNamePaddingList:
    #data 0x0A ; PlayerNameDef paddingByte

    #data 0x09 ; PlayerName0 paddingByte
    #data 0x07 ; PlayerName1 paddingByte
    #data 0x02 ; PlayerName2 paddingByte
    #data 0x03 ; PlayerName3 paddingByte
    
    #data 0x06 ; PlayerName4 paddingByte
    #data 0x03 ; PlayerName5 paddingByte
    #data 0x05 ; PlayerName6 paddingByte
    #data 0x07 ; PlayerName7 paddingByte
    
    #data 0x01 ; PlayerName8 paddingByte
    #data 0x09 ; PlayerName9 paddingByte
    #data 0x06 ; PlayerNameA paddingByte
    #data 0x09 ; PlayerNameB paddingByte

    #data 0x0A ; PlayerNameC paddingByte
    #data 0x09 ; PlayerNameD paddingByte
    #data 0x0A ; PlayerNameE paddingByte
    #data 0x0A ; PlayerNameF paddingByte
    

#align16

;---------------------------------------------------------
;Team Block Data:
; Used with names (nameID) to load preset teams.
; On first character pick
;
;---------------------------------------------------------

NameID_01_TeamList:
    #data nameID_01_TeamStart ; nameID_01_TeamStart
    #data nameID_01_TeamA1 ; nameID_01_TeamA1
    #data nameID_01_TeamA2 ; nameID_01_TeamA2

NameID_02_TeamList:
    #data 0x00000000 ; nameID_02_TeamStart
    #data 0x00000000 ; nameID_02_TeamA1
    #data 0x00000000 ; nameID_02_TeamA2
    
NameID_03_TeamList:
    #data 0x00000000 ; nameID_03_TeamStart
    #data 0x00000000 ; nameID_03_TeamA1
    #data 0x00000000 ; nameID_03_TeamA2

NameID_04_TeamList:
    #data 0x00000000 ; nameID_04_TeamStart
    #data 0x00000000 ; nameID_04_TeamA1
    #data 0x00000000 ; nameID_04_TeamA2

NameID_05_TeamList:
    #data 0x00000000 ; nameID_05_TeamStart
    #data 0x00000000 ; nameID_05_TeamA1
    #data 0x00000000 ; nameID_05_TeamA2

NameID_06_TeamList:
    #data 0x00000000 ; nameID_06_TeamStart
    #data 0x00000000 ; nameID_06_TeamA1
    #data 0x00000000 ; nameID_06_TeamA2

NameID_07_TeamList:
    #data 0x00000000 ; nameID_07_TeamStart
    #data 0x00000000 ; nameID_07_TeamA1
    #data 0x00000000 ; nameID_07_TeamA2

NameID_08_TeamList:
    #data 0x00000000 ; nameID_08_TeamStart
    #data 0x00000000 ; nameID_08_TeamA1
    #data 0x00000000 ; nameID_08_TeamA2

NameID_09_TeamList:
    #data 0x00000000 ; nameID_09_TeamStart
    #data 0x00000000 ; nameID_09_TeamA1
    #data 0x00000000 ; nameID_09_TeamA2

NameID_0A_TeamList:
    #data 0x00000000 ; nameID_0A_TeamStart
    #data 0x00000000 ; nameID_0A_TeamA1
    #data 0x00000000 ; nameID_0A_TeamA2

NameID_0B_TeamList:
    #data 0x00000000 ; nameID_0B_TeamStart
    #data 0x00000000 ; nameID_0B_TeamA1
    #data 0x00000000 ; nameID_0B_TeamA2

NameID_0C_TeamList:
    #data 0x00000000 ; nameID_0C_TeamStart
    #data 0x00000000 ; nameID_0C_TeamA1
    #data 0x00000000 ; nameID_0C_TeamA2

NameID_0D_TeamList:
    #data 0x00000000 ; nameID_0D_TeamStart
    #data 0x00000000 ; nameID_0D_TeamA1
    #data 0x00000000 ; nameID_0D_TeamA2

NameID_0E_TeamList:
    #data 0x00000000 ; nameID_0E_TeamStart
    #data 0x00000000 ; nameID_0E_TeamA1
    #data 0x00000000 ; nameID_0E_TeamA2

NameID_0F_TeamList:
    #data 0x00000000 ; nameID_0F_TeamStart
    #data 0x00000000 ; nameID_0F_TeamA1
    #data 0x00000000 ; nameID_0F_TeamA2

NameID_10_TeamList:
    #data 0x00000000 ; nameID_10_TeamStart
    #data 0x00000000 ; nameID_10_TeamA1
    #data 0x00000000 ; nameID_10_TeamA2


;                                            0x   3    F
; Max Value for characters is 0x3A -> 0x3F = 0b0011 1111

; Assist Encoding
; Assist are 0x00 = 0b0000 0000, 0x00
; Assist are 0x01 = 0b0100 0000, 0x40
; Assist are 0x02 = 0b1000 0000, 0x80

nameID_01_TeamStart:
    #data 0x57 0x75 0x02 ; Cable b, BH b, Guile a.
    #data 0x03 0x03 0x05 ; Colors?
nameID_01_TeamA1:
    #data 0x34 0x75 0x02 ; Sent a, BH b, guile a
    #data 0x04 0x03 0x05 ; Colors?
nameID_01_TeamA2:
    #data 0x2C 0x2A 0x29 ; Mag a, storm a, juggs a
    #data 0x05 0x04 0x01 ; Colors?

; NameID_02_TeamList:
nameID_02_TeamStart:
    #data 0x43 0x73 0x27
nameID_02_TeamA1:
    #data 0x73 0x28 0x24
nameID_02_TeamA2:
    #data 0x28 0x73 0x27


; P1_A:
;----------------------------------------------------------------------------
;      PC  8C03CECE
;----------------------------------------------------------------------------
;      SR  60000200      PR  8C03B1B2     GBR  8C32B420     VBR  8C00F400
;    MACH  00000000    MACL  00000000
;----------------------------------------------------------------------------
;      R0  00000001      R1  8C26823C      R2  8C268340      R3  0000004C
;      R4  8C268340      R5  00000000      R6  00000003      R7  8C28C410
;      R8  8C2681DC      R9  8C11D420     R10  8C14D99C     R11  8C268340
;     R12  00000001     R13  000005A4     R14  8C268340     R15  8C00F398
;----------------------------------------------------------------------------

; P2_A:
;----------------------------------------------------------------------------
;      PC  8C03CECE
;----------------------------------------------------------------------------
;      SR  60000200      PR  8C03B1B2     GBR  8C32B420     VBR  8C00F400
;    MACH  00000000    MACL  000005A4
;----------------------------------------------------------------------------
;      R0  00000001      R1  8C26823C      R2  8C268340      R3  0000004C
;      R4  8C2688E4      R5  00000000      R6  00000003      R7  8C28C410
;      R8  8C2681DC      R9  8C11D420     R10  8C14D99C     R11  8C268340
;     R12  00000001     R13  000005A4     R14  8C2688E4     R15  8C00F398
;----------------------------------------------------------------------------

; P1_B:
;----------------------------------------------------------------------------
;      PC  8C03CECE
;----------------------------------------------------------------------------
;      SR  60000200      PR  8C03B1B2     GBR  8C32B420     VBR  8C00F400
;    MACH  00000000    MACL  00000B48
;----------------------------------------------------------------------------
;      R0  00000001      R1  8C26823C      R2  8C268340      R3  0000004C
;      R4  8C268340      R5  00000000      R6  00000003      R7  8C28C410
;      R8  8C2681DC      R9  8C11D420     R10  8C14D99C     R11  8C268340
;     R12  00000001     R13  000005A4     R14  8C268E88     R15  8C00F398
;----------------------------------------------------------------------------

; P2_B:
;----------------------------------------------------------------------------
;      PC  8C03CECE
;----------------------------------------------------------------------------
;      SR  60000000      PR  8C03B1B2     GBR  8C32B420     VBR  8C00F400
;    MACH  00000000    MACL  000010EC
;----------------------------------------------------------------------------
;      R0  00000001      R1  8C26823C      R2  8C268340      R3  0000004C
;      R4  8C2688E4      R5  00000000      R6  00000003      R7  8C28C410
;      R8  8C2681DC      R9  8C11D420     R10  8C14D99C     R11  8C268340
;     R12  00000001     R13  000005A4     R14  8C26942C     R15  8C00F398
;----------------------------------------------------------------------------

; P1_C:
;----------------------------------------------------------------------------
;      PC  8C03CECE
;----------------------------------------------------------------------------
;      SR  60000200      PR  8C03B1B2     GBR  8C32B420     VBR  8C00F400
;    MACH  00000000    MACL  00001690
;----------------------------------------------------------------------------
;      R0  00000001      R1  8C26823C      R2  8C268340      R3  0000004C
;      R4  8C268340      R5  00000000      R6  00000003      R7  8C28C410
;      R8  8C2681DC      R9  8C11D420     R10  8C14D99C     R11  8C268340
;     R12  00000001     R13  000005A4     R14  8C2699D0     R15  8C00F398
;----------------------------------------------------------------------------



FIRST_READ_END:
    #data 0x00
    #align16
    #data 0x00
    #align16
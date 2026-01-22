; =============================================================================
; PAC-MAN MANAGEMENT
; =============================================================================
            
; -----------------------------------------------------------------------------
PAC_INIT
; INITIALIZE PACMAN.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVE.W  #PAC_START_X,(PAC_POS_X)
                          MOVE.W  #PAC_START_Y,(PAC_POS_Y)
                          ; START LEFT
                          MOVE.W  #1,(PAC_FACE)
                          MOVE.W  #1,(PAC_INTENT)
                          CLR.W   (TOTAL_PELLETS_COL)
                          MOVE.B  #SNDSTART,D7
                          TRAP    #3
                          RTS

; -----------------------------------------------------------------------------
PAC_UPDATE
; UPDATES PACMAN.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVEM.W D0-D7/A0,-(A7)
            
                          ; LOAD CURRENT COORDINATES
                          MOVE.W  (PAC_POS_Y),D0
                          MOVE.W  (PAC_POS_X),D1
                          MOVE.W  (PAC_FACE),D6
            
                          ; SAVE PREVIOUS COORDENATES
                          MOVE.W  D0,(PREVIOUS_PAC_POS_Y)
                          MOVE.W  D1,(PREVIOUS_PAC_POS_X)
            
                          MOVE.W  D0,(NEXT_PAC_POS_Y)
                          MOVE.W  D1,(NEXT_PAC_POS_X)
            
                          BTST.B  #1,(KBDVAL)
                          BEQ     .CHKDWN
                          MOVE.W  #2,(PAC_INTENT)
            
.CHKDWN                   BTST.B  #3,(KBDVAL)
                          BEQ     .CONTINUE 
                          MOVE.W  #4,(PAC_INTENT)
            
.CONTINUE
                          BTST.B  #0,(KBDVAL)
                          BEQ     .CHKRIGHT
                          MOVE.W  #1,(PAC_INTENT)

.CHKRIGHT                 BTST.B  #2,(KBDVAL)
                          BEQ     .DIRECTION
                          MOVE.W  #3,(PAC_INTENT)
                          
.DIRECTION                ; MOVE FORWARD
                          CMP.W   #1,(PAC_INTENT)
                          BEQ     .MVLEFT
                          CMP.W   #2,(PAC_INTENT)
                          BEQ     .MVUP
                          CMP.W   #3,(PAC_INTENT)
                          BEQ     .MVRIGHT
                          BRA     .MVDOWN
            

.MVLEFT                   SUB.W   #PACMAN_SPEED,(NEXT_PAC_POS_X)
                          BRA     .CONT

.MVUP                     SUB.W   #PACMAN_SPEED,(NEXT_PAC_POS_Y)
                          BRA     .CONT

.MVRIGHT                  ADD.W   #PACMAN_SPEED,(NEXT_PAC_POS_X)
                          BRA     .CONT
            
.MVDOWN                   ADD.W   #PACMAN_SPEED,(NEXT_PAC_POS_Y)

.CONT       
                          ; CHECK TOP LEFT 
                          MOVE.W  (NEXT_PAC_POS_Y),D2
                          MOVE.W  (NEXT_PAC_POS_X),D3
                          JSR     CHKCOL
                          BTST.L  #0,D4
                          BNE     .REAL
            
                          ; CHECK BOTTOM RIGHT
                          MOVE.W  (NEXT_PAC_POS_Y),D2
                          MOVE.W  (NEXT_PAC_POS_X),D3 
                          ADD.W   #PACRAD-2,D2
                          ADD.W   #PACRAD-2,D3
                          JSR     CHKCOL
                          BTST.L  #0,D4
                          BNE     .REAL
            
                          ; CHECK TOP RIGHT
                          MOVE.W  (NEXT_PAC_POS_Y),D2
                          MOVE.W  (NEXT_PAC_POS_X),D3 
                          ADD.W   #PACRAD-2,D2
                          JSR     CHKCOL
                          BTST.L  #0,D4
                          BNE     .REAL
            
                          ; CHECK BOTTOM LEFT 
                          MOVE.W  (NEXT_PAC_POS_Y),D2
                          MOVE.W  (NEXT_PAC_POS_X),D3 
                          ADD.W   #PACRAD-2,D3
                          JSR     CHKCOL
                          BTST.L  #0,D4
                          BNE     .REAL
                          BRA     .NOCOL
            
            
.NOCOL                    ; TELEPORT PLAYER BACK TO PLACE
                          MOVE.W  (PAC_INTENT),D6
           
.REAL                     ; UPDATE VARIABLE
                          CLR.W   D7
                          CLR.L   D5    
                          MOVE.W  D6,(PAC_FACE)
                          
                          ; MOVE FORWARD
                          CMP.W   #1,(PAC_FACE)
                          BEQ     .MVLEFT2
                          CMP.W   #2,(PAC_FACE)
                          BEQ     .MVUP2
                          CMP.W   #3,(PAC_FACE)
                          BEQ     .MVRIGHT2
                          BRA     .MVDOWN2
            
.MVLEFT2                  SUB.W   #PACMAN_SPEED,(PAC_POS_X)
                          BRA     .CONT2

.MVUP2                    SUB.W   #PACMAN_SPEED,(PAC_POS_Y)
                          BRA     .CONT2

.MVRIGHT2                 ADD.W   #PACMAN_SPEED,(PAC_POS_X)
                          BRA     .CONT2
            
.MVDOWN2                  ADD.W   #PACMAN_SPEED,(PAC_POS_Y) 
    
.CONT2       
                
                          MOVE.L  #$00000000,A2
                          ; CHECK TOP LEFT 
                          MOVE.W  (PAC_POS_Y),D2
                          MOVE.W  (PAC_POS_X),D3
                          JSR     CHKCOL
                          BTST.L  #0,D4
                          BNE     .ISCOL2
            
                          ; CHECK BOTTOM RIGHT
                          MOVE.W  (PAC_POS_Y),D2
                          MOVE.W  (PAC_POS_X),D3
                          ADD.W   #PACRAD-2,D2
                          ADD.W   #PACRAD-2,D3
                          JSR     CHKCOL
                          BTST.L  #0,D4
                          BNE     .ISCOL2
            
                          ; CHECK TOP RIGHT
                          MOVE.W  (PAC_POS_Y),D2
                          MOVE.W  (PAC_POS_X),D3 
                          ADD.W   #PACRAD-2,D2
                          JSR     CHKCOL
                          BTST.L  #0,D4
                          BNE     .ISCOL2
            
                          ; CHECK BOTTOM LEFT 
                          MOVE.W  (PAC_POS_Y),D2
                          MOVE.W  (PAC_POS_X),D3 
                          ADD.W   #PACRAD-2,D3
                          JSR     CHKCOL
                          BTST.L  #0,D4
                          BNE     .ISCOL2
                          ADD.W   D7,(TOTAL_PELLETS_COL)
                          ADD.L   D5,(CURRENT_SCORE)
                          CMP.W   #0,D5
                          BEQ     .NOSND
                          CMP.W   #10,D5
                          BEQ     .MINISND
                          MOVE.B  #SNDBIGDOT,D7
                          TRAP    #3
                          BRA     .NOSND
.MINISND                  CMP.W   #1,(CHKCHOMP)
                          BEQ     .PLY2
                          MOVE.B  #SNDCHOMP,D7
                          MOVE.W  #1,(CHKCHOMP)
                          TRAP    #3
                          BRA     .NOSND  
.PLY2                     MOVE.B  #SNDCHOMP2,D7
                          MOVE.W  #0,(CHKCHOMP)
                          TRAP    #3 
.NOSND      
                          CLR.W   D7     
                          CLR.L   D5
                          MOVE.B  (A2),D5
                          CMP.W   #5,D5
                          BEQ     .PUT_INTERSECTION   
                          MOVE.B  #$00,(A2)
                          BRA     .CONTINUE9
.PUT_INTERSECTION
                          MOVE.B  #$06,(A2)
.CONTINUE9                CLR.W   D5
                          BRA     .FINISH
            
.ISCOL2      
                          MOVE.W  (PREVIOUS_PAC_POS_Y),(PAC_POS_Y)
                          MOVE.W  (PREVIOUS_PAC_POS_X),(PAC_POS_X)
                          BRA     .FINISH
.FINISH
                          MOVEM.W (A7)+,D0-D7/A0
            
                          RTS

; -----------------------------------------------------------------------------
CHKCOL
; CHECK COLLISIONS.
; INPUT    : D2 - Y
;            D3 - X
; OUTPUT   : D4 - 1: WALL - 0: FREE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVEM.L D0-D3,-(A7)  
            
                          SUB.W   #MAP_START_Y,D2
                          ; IN D2 --> YM
                          DIVU    #CELSIZE,D2
                          SUBQ.W  #1,D2
            
                          SUB.W   #MAP_START_X,D3
                          ; IN D3 --> XM
                          DIVU    #CELSIZE,D3
                          SUBQ.W  #1,D3
            
                          LEA.L   MAPDATA,A0
                          MULU    #MAPWITH,D2                  
                          ADD.W   D3,D2
                          ADD.W   D2,A0
                          CLR.W   D2
                          MOVE.B  (A0),D2
            
                          MULU    #6,D2
                          MOVE.L  D2,A1
                          JMP     .JUMPLIST(A1)

.JUMPLIST:   
                          JMP     .ISFREE
                          JMP     .ISWALL
                          JMP     .ISMINIDOT
                          JMP     .ISGIGADOT
                          JMP     .ISPORTAL
                          JMP     .ISMINIDOT
                          JMP     .ISFREE
            
.ISFREE
                          MOVE.W  #0,D4
                          BRA     .RETURN
                          
.ISWALL
                          MOVE.W  #1,D4
                          BRA     .RETURN
            
.ISMINIDOT
                          MOVE.W  #0,D4
                          ; ADD SCORE
                          MOVE.L  #10,D5
                          MOVE.W  #1,D7
                          MOVE.W  A0,A2
            
                          BRA     .RETURN
            
.ISGIGADOT
                          MOVE.W  #0,D4
                          ; ADD SCORE
                          MOVE.L  #50,D5
                          MOVE.W  #1,D7
                          MOVE.W  A0,A2
                          ; RESTART TIMERS
                          CLR.W   (BLINKY_FRIGHTENED_TIMER)  
                          CLR.W   (PINKY_FRIGHTENED_TIMER)
                          CLR.W   (INKY_FRIGHTENED_TIMER)  
                          CLR.W   (CLYDE_FRIGHTENED_TIMER)
                          
                          ; SCARE GHOSTS
                          MOVE.W  #1,(BLINKY_IS_BLUE)
                          MOVE.W  #1,(PINKY_IS_BLUE)
                          MOVE.W  #1,(INKY_IS_BLUE)
                          MOVE.W  #1,(CLYDE_IS_BLUE)
            
                          BRA     .RETURN
.ISPORTAL
                          ;TELEPORT PACMAN TO THE OTHER SIDE OF THE MAP
                          MOVE.W  #PORTAL_RIGHT_X,D0
                          CMP.W   (NEXT_PAC_POS_X),D0

                          BLT     .RIGHTSIDE
            
                          ; TELEPORT TO RIGHT SIDE
                          MOVE.W  #PORTAL_RIGHT_X+CELSIZE,D0
                          MOVE.W  D0,(PAC_POS_X)
                          MOVE.W  #1,(PAC_FACE)
                          CLR.W   D4 
                          BRA     .RETURN  
            
.RIGHTSIDE
                          ; TELEPORT TO LEFT SIDE
                          MOVE.W  #PORTAL_LEFT_X-CELSIZE,D0
                          MOVE.W  D0,(PAC_POS_X)
                          MOVE.W  #3,(PAC_FACE)
       
.RETURN
                          MOVEM.L (A7)+,D0-D3  
                          RTS
            
; -----------------------------------------------------------------------------
PAC_PLOT
; PLOTS PACMAN.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------

                          MOVEM.L D0-D4,-(A7)   

                          CMP.W   #1,(PAC_FACE)
                          BEQ     .DRAW_L
                          CMP.W   #2,(PAC_FACE)
                          BEQ     .DRAW_U
                          CMP.W   #3,(PAC_FACE)
                          BEQ     .DRAW_R
                          BRA     .DRAW_D
            
.DRAW_L
                          BTST.B  #4,(SCRCYCCT)
                          BEQ     .LFT2
                          LEA     PC_LEFT2,A0
                          BRA     .DRAW
.LFT2                     LEA     PC_LEFT3,A0
                          BRA     .DRAW
                          
.DRAW_U
                          BTST.B  #4,(SCRCYCCT)
                          BEQ     .U2
                          LEA     PC_UP2,A0
                          BRA     .DRAW
.U2                       LEA     PC_UP3,A0
                          BRA     .DRAW
.DRAW_R
                          BTST.B  #4,(SCRCYCCT)
                          BEQ     .RH2
                          LEA     PC_RIGHT2,A0
                          BRA     .DRAW
.RH2
                          LEA     PC_RIGHT3,A0
                          BRA     .DRAW
.DRAW_D            

                          BTST.B  #4,(SCRCYCCT)
                          BEQ     .DW2          
                          LEA     PC_DOWN2,A0
                          BRA     .DRAW
.DW2
                          LEA     PC_DOWN3,A0


.DRAW                     ; INT J
                          MOVE.W  (PAC_POS_Y),D7
                          SUB.W   #PACRAD,D7
                          MOVE.L  #15,D3

.LOOP1       
                          ; INT I 
                          MOVE.W  (PAC_POS_X),D6    
                          SUB.W   #PACRAD,D6
                          MOVE.L  #15,D4
.LOOP2
                          ; SET FILL COLOR
                          MOVE.L  (A0)+,D1
                          BTST    #8,D1
                          BEQ     .NEXT
                          MOVE.B  #80,D0
                          TRAP    #15
            
                          ; DRAW PIXEL
                          MOVE.L  D6,D1
                          MOVE.W  D7,D2
                          MOVE.B  #82,D0
                          TRAP    #15
            
.NEXT                     ADD.W   #1,D6
                          DBRA    D4, .LOOP2
                          ADD.W   #1,D7
                          DBRA    D3, .LOOP1

                          MOVEM.L (A7)+,D0-D4

                          RTS





*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~

; =============================================================================
; INKY
; =============================================================================

; -----------------------------------------------------------------------------
INKY_INIT
; INITIALIZE INKY.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVE.W  #INKY_START_X,(INKY_POS_X)
                          MOVE.W  #INKY_START_Y,(INKY_POS_Y)
                          ; START UP
                          MOVE.W  #2,(INKY_DIR)
                          ; WE START ALWAYS IN SCATER MODE
                          MOVE.W  #1, (INKY_SCATER_ON)
                          CLR.W   (INKY_CHASE_ON)
                          CLR.W   (INKY_SCATERTIMER)
                          CLR.W   (INKY_CHASETIMER)
                          CLR.W   (INKY_MODE_SWITCH_COUNT)
                          MOVE.L  #LIGHT_BLUE,(INKY_COLOR)
                          CLR.W   (INKY_IS_BLUE)
                          CLR.W   (INKY_FRIGHTENED_TIMER)
                          CLR.W   (INKY_ESTADO)
                          MOVE.W  #2,(INKY_SPEED)
                          RTS
                
; -----------------------------------------------------------------------------
INKY_UPDATE
; UPDATES INKY.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
    
                          MOVEM.W D0-D7/A0,-(A7)
                 
                
                          CMP.W   #0,(INKY_ESTADO)
                          BEQ     .IS_HOME
                          CMP.W   #1,(INKY_ESTADO)
                          BEQ     .IS_HOME
                          CMP.W   #2,(INKY_ESTADO)
                          BEQ     .IS_HOME
                          CMP.W   #3,(INKY_ESTADO)
                          BEQ     .IS_HOME
                          CMP.W   #1,(INKY_IS_BLUE)
                          BEQ     .FRIGHTENED_MODE
            
                          JSR     MODE_UPDATE_INKY
                          MOVE.W  (INKY_POS_X),D0
                          MOVE.W  (INKY_POS_Y),D1
                          
                          ; MOVE FORWARD
                          CMP.W   #1,(INKY_DIR)
                          BEQ     .MVLEFT
                          CMP.W   #2,(INKY_DIR)
                          BEQ     .MVUP
                          CMP.W   #3,(INKY_DIR)
                          BEQ     .MVRIGHT
                          BRA     .MVDOWN
           
.MVLEFT                   SUB.W   (INKY_SPEED),D0
                          BRA     .CONT
    
.MVUP                     SUB.W   (INKY_SPEED),D1
                          BRA     .CONT
    
.MVRIGHT                  ADD.W   (INKY_SPEED),D0
                          BRA     .CONT
                
.MVDOWN                   ADD.W   (INKY_SPEED),D1
    
.CONT         
                          MOVE.W  D0,(INKY_POS_X)
                          MOVE.W  D1,(INKY_POS_Y)
                 
                          ; CHECK TOP LEFT 
                          MOVE.W  (INKY_POS_Y),D2
                          MOVE.W  (INKY_POS_X),D3
                          JSR     CHECK_COLLISIONS_INKY
                          BTST.L  #0,D4
                          BEQ     .DONE
                
                          ; CHECK BOTTOM RIGHT
                          MOVE.W  (INKY_POS_Y),D2
                          MOVE.W  (INKY_POS_X),D3
                          ADD.W   #PACRAD-1,D2
                          ADD.W   #PACRAD-1,D3
                          JSR     CHECK_COLLISIONS_INKY
                          BTST.L  #0,D4
                          BEQ     .DONE
                
                          ; CHECK TOP RIGHT
                          MOVE.W  (INKY_POS_Y),D2
                          MOVE.W  (INKY_POS_X),D3 
                          ADD.W   #PACRAD-1,D2
                          JSR     CHECK_COLLISIONS_INKY
                          BTST.L  #0,D4
                          BEQ     .DONE
                
                          ; CHECK BOTTOM LEFT 
                          MOVE.W  (INKY_POS_Y),D2
                          MOVE.W  (INKY_POS_X),D3 
                          ADD.W   #PACRAD-1,D3
                          JSR     CHECK_COLLISIONS_INKY
                          BTST.L  #0,D4
                          BEQ     .DONE
    
                          ; HE IS IN INTERSECTION
                          LEA.L   INKY_ALLOWED_DIR,A1
                          ; INITIALIZE ARRAY TO 1
                          MOVE.L  #$01010101,(A1)
                
                          MOVE.W  (INKY_DIR),D1
                
                          CMP.W   #1,D1
                          BNE     .CHKUP
                          ; MOVE 0 TO POS 2 IN ARRAY
                          MOVE.B  #0,2(A1)
                          BRA     .CONT2
    
.CHKUP                    CMP.W   #2,D1
                          BNE     .CHKRIGHT
                          ; MOVE 0 TO POS 3 IN ARRAY
                          MOVE.B  #0,3(A1)
                          BRA     .CONT2
                
.CHKRIGHT                 CMP.W   #3,D1
                          BNE     .CHKDOWN
                          ; MOVE 0 TO POS 0 IN ARRAY
                          MOVE.B  #0,(A1)
                          BRA     .CONT2
                
.CHKDOWN                  CMP.W   #4,D1
                          BNE     .CONT2
                          ; MOVE 0 TO POS 1 IN ARRAY
                          MOVE.B  #0,1(A1)
                          
                          ; WE REMOVED THE DIRECTION HE IS FACING TO
                          ; WHEN HE ENTERED THE INTERSECTION FROM THE TUPLE
                          ; NOW WE REMOVE THE DIRECTIONS WITH WALL
.CONT2                    MOVE.W  (INKY_POS_X),D0
                          MOVE.W  (INKY_POS_Y),D1
                          JSR     GETMAPCOORDS_INKY
                
                          MOVE.W  D0,D2      ; XM
                          MOVE.W  D1,D3      ; YM
                
                          ; LEFT SIDE
                          SUBQ.B  #1,D2
                          JSR     MAPGET_INKY
                          CMP.W   #1,D4
                          BNE     .CHKMAPUP
                          MOVE.B  #0,(A1)
                
.CHKMAPUP
                          MOVE.W  D0,D2      ; XM
                          MOVE.W  D1,D3      ; YM
                
                          ; UP SIDE
                          SUBQ.B  #1,D3
                          JSR     MAPGET_INKY
                          CMP.W   #1,D4
                          BNE     .CHKMAPRIGHT
                          MOVE.B  #0,1(A1)
                
.CHKMAPRIGHT
                          MOVE.W  D0,D2      ; XM
                          MOVE.W  D1,D3      ; YM
                
                          ; RIGHT SIDE
                          ADDQ.B  #1,D2
                          JSR     MAPGET_INKY
                          CMP.W   #1,D4
                          BNE     .CHKMAPDOWN
                          MOVE.B  #0,2(A1)
    
.CHKMAPDOWN
                          MOVE.W  D0,D2      ; XM
                          MOVE.W  D1,D3      ; YM
                
                          ; DOWN SIDE
                          ADDQ.B  #1,D3
                          JSR     MAPGET_INKY
                          CMP.W   #1,D4
                          BNE     .CONT3
                          MOVE.B  #0,3(A1)
                
.CONT3                    ; WE HAVE REMOVED THE DIRECTIONS WITH WALL 
                          ; FROM THE TUPLE NOW WE HAVE TO CALCULATE 
                          ; THE EUCYDEAN DISTANCE FROM THE ALLOWED DIRECTIONS
                
                          LEA.L   INKY_EUCYDEAN_DIS,A2
                          MOVE.W  (INKY_POS_X),D0
                          MOVE.W  (INKY_POS_Y),D1
    
                          ; RECAP
                          ; A1 - INKY_ALLOWED_DIR
                          ; A2 - INKY_EUCYDEAN_DIS
                          ; D0 - X
                          ; D1 - Y
                
                          MOVE.L  #$7F7F7F7F,(A2)
                          MOVE.L  #$7F7F7F7F,4(A2)
                
                          CMP.B   #1,(A1)
                          BNE     .CALCUP
                          ; CALC LEFT
                          MOVE.W  D0,D2      ; X
                          MOVE.W  D1,D3      ; Y
                
                          SUB.W  #CELSIZE,D2
                          JSR     CALCDIS_INKY
                          MOVE.W  D3,(A2)
                
.CALCUP                   CMP.B   #1,1(A1)
                          BNE     .CALCRIGHT
                          ; CALC UP
                          MOVE.W  D0,D2      ; X
                          MOVE.W  D1,D3      ; Y
                
                          SUB.W  #CELSIZE,D3
                          JSR     CALCDIS_INKY
                          MOVE.W  D3,2(A2)
                
.CALCRIGHT                CMP.B   #1,2(A1)
                          BNE     .CALCDOWN
                          ; CALC RIGHT
                          MOVE.W  D0,D2      ; X
                          MOVE.W  D1,D3      ; Y
                
                          ADD.W  #CELSIZE,D2
                          JSR     CALCDIS_INKY
                          MOVE.W  D3,4(A2)
                
.CALCDOWN                 CMP.B   #1,3(A1)
                          BNE     .CONT4
                          ; CALC DOWN
                          MOVE.W  D0,D2      ; X
                          MOVE.W  D1,D3      ; Y
                          
                          ADD.W  #CELSIZE,D3
                          JSR     CALCDIS_INKY
                          MOVE.W  D3,6(A2)
                
.CONT4                    ; WE HAVE THE VALID DISTANCES, 
                          ; NOW HE WILL GO THRU THE SHORTEST PATH
                          JSR FIND_MIN_INKY
                          MOVE.W  D1,(INKY_DIR)
                
.DONE       
                          ; CHECK BOTTOM RIGHT
                          MOVE.W  (INKY_POS_Y),D2
                          MOVE.W  (INKY_POS_X),D3
                          ADD.W   #PACRAD-1,D2
                          ADD.W   #PACRAD-1,D3
                          JSR     CHECK_COLLISIONS_INKY
              
                          ; CHECK IF INKY KILLED PACMAN
                          ; D0 = INKY X
                          ; D1 = INKY Y
                          MOVE.W  (INKY_POS_X),D0
                          MOVE.W  (INKY_POS_Y),D1
                          ; D2 = PACMAN X
                          ; D3 = PACMAN Y
                          MOVE.W  (PAC_POS_X),D2
                          MOVE.W  (PAC_POS_Y),D3
    
                          ; ABSOLUTE DISTANCE
                          SUB.W   D2,D0      ; D0 = |INKY X - PACMAN X|
                          TST.W   D0
                          BPL     .CHECK_Y
                          NEG.W   D0
    
.CHECK_Y
                          SUB.W   D3,D1      ; D1 = |INKY Y - PACMAN Y|
                          TST.W   D1
                          BPL     .SUM_DIST
                          NEG.W   D1
    
.SUM_DIST
                          ADD.W   D0,D1
              
                          ; COLLISION
                          CMP.W   #PACRAD,D1
                          BGE     .NO_COLLISION
                          SUBQ.W  #1,(PACMAN_LIVES)
                
                          ; TELEPORT BOTH TO STARTING POSITION
                          MOVE.B  #SNDDEATH,D7
                          TRAP    #3
                          JSR RESTART

.NO_COLLISION
                          BRA     .MEGADONE
          
.FRIGHTENED_MODE        
                          ADDQ    #1,(INKY_FRIGHTENED_TIMER)
                          MOVE.W  #1,(INKY_SPEED)                     
                          MOVE.L  #DARK_BLUE,(INKY_COLOR)
                          MOVE.W  (INKY_POS_X),D0
                          MOVE.W  (INKY_POS_Y),D1
                
                          ; MOVE FORWARD
                          CMP.W   #1,(INKY_DIR)
                          BEQ     .MVLEFTF
                          CMP.W   #2,(INKY_DIR)
                          BEQ     .MVUPF
                          CMP.W   #3,(INKY_DIR)
                          BEQ     .MVRIGHTF
                          BRA     .MVDOWNF
           
.MVLEFTF                  SUB.W   (INKY_SPEED),D0
                          BRA     .CONTF
    
.MVUPF                    SUB.W   (INKY_SPEED),D1
                          BRA     .CONTF
    
.MVRIGHTF                 ADD.W   (INKY_SPEED),D0
                          BRA     .CONTF
                
.MVDOWNF                  ADD.W   (INKY_SPEED),D1
    
.CONTF         
                          MOVE.W  D0,(INKY_POS_X)
                          MOVE.W  D1,(INKY_POS_Y)
  
                          ; CHECK TOP LEFT 
                          MOVE.W  (INKY_POS_Y),D2
                          MOVE.W  (INKY_POS_X),D3
                          JSR     CHECK_COLLISIONS_INKY
                          BTST.L  #0,D4
                          BEQ     .DONEF
                
                          ; CHECK BOTTOM RIGHT
                          MOVE.W  (INKY_POS_Y),D2
                          MOVE.W  (INKY_POS_X),D3
                          ADD.W   #PACRAD-1,D2
                          ADD.W   #PACRAD-1,D3
                          JSR     CHECK_COLLISIONS_INKY
                          BTST.L  #0,D4
                          BEQ     .DONEF
                
                          ; CHECK TOP RIGHT
                          MOVE.W  (INKY_POS_Y),D2
                          MOVE.W  (INKY_POS_X),D3 
                          ADD.W   #PACRAD-1,D2
                          JSR     CHECK_COLLISIONS_INKY
                          BTST.L  #0,D4
                          BEQ     .DONEF
                
                          ; CHECK BOTTOM LEFT 
                          MOVE.W  (INKY_POS_Y),D2
                          MOVE.W  (INKY_POS_X),D3 
                          ADD.W   #PACRAD-1,D3
                          JSR     CHECK_COLLISIONS_INKY
                          BTST.L  #0,D4
                          BEQ     .DONEF
                
                          ; HE IS IN INTERSECTION
                          LEA.L   INKY_ALLOWED_DIR,A1
                          ; INITIALIZE ARRAY TO 1
                          MOVE.L  #$01010101,(A1)
                
                          ; NOW WE REMOVE THE DIRECTIONS WITH WALL
.CONT2F                   MOVE.W  (INKY_POS_X),D0
                          MOVE.W  (INKY_POS_Y),D1
                          JSR     GETMAPCOORDS_INKY
                
                          MOVE.W  D0,D2      ; XM
                          MOVE.W  D1,D3      ; YY
                
                          ; LEFT SIDE
                          SUBQ.B  #1,D2
                          JSR     MAPGET_INKY
                          CMP.W   #1,D4
                          BNE     .CHKMAPUPF
                          MOVE.B  #0,(A1)
                
.CHKMAPUPF
                          MOVE.W  D0,D2      ; XM
                          MOVE.W  D1,D3      ; YM
                
                          ; UP SIDE
                          SUBQ.B  #1,D3
                          JSR     MAPGET_INKY
                          CMP.W   #1,D4
                          BNE     .CHKMAPRIGHTF
                          MOVE.B  #0,1(A1)
                
.CHKMAPRIGHTF
                          MOVE.W  D0,D2      ; XM
                          MOVE.W  D1,D3      ; YM
                
                          ; RIGHT SIDE
                          ADDQ.B  #1,D2
                          JSR     MAPGET_INKY
                          CMP.W   #1,D4
                          BNE     .CHKMAPDOWNF
                          MOVE.B  #0,2(A1)
    
.CHKMAPDOWNF
                          MOVE.W  D0,D2      ; XM
                          MOVE.W  D1,D3      ; YM
                
                          ; DOWN SIDE
                          ADDQ.B  #1,D3
                          JSR     MAPGET_INKY
                          CMP.W   #1,D4
                          BNE     .CONT3F
                          MOVE.B  #0,3(A1)
                
.CONT3F                   ; WE HAVE REMOVED THE DIRECTIONS WITH WALL 
                          ; FROM THE TUPLE NOW WE HAVE TO CALCULATE 
                          ; THE EUCYDEAN DISTANCE FROM THE ALLOWED DIRECTIONS
                
                          LEA.L   INKY_EUCYDEAN_DIS,A2
                          MOVE.W  (INKY_POS_X),D0
                          MOVE.W  (INKY_POS_Y),D1
    
                          ; RECAP
                          ; A1 - INKY_ALLOWED_DIR
                          ; A2 - INKY_EUCYDEAN_DIS
                          ; D0 - X
                          ; D1 - Y
                
                          MOVE.L  #$00000000,(A2)
                          MOVE.L  #$00000000,4(A2)
                
                          CMP.B   #1,(A1)
                          BNE     .CALCUPF
                          ; CALC LEFT
                          MOVE.W  D0,D2      ; X
                          MOVE.W  D1,D3      ; Y
                
                          SUB.W  #CELSIZE,D2
                          JSR     CALCDIS_INKY
                          MOVE.W  D3,(A2)
                
.CALCUPF                  CMP.B   #1,1(A1)
                          BNE     .CALCRIGHTF
                          ; CALC UP
                          MOVE.W  D0,D2      ; X
                          MOVE.W  D1,D3      ; Y
                
                          SUB.W  #CELSIZE,D3
                          JSR     CALCDIS_INKY
                          MOVE.W  D3,2(A2)
                
.CALCRIGHTF               CMP.B   #1,2(A1)
                          BNE     .CALCDOWNF
                          ; CALC RIGHT
                          MOVE.W  D0,D2      ; X
                          MOVE.W  D1,D3      ; Y
                
                          ADD.W  #CELSIZE,D2
                          JSR     CALCDIS_INKY
                          MOVE.W  D3,4(A2)
                
.CALCDOWNF                CMP.B   #1,3(A1)
                          BNE     .CONT4F
                          ; CALC DOWN
                          MOVE.W  D0,D2      ; X
                          MOVE.W  D1,D3      ; Y
                
                          ADD.W  #CELSIZE,D3
                          JSR     CALCDIS_INKY
                          MOVE.W  D3,6(A2)
                
.CONT4F                   ; WE HAVE THE VALID DISTANCES, NOW HE WILL GO
                          ; THRU THE SHORTENEST PATH
                          JSR FIND_MAX_INKY
                          MOVE.W  D1,(INKY_DIR)
                          CMP.W   #FRIGHTENED,(INKY_FRIGHTENED_TIMER)
                          BGT     .BC_TIME  
.DONEF      
                          ; CHECK BOTTOM RIGHT
                          MOVE.W  (INKY_POS_Y),D2
                          MOVE.W  (INKY_POS_X),D3
                          ADD.W   #PACRAD-1,D2
                          ADD.W   #PACRAD-1,D3
                          JSR     CHECK_COLLISIONS_INKY
              
                          ; CHECK IF PACMAN KILLED INKY
                          ; D0 = INKY X
                          ; D1 = INKY Y
                          MOVE.W  (INKY_POS_X),D0
                          MOVE.W  (INKY_POS_Y),D1
                          ; D2 = PACMAN X
                          ; D3 = PACMAN Y
                          MOVE.W  (PAC_POS_X),D2
                          MOVE.W  (PAC_POS_Y),D3
    
                          ; ABSOLUTE DISTANCE
                          SUB.W   D2,D0      ; D0 = |INKY X - PACMAN X|
                          TST.W   D0
                          BPL     .CHECK_YF
                          NEG.W   D0
    
.CHECK_YF
                          SUB.W   D3,D1      ; D1 = |INKY Y - Pac-Man Y|
                          TST.W   D1
                          BPL     .SUM_DISTF
                          NEG.W   D1
    
.SUM_DISTF
                          ADD.W   D0,D1
    
                          ; COLLISION
                          CMP.W   #PACRAD,D1
                          BGE     .NO_COLLISIONF
                          ; TELEPORT BACK TO HIS HOME
                          ; REPRODUCE SOUND
                          MOVE.B  #SNDEATGHOS,D7
                          TRAP    #3
                          MOVE.W  #INKY_START_X,(INKY_POS_X)
                          MOVE.W  #INKY_START_Y,(INKY_POS_Y)
                          ADD.L  #200,(CURRENT_SCORE)
                          CLR.W   (INKY_IS_BLUE)
                          MOVE.W  #2,(INKY_SPEED)
                          MOVE.L  #LIGHT_BLUE,(INKY_COLOR)
                          MOVE.W  #1,(INKY_ESTADO)
                          MOVE.W  #2,(INKY_DIR)    
.NO_COLLISIONF
                          BRA     .MEGADONE
.BC_TIME  
                          CLR.W   (INKY_IS_BLUE)          
                          MOVE.W  #2,(INKY_SPEED)
                          MOVE.L  #LIGHT_BLUE,(INKY_COLOR)
                          CLR.W   (INKY_FRIGHTENED_TIMER)
                          BRA .MEGADONE
.IS_HOME
                          CLR.W   (INKY_IS_BLUE)
                          MOVE.W  (INKY_POS_X),D0
                          MOVE.W  (INKY_POS_Y),D1
                          
                          ; MOVE FORWARD
                          CMP.W   #1,(INKY_DIR)
                          BEQ     .MVLEFTH
                          CMP.W   #2,(INKY_DIR)
                          BEQ     .MVUPH
                          CMP.W   #3,(INKY_DIR)
                          BEQ     .MVRIGHTH
                          BRA     .MVDOWNH
           
.MVLEFTH                  SUB.W   (INKY_SPEED),D0
                          BRA     .CONTH
    
.MVUPH                    SUB.W   (INKY_SPEED),D1
                          BRA     .CONTH
    
.MVRIGHTH                 ADD.W   (INKY_SPEED),D0
                          BRA     .CONTH
                
.MVDOWNH                  ADD.W   (INKY_SPEED),D1
.CONTH
                          MOVE.W  D0,(INKY_POS_X)
                          MOVE.W  D1,(INKY_POS_Y)
                          
                          CMP.W   #2,(INKY_ESTADO)
                          BEQ     .LEAVING_HOME
                          CMP.W   #3,(INKY_ESTADO)
                          BEQ     .LEFT_HOME

                          CMP.W  #336,(INKY_POS_Y)
                          BLT    .DOWN_HOUSE
                          BRA    .CHECK_U_H
.DOWN_HOUSE     
                          MOVE.W #4,(INKY_DIR)
                
.CHECK_U_H                CMP.W  #368,(INKY_POS_Y)
                          BGT    .UP_HOUSE
                          BRA    .CHKMIDH

.UP_HOUSE     
                          MOVE.W #2,(INKY_DIR)
                
.CHKMIDH                  ; IF IF MIDDLE AND IF TIME OUT
                          CMP.W  #352,(INKY_POS_Y)
                          BNE    .MEGADONE
                          CMP.W  #1,(INKY_ESTADO) ; TIME OUT
                          BNE    .MEGADONE
                
                          MOVE.W  #3,(INKY_DIR)
                          CMP.W   #408,(INKY_POS_X)
                          BLT     .MEGADONE
                          MOVE.W  #2,(INKY_ESTADO)
                          BRA     .MEGADONE
                
.LEAVING_HOME
                         MOVE.W  #2,(INKY_DIR)
                         MOVE.W  #3,(INKY_ESTADO)
                         BRA     .MEGADONE

.LEFT_HOME
                         CMP.W   #BLINKY_START_Y,(INKY_POS_Y)
                         BGT     .MEGADONE
                         MOVE.W  #1,(INKY_DIR)
                         MOVE.W  #4,(INKY_ESTADO)
                         BRA     .MEGADONE

.MEGADONE
    
                          MOVEM.W (A7)+,D0-D7/A0
                          RTS
; -----------------------------------------------------------------------------
CHECK_COLLISIONS_INKY
; CHECK COLLISIONS.
; INPUT    : D2 - Y
;            D3 - X
; OUTPUT   : D4 - 1: INTERSECTION - 0: NO INTERSECTION
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVEM.L D0-D3,-(A7)
                          ; IN D2 --> YM
                          SUB.W   #MAP_START_Y,D2
                          DIVU    #CELSIZE,D2
                          SUBQ.W  #1,D2
                          ; IN D3 --> XM
                          SUB.W   #MAP_START_X,D3
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
                          JMP     .RETURN
                          JMP     .IS_WALL
                          JMP     .RETURN
                          JMP     .RETURN
                          JMP     .ISPORTAL
                          JMP     .IS_INTER
                          JMP     .IS_INTER
.IS_WALL
                          MOVE.L  #2,D4
                          BRA     .RETURN
.ISPORTAL
                          ; TELEPORT INKY TO THE OTHER SIDE OF THE MAP
                          MOVE.W  #PORTAL_RIGHT_X,D0
                          CMP.W   (INKY_POS_X),D0
    
                          BLT     .RSIDE
                
                          ; TELEPORT TO RIGHT SIDE
                          MOVE.W  #PORTAL_RIGHT_X+CELSIZE,D0
                          MOVE.W  D0,(INKY_POS_X)
                          MOVE.W  #1,(INKY_DIR)
                          BRA     .RETURN   
                
.RSIDE
                          ; TELEPORT TO LEFT SIDE
                          MOVE.W  #PORTAL_LEFT_X-CELSIZE,D0
                          MOVE.W  D0,(INKY_POS_X)
                          MOVE.W  #3,(INKY_DIR)
                          BRA     .RETURN
                
.IS_INTER
                          MOVE.L  #1,D4
                          BRA     .FINISH
.RETURN
                          MOVE.L  #0,D4
.FINISH            
                          MOVEM.L (A7)+,D0-D3
                          RTS         
; -----------------------------------------------------------------------------
GETMAPCOORDS_INKY
; RETURN MAP ROW AND COLUMN.
; INPUT    : D0 - X
;            D1 - Y
; OUTPUT   : D0 - X
;            D1 - Y
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          SUB.W   #MAP_START_Y,D1
                          ; IN D1 --> YM
                          DIVU    #CELSIZE,D1
                          SUBQ.W  #1,D1
                
                          SUB.W   #MAP_START_X,D0
                          ; IN D0 --> XM
                          DIVU    #CELSIZE,D0
                          SUBQ.W  #1,D0
                
                          RTS
                
; -----------------------------------------------------------------------------
MAPGET_INKY
; RETURN MAP TILE.
; INPUT    : D2 - X
;            D3 - Y
; OUTPUT   : D4 - 1: WALL - 0: NO WALL
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVEM.L D2-D3/A0,-(A7)
                          LEA.L   MAPDATA,A0
                          MULU    #MAPWITH,D3                  
                          ADD.W   D2,D3
                          ADD.W   D3,A0
                          CLR.W   D3
                          MOVE.B  (A0),D4
                          MOVEM.L (A7)+,D2-D3/A0
                          RTS
                          
; -----------------------------------------------------------------------------
MODE_UPDATE_INKY
; UPDATE MODES.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          ; CHECK IF WE HAVE REACHED 6 CHANGES
                          CMP.W   #MAX_MODE_SWITCH, (INKY_MODE_SWITCH_COUNT)
                          ; IF WE HAVE REACHED 6 CHANGES WE KEEP ON 
                          ; CHASE MODE FOR THE REST OF THE GAME
                          BGE     .PERM 
                          ; CHECK IF CHASE IS ON
                          CMP.W   #1, (INKY_CHASE_ON)
                          BEQ     .IN_C_MODE
                          ; CHECK IF SCATTER IS ON
                          CMP.W   #1, (INKY_SCATER_ON)
                          BEQ     .IN_S_MODE
                          ; IF NOTHING IS ON THEN GO TO END
                          BRA     .END
    
.IN_C_MODE
                          ; IF CHASE IS ON
                          ; ++ THE CHASE TIMER
                          ADDQ.W  #1, (INKY_CHASETIMER)
                          ; IF TIMER IS BIGGER THAN #CHASE
                          CMP.W   #CHASE, (INKY_CHASETIMER)
                          BGT     .SW_TO_S_MODE
                          ; IF NOT WE END UPDATE
                          BRA     .END
    
.IN_S_MODE
                          ; IF SCATTER IS ON
                          ; ++ TIMER 
                          ADDQ.W  #1, (INKY_SCATERTIMER)
                          ; IF TIMER IS BIGGER THAN #SCATTER
                          CMP.W   #SCATER, (INKY_SCATERTIMER)
                          BGT     .SW_TO_C_MODE
                          ; IF NOT END UPDATE
                          BRA     .END
    
.SW_TO_S_MODE
                          ; SCATTER IS NOW ON
                          MOVE.W  #1, (INKY_SCATER_ON)
                          ; IF SCATTER IS ON CHASE IS OFF AND ITS TIMER IS 0
                          CLR.W   (INKY_CHASE_ON)
                          CLR.W   (INKY_SCATERTIMER)
        
                          ; IF WE EVER ENTER THIS CODE PART IS 
                          ; BECAUSE WE MADE 1 SWITCH
                          ; MODE_SWITCH_COUNT++
                          ADDQ.W  #1, (INKY_MODE_SWITCH_COUNT)
                
                          BRA     .END
    
.SW_TO_C_MODE
                          ; CHASE IS NOW ON
                          MOVE.W  #1, (INKY_CHASE_ON)
                          ; IF CHASE IS ON SCATTER IS OFF AND ITS TIMER IS 0
                          CLR.W   (INKY_SCATER_ON)
                          CLR.W   (INKY_CHASETIMER)
        
                          ; IF WE EVER ENTER THIS CODE PART IS 
                          ; BECAUSE WE MADE 1 SWITCH
                          ; MODE_SWITCH_COUNT++
                          ADDQ.W  #1, (INKY_MODE_SWITCH_COUNT)
    
                          BRA     .END
    
.PERM
                          ; IF WE ENTER THIS PART OF THE CODE THERE 
                          ; IS NO MORE SWITHCING IN BETWEN MODES
                          ; SO CHASES IS ON AND SCATER OFF 
                          ; SCATER TIMER 0
                          ; AND CHASE TIMER 0
                          MOVE.W  #1, (INKY_CHASE_ON)
                          CLR.W   (INKY_SCATER_ON)
                          CLR.W   (INKY_CHASETIMER)
                          CLR.W   (INKY_SCATERTIMER)
.END
                          RTS
                           
; -----------------------------------------------------------------------------
CALCDIS_INKY
; CALC DIS TO TARGET.
; INPUT    : D2 - X
;            D3 - Y
; OUTPUT   : D3 - EUCYDEAN DISTANCE TO TARGET
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVEM.W  D0-D2,-(A7)
                
                          ; IF IS BLUE IS ON WE SET PACMAN AS THE TARGET
                          CMP.W   #1, (INKY_IS_BLUE)
                          BEQ     .SET_PAC_TAR
                          ; IF CHASE IS ON WE SET PACMAN AS THE TARGET
                          CMP.W   #1, (INKY_CHASE_ON)
                          BEQ     .SET_C_TAR
                          ; IF SCATTER IS ON WE SET INKY'S HOME AS THE TARGET
                          CMP.W   #1, (INKY_SCATER_ON)
                          BEQ     .SET_S_TAR
                          ; IF NONE OF THEM ARE ON WE SET THE TARGET TO PACMAN
                          BRA     .DEFAULT_TARGET
    
.SET_C_TAR
                          MOVE.W  (PAC_POS_X),D0
                          MOVE.W  (PAC_POS_Y),D1
                
                          ; DOUBLE THE DISTANCE FROM BLINKY TO PACMAN
                          CMP.W   #1,(PAC_FACE)
                          BEQ     .ADDLEFT
                          CMP.W   #2,(PAC_FACE)
                          BEQ     .ADDUP
                          CMP.W   #3,(PAC_FACE)
                          BEQ     .ADDRIGHT
                          BRA     .ADDDOWN
                
.ADDLEFT
                          SUB.W   #32,D0
                          BRA     .CALCVEC
.ADDUP
                          SUB.W   #32,D1
                          BRA     .CALCVEC
.ADDRIGHT
                          ADD.W   #32,D0
                          BRA     .CALCVEC
.ADDDOWN
                          ADD.W   #32,D1
                
                          BRA     .CALCVEC
                
.CALCVEC                  MOVE.W  D0,D4
                          MOVE.W  D1,D5

                          MOVE.W  (BLINKY_POS_X),D6
                          SUB.W   D6,D4
                          MOVE.W  (BLINKY_POS_Y),D7
                          SUB.W   D7,D5
                          
                          ; DOUBLE THE VECTORS
                          ADD.W   D4,D4
                          ADD.W   D5,D5
                    
                          MOVE.W  (BLINKY_POS_X),D0
                          ADD.W   D4,D0
                          ADD.W   D5,D1
                          BRA     .DISLOGIC
    
.SET_S_TAR
                          MOVE.W  #INKY_HOME_X, D0
                          MOVE.W  #INKY_HOME_Y, D1
                          BRA     .DISLOGIC
                
.SET_PAC_TAR
                          MOVE.W  (PAC_POS_X),D0
                          MOVE.W  (PAC_POS_Y),D1
                          BRA     .DISLOGIC
    
    
.DEFAULT_TARGET
                          MOVE.W  #INKY_HOME_X, D0
                          MOVE.W  #INKY_HOME_Y, D1
    
.DISLOGIC
                          MOVE.W  D0,(INKY_TARGET_X)
                          MOVE.W  D1,(INKY_TARGET_Y)
                
                          ; ABSOLUTE DISTANCE
                          SUB.W   D0,D2
                          TST.W   D2
                          BPL     .CHKY
                          NEG.W   D2
    
.CHKY                     SUB.W   D1,D3
                          TST.W   D3
                          BPL     .SUM
                          NEG.W   D3
                
.SUM                      ADD.W   D2,D3
                          MOVEM.W  (A7)+,D0-D2
                          RTS            
                          
; -----------------------------------------------------------------------------
FIND_MIN_INKY
; FIND MIN DISTANCE.
; INPUT    : NONE
; OUTPUT   : D1 - INDEX
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVEM.L D2-D7,-(A7) 
                          
                          ; INDEX = 1
                          MOVEQ   #1, D1
                          MOVE.L  #0,A3
                          MOVE.W  INKY_EUCYDEAN_DIS(A3),D3
                          MOVE.W  #1,D0
    
    
.LOOP
                          ADDQ.L  #2,A3
                          ADDQ.W  #1,D1
                          CMP.W   #5,D1
                          BEQ     .OUT
    
                          MOVE.W  INKY_EUCYDEAN_DIS(A3),D4
                          
                          ; COMPARE
                          CMP     D3,D4
                          BGT     .LOOP
                          MOVE.W  D4,D3
                          MOVE.W  D1,D0
                          BRA     .LOOP 
.OUT        
                          MOVE.W  D0,D1
    
                          MOVEM.L (A7)+,D2-D7
                          ; RETURN INDEX
                          RTS
               
; -----------------------------------------------------------------------------
FIND_MAX_INKY
; FIND MAX DISTANCE.
; INPUT    : NONE
; OUTPUT   : D1 - INDEX
; MODIFIES : NONE
; -----------------------------------------------------------------------------
    
                          MOVEM.L D2-D7,-(A7) 
                      
                          ; INDEX = 1
                          MOVEQ   #1, D1
                          MOVE.L  #0,A3
                          MOVE.W  INKY_EUCYDEAN_DIS(A3),D3
                          MOVE.W  #1,D0
    
    
.LOOP
                          ADDQ.L  #2,A3
                          ADDQ.W  #1,D1
                          CMP.W   #5,D1
                          BEQ     .OUT
    
                          MOVE.W  INKY_EUCYDEAN_DIS(A3),D4
                          
                          ; COMPARE
                          CMP     D3,D4
                          BLT     .LOOP
                          MOVE.W  D4,D3
                          MOVE.W  D1,D0
                          BRA     .LOOP 
.OUT        
                          MOVE.W  D0,D1
    
                          MOVEM.L (A7)+,D2-D7
                          ; RETURN INDEX
                          RTS     
; -----------------------------------------------------------------------------
INKY_PLOT
; PLOTS INKY.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
    
                          MOVEM.L D0-D4,-(A7)   
                
                          CMP.W   #1,(INKY_IS_BLUE)
                          BNE     .NOPUEDE
                          CMP.W   #4,(INKY_ESTADO)
                          BGE     .DRAW_S
.NOPUEDE
                          CMP.W   #1,(INKY_DIR)
                          BEQ     .DRAW_L
                          CMP.W   #2,(INKY_DIR)
                          BEQ     .DRAW_U
                          CMP.W   #3,(INKY_DIR)
                          BEQ     .DRAW_R
                          BRA     .DRAW_D
            
.DRAW_S                   BTST.B  #4,(SCRCYCCT)
                          BEQ     .SCA2
                          LEA     SCARED,A0
                          BRA     .DRAW
.SCA2
                          LEA     SCARED2,A0
                          BRA     .DRAW
.DRAW_L
                          BTST.B  #4,(SCRCYCCT)
                          BEQ     .LFT2
                          LEA     I_LEFT,A0
                          BRA     .DRAW
.LFT2                     LEA     I_LEFT2,A0
                          BRA     .DRAW
                          
.DRAW_U
                          BTST.B  #4,(SCRCYCCT)
                          BEQ     .U2
                          LEA     I_UP,A0
                          BRA     .DRAW
.U2                       LEA     I_UP2,A0
                          BRA     .DRAW
.DRAW_R
                          BTST.B  #4,(SCRCYCCT)
                          BEQ     .RH2
                          LEA     I_RIGHT,A0
                          BRA     .DRAW
.RH2
                          LEA     I_RIGHT2,A0
                          BRA     .DRAW
.DRAW_D            

                          BTST.B  #4,(SCRCYCCT)
                          BEQ     .DW2          
                          LEA     I_DOWN,A0
                          BRA     .DRAW
.DW2
                          LEA     I_DOWN2,A0

.DRAW                     ; INT J
                          MOVE.W  (INKY_POS_Y),D7
                          SUB.W   #PACRAD,D7
                          MOVE.L  #15,D3

.LOOP1       
                          ; INT I
                          MOVE.W  (INKY_POS_X),D6
                          SUB.W   #PACRAD,D6
                          MOVE.L  #15,D4
.LOOP2
                          ;SET FILL COLOR
                          MOVE.L (A0)+,D1
                          BTST   #8,D1
                          BEQ    .NEXT
                          MOVE.B  #80,D0
                          TRAP #15
            
                          ;DRAW PIXEL
                          MOVE.L  D6,D1
                          MOVE.W  D7,D2
                          MOVE.B  #82,D0
                          TRAP    #15
            
.NEXT                     ADD.W   #1,D6
                          DBRA    D4, .LOOP2
                          ADD.W   #1,D7
                          DBRA    D3, .LOOP1
                
                          ;DEBUG
                          CMP.W   #1,(DEBUG)
                          BNE     .NODEBUG 
                          ; SET PEN COLOR
                          MOVE.B  #80,D0
                          MOVE.L  #LIGHT_BLUE,D1
                          TRAP #15
                          ; DEFINE COORDINATES
                          MOVE.W  (INKY_TARGET_X),D1
                          SUB.W   #PACRAD,D1
                          MOVE.W  (INKY_TARGET_Y),D2
                          SUB.W   #PACRAD,D2
                          MOVE.W  D1,D3
                          ADD.W   #PACRAD,D3
                          MOVE.W  D2,D4
                          ADD.W   #PACRAD,D4
                
                          ; DRAW TARGET 
                          MOVE.B  #91,D0
                          TRAP    #15
    
.NODEBUG                  MOVEM.L (A7)+,D0-D4
    
                          RTS













*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~

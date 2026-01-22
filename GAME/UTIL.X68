; =============================================================================
; GAME UTIL METHODS
; =============================================================================

; -----------------------------------------------------------------------------
VANISH
; PLOTS A RECTANGLE TO HIDE TUNNEL TRANSITIONS.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVEM.L D0-D4,-(A7)

                          MOVE.B  #80,D0
                          MOVE.L  #BLACK,D1
                          TRAP    #15

                          MOVE.B  #81,D0     ; TRAP CODE TO DEFINE PEN COLOR
                          MOVE.L  #BLACK,D1  ; COLOR=BLACK
                          TRAP    #15        ; SET PEN COLOR


                          ; LAST SQUARE OF THE MAP BOTH RIGTH AND LEFT
                          ; START X
                          MOVE.L  #PORTAL_LEFT_X-CELSIZE*2,D1 
                          MOVE.L   #PORTAL_LEFT_X-CELSIZE,D3
                          
                          ; Y COORDENATES OF SQUARE
                          MOVE.L  #320,D2
                          MOVE.L  #384-CELSIZE,D4
    
                          MOVE.B  #87,D0
                          TRAP    #15
    
                          ; LAST SQUARE OF THE MAP BOTH RIGTH AND LEFT
                          ; START X
                          MOVE.L  #PORTAL_RIGHT_X,D1
                          MOVE.L   #PORTAL_RIGHT_X+CELSIZE,D3
                          
                          ; Y COORDENATES OF SQUARE
                          MOVE.L  #320,D2
                          MOVE.L  #384-CELSIZE,D4
    
                          MOVE.B  #87,D0
                          TRAP    #15
    
                          MOVEM.L (A7)+,D0-D4
    
                          RTS 
    

; -----------------------------------------------------------------------------
UTLPRINT
; PRINT SCREEN CENTERED TEXT.
; INPUT    : A0 POINTER TO ZERO-TERMINATED STRING
;            D0.B SCREEN ROW TO PRINT TEXT
; OUTPUT   : D0.B NEXT ROW
; MODIFIES : NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
                          MOVEM.L D0-D1/A0-A1,-(A7)
                          CLR.B   D1
                          MOVE.L  A0,A1
.LOOP                     TST.B   (A0)+
                          BEQ     .ENDLOOP
                          ADDQ.B  #1,D1
                          BRA     .LOOP
.ENDLOOP                  LSR.B   #1,D1
                          SUB.B   #(SCRWIDTH/8)/2,D1
                          NEG.B   D1
                          ASL.W   #8,D1
                          OR.W    D0,D1
                          MOVE.B  #11,D0
                          TRAP    #15
                          MOVE.B  #13,D0
                          TRAP    #15
                          MOVEM.L (A7)+,D0-D1/A0-A1
                          ADDQ.B  #1,D0
            
                          RTS

; -----------------------------------------------------------------------------
RESTART
; RESTARTS EVERYONE.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          ; TELEPORT HOME
                          
                          MOVE.W  #BLINKY_START_X,(BLINKY_POS_X)
                          MOVE.W  #BLINKY_START_Y,(BLINKY_POS_Y)
                          MOVE.W  #PINKY_START_X,(PINKY_POS_X)
                          MOVE.W  #PINKY_START_Y,(PINKY_POS_Y)
                          MOVE.W  #INKY_START_X,(INKY_POS_X)
                          MOVE.W  #INKY_START_Y,(INKY_POS_Y)
                          MOVE.W  #CLYDE_START_X,(CLYDE_POS_X)
                          MOVE.W  #CLYDE_START_Y,(CLYDE_POS_Y)
                          
                          ; TELEPORT SPAWN
                          MOVE.W  #PAC_START_X,(PAC_POS_X)
                          MOVE.W  #PAC_START_Y,(PAC_POS_Y)
            
                          ; RESTART VARIABLES
                          MOVE.W  #1,(PAC_FACE)
                          MOVE.W  #1,(PAC_INTENT)
                          
                          ; RESTART VARIABLES
                          MOVE.W  #2,(PINKY_DIR)
                          MOVE.W  #1,(PINKY_SCATER_ON)
                          CLR.W   (PINKY_CHASE_ON)
                          CLR.W   (PINKY_SCATERTIMER)
                          CLR.W   (PINKY_CHASETIMER)
                          CLR.W   (PINKY_MODE_SWITCH_COUNT)
                          CLR.W   (PINKY_IS_BLUE)
                          MOVE.W  #2,(PINKY_SPEED)
                          MOVE.L  #PINK,(PINKY_COLOR)
                          CLR.W   (PINKY_ESTADO)
            
                          MOVE.W  #1,(BLINKY_DIR)
                          MOVE.W  #1,(BLINKY_SCATER_ON)
                          CLR.W   (BLINKY_CHASE_ON)
                          CLR.W   (BLINKY_SCATERTIMER)
                          CLR.W   (BLINKY_CHASETIMER)
                          CLR.W   (BLINKY_MODE_SWITCH_COUNT)
                          CLR.W   (BLINKY_IS_BLUE)
                          MOVE.W  #2,(BLINKY_SPEED)
                          MOVE.L  #RED,(BLINKY_COLOR)
                          CLR.W   (BLINKY_ESTADO)
                
                          MOVE.W  #2,(INKY_DIR)
                          MOVE.W  #1,(INKY_SCATER_ON)
                          CLR.W   (INKY_CHASE_ON)
                          CLR.W   (INKY_SCATERTIMER)
                          CLR.W   (INKY_CHASETIMER)
                          CLR.W   (INKY_MODE_SWITCH_COUNT)
                          CLR.W   (INKY_IS_BLUE)
                          MOVE.W  #2,(INKY_SPEED)
                          MOVE.L  #LIGHT_BLUE,(INKY_COLOR)
                          CLR.W   (INKY_ESTADO)
                
                          MOVE.W  #2,(CLYDE_DIR)
                          MOVE.W  #1,(CLYDE_SCATER_ON)
                          CLR.W   (CLYDE_CHASE_ON)
                          CLR.W   (CLYDE_SCATERTIMER)
                          CLR.W   (CLYDE_CHASETIMER)
                          CLR.W   (CLYDE_MODE_SWITCH_COUNT)
                          CLR.W   (CLYDE_IS_BLUE)
                          MOVE.W  #2,(CLYDE_SPEED)
                          MOVE.L  #ORANGE,(CLYDE_COLOR)
                          CLR.W   (CLYDE_ESTADO)
            
                          RTS
















*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~

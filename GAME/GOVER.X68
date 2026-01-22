; =============================================================================
; GAME OVER SCREEN
; =============================================================================

; -----------------------------------------------------------------------------
GOVINIT
; GAME OVER SCREEN INIT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          RTS

; -----------------------------------------------------------------------------
GOVUPD
; GAME OVER SCREEN UPDATE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          BTST.B  #4,(KBDEDGE)
                          BEQ     .DONE
                          MOVE.W  #0,(STANEXT)
.DONE
                          RTS

; -----------------------------------------------------------------------------
GOVPLOT
; GAME OVER SCREEN PLOT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVEM.L D0-D1/A0,-(A7)
            
                          CLR.L   D1
                          MOVE.B  #81,D0
                          TRAP    #15
            
                          LEA     .TXT1,A0
                          MOVE.B  #10,D0
                          JSR     UTLPRINT
            
                          BTST.B  #4,(SCRCYCCT)
                          BEQ     .DONE
            
                          LEA     .TXT2,A0
                          MOVE.B  #25,D0
                          JSR     UTLPRINT
            
.DONE                     MOVEM.L (A7)+,D0-D1/A0

                          RTS
.TXT1                     DC.B    'GAME OVER',0
.TXT2                     DC.B    'PRESS SPACE BAR TO START',0
                          DS.W    0






*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~

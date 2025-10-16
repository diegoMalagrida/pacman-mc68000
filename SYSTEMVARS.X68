; =============================================================================
; SYSTEM VARIABLES
; =============================================================================

; --- KEYBOARD RELATED VARIABLES ----------------------------------------------
KBDVAL                    DS.B    1          ; KEY STATE
KBDEDGE                   DS.B    1          ; KEY EDGE

; --- TIMER RELATED VARIABLES -------------------------------------------------
SCRINTCT                  DS.B    1          ; INTERUPT COUNTER
SCRCYCCT                  DS.B    1

; --- MOUSE RELATED VARIABLES -------------------------------------------------
MSPOSY                    DS.W    1          ; POSICION Y DEL RATON
MSPOSX                    DS.W    1          ; POSICION X DEL RATON
MSBUT                     DS.B    1
                          DS.W    0






*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~

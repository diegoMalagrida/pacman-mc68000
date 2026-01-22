; =============================================================================
; GAME VARIABLES
; =============================================================================

; NOTE FOR DIRECTIONS: 0=UP,1=DOWN,2=LEFT,3=RIGHT

; --- PAC-MAN RELATED VARIABLES -----------------------------------------------
PAC_POS_X                 DS.W    1          ; PAC-MAN X COORDINATE
PAC_POS_Y                 DS.W    1          ; PAC-MAN Y COORDINATE
PAC_FACE                  DS.W    1          ; PAC-MAN DIRECTION
NEXT_PAC_POS_X            DS.W    1          ; NEXT PAC-MAN X COORDINATE
NEXT_PAC_POS_Y            DS.W    1          ; NEXT PAC-MAN Y COORDINATE
PAC_INTENT                DS.W    1          ; NEXT PAC-MAN DIRECTION
PREVIOUS_PAC_POS_X        DS.W    1          ; PREVIOUS PAC-MAN X COORDINATE
PREVIOUS_PAC_POS_Y        DS.W    1          ; PREVIOUS PAC-MAN Y COORDINATE

; --- MAP RELATED VARIABLES ---------------------------------------------------
MAPDATA                   DS.B    MAPWITH*MAPHIGH

; --- SND RELATED VARIABLES ---------------------------------------------------
CHKCHOMP                  DS.W    1
STARTTIM                  DS.W    1

; --- BLINKY RELATED VARIABLES ------------------------------------------------
BLINKY_DIR                DS.W    1          ; BLINKY DIRECTION
BLINKY_POS_X              DS.W    1          ; BLINKY X COORDINATE
BLINKY_POS_Y              DS.W    1          ; BLINKY Y COORDINATE
BLINKY_IS_BLUE            DS.W    1          ; BLINKY IS SCARED
BLINKY_ALLOWED_DIR        DC.B    0,0,0,0    ; DIRECTION ARRAY
BLINKY_EUCYDEAN_DIS       DC.W    0,0,0,0    ; DISTANCE ARRAY
BLINKY_COLOR              DS.L    1
BLINKY_ESTADO             DS.W    1
BLINKY_SPEED              DS.W    1
BLINKY_SCATERTIMER        DS.W    1          ; SCATTER TIMER
BLINKY_SCATER_ON          DS.W    1          ; SCATTER FLAG
BLINKY_CHASETIMER         DS.W    1          ; CHASE TIMER
BLINKY_CHASE_ON           DS.W    1          ; CHASE FLAG
BLINKY_FRIGHTENED_TIMER   DS.W    1          ; SCARED TIMER
BLINKY_MODE_SWITCH_COUNT  DS.W    1
BLINKY_TARGET_X           DS.W    1          ; BLINKY TARGET X
BLINKY_TARGET_Y           DS.W    1          ; BLINKY TARGET Y

; --- PINKY RELATED VARIABLES -------------------------------------------------
PINKY_DIR                 DS.W    1          ; PINKY DIRECTION
PINKY_POS_X               DS.W    1          ; PINKY X COORDINATE
PINKY_POS_Y               DS.W    1          ; PINKY Y COORDINATE
PINKY_IS_BLUE             DS.W    1          ; PINKY IS SCARED
PINKY_ALLOWED_DIR         DC.B    0,0,0,0    ; DIRECTION ARRAY
PINKY_EUCYDEAN_DIS        DC.W    0,0,0,0    ; DISTANCE ARRAY
PINKY_COLOR               DS.L    1
PINKY_ESTADO              DS.W    1
PINKY_SPEED               DS.W    1
PINKY_SCATERTIMER         DS.W    1          ; SCATTER TIMER
PINKY_SCATER_ON           DS.W    1          ; SCATTER FLAG
PINKY_CHASETIMER          DS.W    1          ; CHASE TIMER
PINKY_CHASE_ON            DS.W    1          ; CHASE FLAG
PINKY_FRIGHTENED_TIMER    DS.W    1          ; SCARED TIMER
PINKY_MODE_SWITCH_COUNT   DS.W    1
PINKY_TARGET_X            DS.W    1          ; PINKY TARGET X
PINKY_TARGET_Y            DS.W    1          ; PINKY TARGET Y

; --- INKY RELATED VARIABLES --------------------------------------------------
INKY_DIR                  DS.W    1          ; INKY DIRECTION
INKY_POS_X                DS.W    1          ; INKY X COORDINATE
INKY_POS_Y                DS.W    1          ; INKY Y COORDINATE
INKY_IS_BLUE              DS.W    1          ; INKY IS SCARED
INKY_ALLOWED_DIR          DC.B    0,0,0,0    ; DIRECTION ARRAY
INKY_EUCYDEAN_DIS         DC.W    0,0,0,0    ; DISTANCE ARRAY
INKY_COLOR                DS.L    1
INKY_ESTADO               DS.W    1
INKY_SPEED                DS.W    1
INKY_SCATERTIMER          DS.W    1          ; SCATTER TIMER
INKY_SCATER_ON            DS.W    1          ; SCATTER FLAG
INKY_CHASETIMER           DS.W    1          ; CHASE TIMER
INKY_CHASE_ON             DS.W    1          ; CHASE FLAG
INKY_FRIGHTENED_TIMER     DS.W    1          ; SCARED TIMER
INKY_MODE_SWITCH_COUNT    DS.W    1
INKY_TARGET_X             DS.W    1          ; INKY TARGET X
INKY_TARGET_Y             DS.W    1          ; INKY TARGET Y

; --- CLYDE RELATED VARIABLES -------------------------------------------------
CLYDE_DIR                 DS.W    1          ; CLYDE DIRECTION
CLYDE_POS_X               DS.W    1          ; CLYDE X COORDINATE
CLYDE_POS_Y               DS.W    1          ; CLYDE Y COORDINATE
CLYDE_IS_BLUE             DS.W    1          ; CLYDE IS SCARED
CLYDE_ALLOWED_DIR         DC.B    0,0,0,0    ; DIRECTION ARRAY
CLYDE_EUCYDEAN_DIS        DC.W    0,0,0,0    ; DISTANCE ARRAY
CLYDE_DIS_PAC             DC.W    0,0,0,0    ; DISTANCE ARRAY
CLYDE_COLOR               DS.L    1
CLYDE_ESTADO              DS.W    1
IS_CLYDE_NEAR             DS.B    1
CLYDE_SPEED               DS.W    1
CLYDE_SCATERTIMER         DS.W    1          ; SCATTER TIMER
CLYDE_SCATER_ON           DS.W    1          ; SCATTER FLAG
CLYDE_CHASETIMER          DS.W    1          ; CHASE TIMER
CLYDE_CHASE_ON            DS.W    1          ; CHASE FLAG
CLYDE_FRIGHTENED_TIMER    DS.W    1          ; SCARED TIMER
CLYDE_MODE_SWITCH_COUNT   DS.W    1
CLYDE_TARGET_X            DS.W    1          ; CLYDE TARGET X
CLYDE_TARGET_Y            DS.W    1          ; CLYDE TARGET Y

; --- GAME RELATED VARIABLES --------------------------------------------------
PACMAN_LIVES              DS.B    1          ; NUMBER OF PAC-MAN LIVES
TOTAL_PELLETS_COL         DS.W    1          ; TOTAL PELLETS COLLECTED
CURRENT_SCORE             DS.L    1          ; CURRENT SCORE
CURRENT_SCORE2            DS.B    1024       ; CURRENT SCORE (BUFFER)
CURRENT_SCORE3            DS.B    1024       ; AUX CURRENT SCORE (BUFFER)
HIGH_SCORE                DS.B    1024       ; HIGH SCORE (BUFFER)
HIGH_SCORE2               DS.L    1          ; HIGH SCORE
DEBUG                     DS.W    1          ; DEBUG VAR TO SEE GHOST TARGET

; --- STATE RELATED VARIABLES -------------------------------------------------
STACUR                    DS.W    1          ; CURRENT STATE
STANEXT                   DS.W    1          ; NEXT STATE
LEVEL                     DS.W    1
ISCTIMER                  DS.W    1          ; INTRO STATE TIMER
INSTIMER                  DS.W    1          ; INSTRUCTIONS STATE TIMER

; --- FPS RELATED VARIABLES ---------------------------------------------------
FRAMECOUNT                DS.W    1
FRAMEPRINT                DS.W    1
TIME                      DS.L    1                   
                          DS.W    0            
































*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~

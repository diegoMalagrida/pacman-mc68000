; =============================================================================
; GAME CONSTANTS
; =============================================================================

; --- VICTORY/DEFEAT CONSTANTS ------------------------------------------------
TOTALPELLETS              EQU     246        ; MAX PELLETS
MAX_MODE_SWITCH           EQU     6          ; MAX SWITCHES

; --- FPS RELATED CONSTANTS ---------------------------------------------------
FPS_TO_REACH              EQU     144
DELAY                     EQU     1000/FPS_TO_REACH

; --- COLOR RELATED CONSTANTS -------------------------------------------------
BLACK                     EQU     $00000000  ; BLACK COLOR
WHITE                     EQU     $00FFFFFF  ; WHITE COLOR
YELLOW                    EQU     $0000FBFF  ; YELLOW COLOR
BLUE                      EQU     $00FF0000  ; BLUE COLOR
RED                       EQU     $000000FF  ; RED COLOR
DARK_BLUE                 EQU     $008B0000  ; DARK BLUE COLOR
PINK                      EQU     $00CBC0FF  ; PINK COLOR
ORANGE                    EQU     $00005AFF  ; ORANGE COLOR
LIGHT_BLUE                EQU     $008DDA6E  ; LIGHT BLUE COLOR

; --- PAC-MAN RELATED CONSTANTS -----------------------------------------------
PACMAN_SPEED              EQU     2
PACRAD                    EQU     16         ; PACMAN DIAMETER!
PAC_START_X               EQU     408        ; START X COORDINATE
PAC_START_Y               EQU     496        ; START Y COORDINATE

; --- BLINKY RELATED CONSTANTS ------------------------------------------------
BLINKY_START_X            EQU     408        ; START X COORDINATE
BLINKY_START_Y            EQU     304        ; START Y COORDINATE
BLINKY_HOME_X             EQU     528        ; BLINKY X HOME
BLINKY_HOME_Y             EQU     16         ; BLINKY Y HOME

; --- PINKY RELATED CONSTANTS -------------------------------------------------
PINKY_START_X             EQU     408        ; START X COORDINATE
PINKY_START_Y             EQU     368        ; START Y COORDINATE
PINKY_HOME_X              EQU     224        ; PINKY X HOME
PINKY_HOME_Y              EQU     16         ; PINKY Y HOME

; --- INKY RELATED CONSTANTS --------------------------------------------------
INKY_START_X              EQU     376        ; START X COORDINATE
INKY_START_Y              EQU     368        ; START Y COORDINATE
INKY_HOME_X               EQU     624        ; INKY X HOME
INKY_HOME_Y               EQU     624        ; INKY Y HOME

; --- CLYDE RELATED CONSTANTS -------------------------------------------------
CLYDE_START_X             EQU     440        ; START X COORDINATE
CLYDE_START_Y             EQU     368        ; START Y COORDINATE
CLYDE_HOME_X              EQU     208        ; CLYDE X HOME
CLYDE_HOME_Y              EQU     576        ; CLYDE Y HOME

; --- MAP RELATED CONSTANTS ---------------------------------------------------
MAPWITH                   EQU     32         ; MAP WIDTH
MAPHIGH                   EQU     31         ; MAP HEIGHT
CELSIZE                   EQU     16         ; CELL SIZE
MAP_START_X               EQU     144        ; MAP START X COORDINATE
MAP_START_Y               EQU     112        ; MAP START Y COORDINATE
PORTAL_LEFT_X             EQU     192        ; LEFT PORTAL COORDINATE
PORTAL_RIGHT_X            EQU     624        ; RIGHT PORTAL COORDINATE

; --- STATE RELATED CONSTANTS -------------------------------------------------
STANONE                   EQU     -1         ; NON-EXISTENT STATE NUMBER
INSMAXTM                  EQU     1500        ; INSTRUCTIONS MAX TIMER

; --- GAME RELATED CONSTANTS --------------------------------------------------
CHASE                     EQU     1000       ; CHASE MAX TIMER
SCATER                    EQU     350        ; SCATTER MAX TIMER
FRIGHTENED                EQU     300        ; FRIGHTENED MAX TIMER
























*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~

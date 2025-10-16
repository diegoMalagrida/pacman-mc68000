 ; =============================================================================
; TITLE       : PACMAN 68K
; DESCRIPTION : MAIN GAME LOOP
; AUTHDORS    : ANDREU MASSANET AND DIEGO MALAGRIDA
; =============================================================================

                          ORG     $1000
            
                          INCLUDE "CONST.X68"
                          INCLUDE "SYSCONST.X68"
                          INCLUDE "SYSTEM.X68"
                          INCLUDE "VARS.X68"
                          INCLUDE "PACMAN.X68"
                          INCLUDE "SCORE.X68"
                          INCLUDE "FPS.X68"
                          INCLUDE "MAPDATA.X68"
                          INCLUDE "MAP.X68"
                          INCLUDE "SYSTEMVARS.X68"
                          INCLUDE "UTIL.X68"
                          INCLUDE "BLINKY.X68"
                          INCLUDE "PINKY.X68"
                          INCLUDE "INKY.X68"
                          INCLUDE "CLYDE.X68"
                          INCLUDE "GAME.X68"
                          INCLUDE "INTRO.X68"
                          INCLUDE "INSTRUCTIONS.X68"
                          INCLUDE "NEXT.X68"
                          INCLUDE "GOVER.X68"
                          INCLUDE "STATES.X68"
                          INCLUDE "GFX.X68"

START

; --- INITIALIZATION ----------------------------------------------------------

                          ORI.W   #$0700,SR
                          JSR     SYSINIT    ; SYSTEM INITIALIZATION 
                          JSR     STAINIT
    
.LOOP

; --- UPDATE ------------------------------------------------------------------
                          TRAP    #1         ; READ KEYBOARD
                          TRAP    #2         ; READ MOUSE
                          JSR     STAUPD
            
; --- SYNC --------------------------------------------------------------------

.WINT                     TST.B   (SCRINTCT)
                          BEQ     .WINT
                          CLR.B   (SCRINTCT)
            
; --- PLOT --------------------------------------------------------------------
                          JSR     STAPLOT
            
                          TRAP    #0         ; UPDATE DOUBLE BUFFER
            
                          BRA     .LOOP
            
                          SIMHALT
            
                          END     START















*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~

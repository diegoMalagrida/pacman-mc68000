; =============================================================================
; SCOREBOARD MANAGEMENT
; =============================================================================
           
; -----------------------------------------------------------------------------
SCOPLOT
; PLOT THE SCOREBOARD.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------

                          MOVEM.L D0-D1/A1-A2,-(A7)

                          ; SET BACKGROUND COLOR
                          MOVE.B  #81,D0
                          MOVE.L  #BLACK,D1
                          TRAP    #15
            
                          ; SET FIRST LINE POSITION
                          MOVE.B  #11,D0
                          MOVE.W  #$4005,D1
                          TRAP    #15

                          ; PRINT FIRST LINE
                          LEA     .TXT1,A1
                          CLR.L   D1
                          MOVE.L  (CURRENT_SCORE),D1
                          MOVE.B  #17,D0
                          TRAP    #15
                        
                          ; SET THIRD LINE POSITION
                          MOVE.B  #11,D0
                          MOVE.W  #$1B05,D1
                          TRAP    #15

                          ; PRINT THIRD LINE
                          LEA     .TXT2,A1
                          CLR.L   D1
                          MOVE.L  (HIGH_SCORE2),D1
                          MOVE.B  #17,D0
                          TRAP    #15
            
                          ; SET SECOND LINE POSITION
                          MOVE.B  #11,D0
                          MOVE.W  #$5005,D1
                          TRAP    #15

                          ; PRINT SECOND LINE
                          LEA     .TXT3,A1
                          CLR.L   D1
                          MOVE.W  (LEVEL),D1
                          MOVE.B  #17,D0
                          TRAP    #15

                          ; SET FOURTH LINE POSITION
                          MOVE.B  #11,D0
                          MOVE.W  #$5006,D1
                          TRAP    #15

                          ; PRINT FOURTH LINE
                          LEA     .TXT4,A1
                          CLR.L   D1
                          MOVE.W  (PACMAN_LIVES),D1
                          MOVE.B  #17,D0
                          TRAP    #15
          
                          MOVEM.L (A7)+,D0-D1/A1-A2
                          RTS
            
.TXT1                     DC.B    'SCORE :',0
.TXT2                     DC.B    'HIGH SCORE :',0
.TXT3                     DC.B    'LEVEL :',0
.TXT4                     DC.B    'LIVES :',0
                          DC.W    0















*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~

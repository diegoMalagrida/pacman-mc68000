; =============================================================================
; INTRO SCREEN
; =============================================================================

; -----------------------------------------------------------------------------
ISCINIT
; INTRO SCREEN INIT.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVEM.L D0-D7/A0,-(A7)

                          MOVE.W  #1,(LEVEL)
                          CLR.L   CURRENT_SCORE
                          MOVE.W  #3,(PACMAN_LIVES)
                          MOVEM.L (A7)+,D0-D7/A0
                          JSR     ISCPLOT
                          RTS

; -----------------------------------------------------------------------------
ISCUPD
; INTRO SCREEN UPDATE.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVEM.W D0-D1,-(A7)
                          
                          ; CHECK SPACE BAR
                          BTST.B  #4,(KBDEDGE)
                          BEQ     .CHKMOUSE
                          MOVE.W  #2,(STANEXT)
                          BRA     .END
.CHKMOUSE   
                          ; CHECK LEFT CLICK
                          CMP.B   #1,(MSBUT)
                          BNE     .END
                          MOVE.W  (MSPOSX),D0
                          MOVE.W  (MSPOSY),D1
                          CMP.W   #245,D0
                          BLO     .END
                          CMP.W   #245+311,D0
                          BHI     .END
                          CMP.W   #432,D1
                          BLO     .END
                          CMP.W   #432+108,D1
                          BHI     .END
                          MOVE.W  #1,(STANEXT)
            
.END                      MOVEM.W (A7)+,D0-D1
                          RTS

; -----------------------------------------------------------------------------
ISCPLOT
; INTRO SCREEN PLOT.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVEM.L D0-D3/A0,-(A7)
                          ; DISABLE DOUBLE BUFFER
                          MOVE.B  #92,D0
                          MOVE.B  #16,D1
                          TRAP    #15
            
                          ; SET BACKGROUND COLOR
                          MOVE.B  #81,D0
                          MOVE.L  #BLACK,D1
                          TRAP    #15
            
                          MOVE.B  #80,D0
                          MOVE.L  #BLACK,D1
                          TRAP    #15
            
                          ; CLEAR SCREEN
                          MOVE.B  #87,D0
                          MOVE.W  #0,D1
                          MOVE.W  #0,D2
                          MOVE.W  #SCRWIDTH,D2
                          MOVE.W  #SCRHEIGH,D3
                          TRAP    #15
            
                          LEA     INTROARR1,A0
            
                          ; INT J
                          MOVE.W  #147,D7
                          MOVE.L  #174-1,D3

.LOOP1       
                          ; INT I
                          MOVE.W  #150,D6
                          MOVE.L  #501-1,D4
.LOOP2
                          ;SET FILL COLOR
                          MOVE.L  (A0)+,D1
                          CMP.L   #$00000000,D1
                          BEQ     .NEXT
                          MOVE.B  #80,D0
                          TRAP    #15
            
                          ;DRAW PIXEL
                          MOVE.L  D6,D1
                          MOVE.W  D7,D2
                          MOVE.B  #82,D0
                          TRAP    #15
            
.NEXT                     ADD.W   #1,D6
                          DBRA    D4, .LOOP2
                          ADD.W   #1,D7
                          DBRA    D3, .LOOP1
            
                          LEA     INTROAB1,A0
            
                          ; INT J
                          MOVE.W  #432,D7
                          MOVE.L  #108-1,D3

.LOOP12       
                          ; INT I
                          MOVE.W  #245,D6
                          MOVE.L  #311-1,D4
.LOOP22
                          ;SET FILL COLOR
                          MOVE.L  (A0)+,D1
                          CMP.L   #$00000000,D1
                          BEQ     .NEXT2
                          MOVE.B  #80,D0
                          TRAP    #15
            
                          ;DRAW PIXEL
                          MOVE.L  D6,D1
                          MOVE.W  D7,D2
                          MOVE.B  #82,D0
                          TRAP    #15
            
.NEXT2                    ADD.W   #1,D6
                          DBRA    D4, .LOOP22
                          ADD.W   #1,D7
                          DBRA    D3, .LOOP12
            
                          ; ENABLE DOUBLE BUFFER
                          MOVE.B  #92,D0
                          MOVE.B  #17,D1
                          TRAP    #15
                 
                          MOVEM.L (A7)+,D0-D3/A0

                          RTS


*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~

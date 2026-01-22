
; -----------------------------------------------------------------------------
FPS_INIT
; INITIALIZATE FPS.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          CLR.W   (FRAMECOUNT)
                          CLR.W   (FRAMEPRINT)
                          RTS

; -----------------------------------------------------------------------------
FPS_UPDATE     
; UPDATES FPS.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVEM.L D0-D2,-(A7)
            
                          ; ADD FPS COUNT
                          ADDQ    #1,(FRAMECOUNT)
                          ; TRAP FOR TIME
                          MOVE.B  #8,D0			
                          TRAP    #15
                          ; TIME COMPARE
                          MOVE.L  D1,D2            
                          MOVE.L  (TIME),D0        
                          ADD.L   #100,D0          
                          SUB.L   D0,D1            
                          CMP.L   #0,D1            

                          BLT     .END
                          
                          ;UPDATE FPS
                          MOVE.W  (FRAMECOUNT),(FRAMEPRINT)
                          MOVE.W  #0,(FRAMECOUNT)
                          MOVE.L  D2,(TIME)

.END      
                          MOVEM.L (A7)+,D0-D2
                          RTS
            
            
GOALFPS                   DC.B    'MAX FPS :',0
ACTUALFPS                 DC.B    'FPS :',0
                          DC.W    0

; -----------------------------------------------------------------------------
FPS_PLOT
; PLOT FPS.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------

                          MOVEM.L D0-D1/A1,-(A7)
                        
                          ; SET FIRST LINE POSITION
                          MOVE.B  #11,D0
                          MOVE.W  #$0201,D1
                          TRAP    #15
            
                          ; PRINT FIRST LINE
                          LEA     GOALFPS, A1
                          CLR.L   D1
                          MOVE.W  #FPS_TO_REACH,D1
                          MOVE.B  #17,D0
                          TRAP    #15
            
                          ; SET SECOND LINE POSITION
                          MOVE.B  #11,D0
                          MOVE.W  #$0202,D1
                          TRAP    #15
            
                          ; PRINT SECOND LINE
                          LEA     ACTUALFPS,A1
                          CLR.L   D1
                          MOVE.W  (FRAMEPRINT),D1
                          MOVE.B  #17,D0
                          TRAP    #15
            
                          MOVEM.L (A7)+,D0-D1/A1
            
                          RTS
*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~

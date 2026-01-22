; -----------------------------------------------------------------------------
; MAP
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
MAPINIT
; COPIES MAPDATAO TO MAPDATA. THIS IS NECESSARY (THOUGH IT COULD BE OPTIMIZED)
; SINCE MAPDATA IS MODIFIED WHILE PLAYING WHEN OBJECTS ARE PICKED.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
                          MOVEM.L D0/A0-A1,-(A7)
                          MOVE.W  #MAPWITH*MAPHIGH,D0
                          LEA     MAPDATA0,A0
                          LEA     MAPDATA,A1
                          
                          ; LET US COPY WORD BY WORD
                          ASR.W   #1,D0
.LOOP                     MOVE.W  (A0)+,(A1)+
                          DBRA    D0,.LOOP
                          MOVEM.L (A7)+,D0/A0-A1
                          RTS

; -----------------------------------------------------------------------------
MAPPLOT
; DRAWS THE MAP.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVEM.L D0-D7,-(A7)
    
                          ; LOAD EFECTIVE ADDRES INTO A0 (FIRST POS OF MAP)
                          LEA     MAPDATA,A0

                          ; INT J
                          MOVE.L  #MAP_START_Y,D7
                          MOVE.L  #MAPHIGH-1,D3
.LOOP1       
                          ; INT I
                          MOVE.W  #MAP_START_X,D6
                          MOVE.L  #MAPWITH-1,D4
.LOOP2
                          MOVE.B  (A0)+,D0
                          MULU    #6,D0
                          MOVE.L  D0,A1
                          JMP     .JUMPLIST(A1)
            
.JUMPLIST:   
                          JMP     .ISFREE
                          JMP     .ISWALL
                          JMP     .ISMINIDOT
                          JMP     .ISGIGADOT
                          JMP     .CONTINUE
                          JMP     .ISMINIDOT
                          JMP     .ISFREE
            
.ISFREE
                          MOVE.B  #80,D0
                          MOVE.L  #BLACK,D1
                          TRAP    #15
                          ; TRAP CODE TO DEFINE PEN COLOR
                          MOVE.B  #81,D0
                          MOVE.L  #BLACK,D1
                          TRAP    #15
                          JSR     DRSQUARE
                          BRA     .CONTINUE

.ISWALL
                          ; TRAP CODE TO DEFINE PEN COLOR
                          MOVE.B  #80,D0
                          MOVE.L  #BLACK,D1
                          TRAP    #15

                          ; TRAP CODE TO DEFINE FILL COLOR
                          MOVE.B  #81,D0
                          MOVE.L  #BLUE,D1
                          TRAP    #15
                          JSR     DRSQUARE
                          BRA     .CONTINUE
            
.ISMINIDOT
                          ; TRAP CODE TO DEFINE PEN COLOR
                          MOVE.B  #80,D0
                          MOVE.L  #WHITE,D1
                          TRAP    #15
                          
                          ; TRAP CODE TO DEFINE FILL COLOR
                          MOVE.B  #81,D0
                          MOVE.L  #WHITE,D1
                          TRAP    #15
    
                          JSR     DRMINIDOT
                          BRA     .CONTINUE

            
.ISGIGADOT

                          ; TRAP CODE TO DEFINE PEN COLOR
                          MOVE.B  #80,D0
                          MOVE.L  #WHITE,D1
                          TRAP    #15
    
                          ; TRAP CODE TO DEFINE FILL COLOR
                          MOVE.B  #81,D0
                          MOVE.L  #WHITE,D1
                          TRAP    #15

                          JSR     DRGIGADOT
                          BRA     .CONTINUE
    
.CONTINUE
                          ; NEXT TILE
                          ADD.L   #CELSIZE,D6
                          DBRA    D4, .LOOP2
                          ADD.L   #CELSIZE,D7
                          DBRA    D3, .LOOP1

                          MOVEM.L (A7)+,D0-D7
                          RTS
        
; -----------------------------------------------------------------------------
DRSQUARE
; DRAWS SQUARE.
; INPUT    : D6,D7 
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------

                          MOVEM.L D0-D4,-(A7)

                          ; X COORDENATES OF SQUARE
                          MOVE.L  D6,D1      ; START X 
                          MOVE.L  D6,D3      ; MOVE INIT X TO D3
                          ; ADD THE CELL SIZE FOR RIGHT X
                          ADD.W   #CELSIZE,D3
                          ; Y COORDENATES OF SQUARE
                          MOVE.L  D7,D2
                          MOVE.L  D7,D4
                          ADD.W   #CELSIZE,D4
    
                          MOVE.B  #87,D0
                          TRAP    #15
    
                          MOVEM.L (A7)+,D0-D4
    
                          RTS 
    
    
; -----------------------------------------------------------------------------
DRMINIDOT 
; DRAWS MINI DOT.
; INPUT    : D6,D7 
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------

                          MOVEM.L  D0-D4,-(A7)

                          ;X COORDENATES OF DOT
                          MOVE.L  D6,D1      ; START X 
                          ADD.L   #6,D1
                          MOVE.L  D6,D3      ; MOVE INIT X TO D3
                          ; ADD THE CELL SIZE FOR RIGHT X
                          ADD.W   #CELSIZE,D3
                          SUB.L   #6,D3
                          ;Y COORDENATES OF DOT
                          MOVE.L  D7,D2
                          ADD.L   #6,D2
                          MOVE.L  D7,D4
                          ADD.W   #CELSIZE,D4
                          SUB.L   #6,D4
    
                          MOVE.B  #88,D0
                          TRAP    #15
    
                          MOVEM.L (A7)+,D0-D4
    
                          RTS
    
; -----------------------------------------------------------------------------
DRGIGADOT 
; DRAWS BIG DOT.
; INPUT    : D6,D7 
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVEM.L D0-D4,-(A7)

                          ;X COORDENATES OF DOT
                          MOVE.L  D6,D1      ; START X 
                          ADD.L   #4,D1
                          MOVE.L  D6,D3      ; MOVE INIT X TO D3
                          ; ADD THE CELL SIZE FOR RIGHT X
                          ADD.W   #CELSIZE,D3
                          SUB.L   #4,D3
                          ;Y COORDENATES OF DOT
                          MOVE.L  D7,D2
                          ADD.L   #4,D2
                          MOVE.L  D7,D4
                          ADD.W   #CELSIZE,D4
                          SUB.L   #4,D4
    
                          MOVE.B  #88,D0
                          TRAP    #15
    
                          MOVEM.L (A7)+,D0-D4

                          RTS




*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~

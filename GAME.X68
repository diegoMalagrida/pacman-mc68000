; =============================================================================
; GAME MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
GAMINIT
; INITIALIZES GAME.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          JSR     MAPINIT
                          JSR     PAC_INIT
                          JSR     BLINKY_INIT
                          JSR     PINKY_INIT
                          JSR     INKY_INIT
                          JSR     CLYDE_INIT
                          JSR     FPS_INIT
                          
                          ; LEER HIGHSCORE.TXT
                          LEA     HIGH_SCORE,A0
                          LEA     FILENAME,A1
                          JSR     FILLOAD
            
                          RTS

; -----------------------------------------------------------------------------
GAMUPD
; UPDATES THE GAME
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          BTST.B  #5,(KBDEDGE)
                          BEQ     .NODEBUG
                          CMP.W   #1,(DEBUG)
                          BEQ     .DEBUGOFF
                          MOVE.W  #1,(DEBUG)
                          BRA     .NODEBUG         
.DEBUGOFF                 MOVE.W  #0,(DEBUG)
.NODEBUG                  ADDQ    #1,(STARTTIM)
                          CMP.W   #150,(STARTTIM)
                          BLT     .DONE 
            
                          JSR     PAC_UPDATE
                          JSR     BLINKY_UPDATE
                          JSR     PINKY_UPDATE
                          JSR     INKY_UPDATE
                          JSR     CLYDE_UPDATE
                          JSR     FPS_UPDATE
            
                          ; RELEASE GHOSTS
                          CMP.W   #1,(INKY_ESTADO)
                          BGT     .CHKCLYDE
                          CMP.W   #30,(TOTAL_PELLETS_COL)
                          BLT     .CHKCLYDE
                          MOVE.W  #1,(INKY_ESTADO)
 
.CHKCLYDE                 CMP.W   #1,(CLYDE_ESTADO)
                          BGT     .CHKWIN
                          CMP.W   #82,(TOTAL_PELLETS_COL)
                          BLT     .CHKWIN
                          MOVE.W  #1,(CLYDE_ESTADO)
                          
.CHKWIN                   ; CHECK WIN
                          CMP.W   #TOTALPELLETS,(TOTAL_PELLETS_COL)
                          BLT     .CHKLOSS
                          CLR.W   (STARTTIM)
                          MOVE.W  #3,(STANEXT)
                          BRA     .DONE
            
.CHKLOSS                  ; CHECK LOSS
                          CMP.W   #0,(PACMAN_LIVES)
                          BGT     .DONE
                          MOVE.L  (HIGH_SCORE2),D6
                          CMP.L   (CURRENT_SCORE),D6
                          BGT     .CHSTATE
                          
                          ; WRITE CURRENT SCORE
                          MOVE.L  (CURRENT_SCORE),D0
            
                          JSR CONVERT_ASCII
                          
                          ; CLOSE ALL OPEN FILES (RECOMENDED)
                          MOVE.B  #50,D0
                          TRAP    #15
                          
                          ; OPEN NEW FILE (CAN OVERWRITE!)
                          MOVE.B  #52,D0
                          ; SPECIFY FILE NAME
                          LEA     FILENAME,A1
                          TRAP    #15
                          
                          ; WRITE FILE
                          MOVE.B  #54,D0
                          LEA     CURRENT_SCORE3,A1
                          TRAP    #15
            
                          ; CLOSE THE FILE
                          MOVE.B  #56,D0
                          TRAP    #15
.CHSTATE
                          CLR.W   (STARTTIM)
                          MOVE.W  #4,(STANEXT)                                    
.DONE                     RTS

FILENAME                  DC.B    'HIGHSCORE.txt',0
                          DS.W    0
                          
; -----------------------------------------------------------------------------
FILLOAD
; LOADS AN FILE FROM DISK TO MEMORY
; INPUT    : A0 - DESTINATION ADDR. WITH ENOUGH SPACE AVAILABLE.
;            A1 - POINTER TO FILE NAME
; OUTPUT   : NONE
; MODIFIES : NONE
; NOTE     : THE READ DATA LOOP READS 1 BYTE AT A TIME TO ENSURE ALL FILES CAN
;            BE LOADED. HOWEVER, IF THE FILE SIZE IS KNOWN BEFOREHAND, NO LOOP
;            WOULD BE NECESSARY AND A SINGLE CALL TO TRAP #15 TASK 53 WOULD 
;            READ THE WHOLE FILE AS LONG AS THE FILE SIZE IS PLACED INTO D2.L.
; NOTE     : THE ZERO-TERMINATOR (JUST BEFORE CLOSE THE FILE) IS A REQUIREMENT
;            FOR TEXT-FILES IF THE TEXT IS TO BE PRINTED. FOR OTHER USES, IT
;            CAN BE REMOVED.
; -----------------------------------------------------------------------------
                          MOVEM.L D0-D3/A0-A1,-(A7)
                          ; CLOSE ALL FILES
                          MOVE.B  #50,D0
                          TRAP    #15
                          
                          ; OPEN FILE (ASSUMES A1 POINTS TO FILENAME)
                          MOVE.B  #51,D0
                          TRAP    #15        ; D1.L:=FILE HANDLER
                          CLR.W   D3
                          
                          ; READ DATA
                          MOVE.L  A0,A1      ; A1 MUST BE THE BUFFER ADDRESS
.LOOP                     MOVE.B  #53,D0     ; READ DATA TASK
                          MOVE.L  #1,D2      ; BYTES TO READ (ONE BY ONE)
                          TRAP    #15
                          ADDQ    #1,D3
                          ADD.L   D2,A1      ; ADVANCE POINTER
                          TST.B   D0         ; END OF FILE OR ERROR?
                          BEQ     .LOOP      ; NO: READ MORE
                          CLR.B   -(A1)      ; PUT A ZERO-TERMINATOR.
                          
                          ; CLOSE THE FILE
                          MOVE.B  #56,D0
                          TRAP    #15
                          SUBQ    #1,D3
                          MOVE.W  D3,D4
                          MOVE.L  A0,A1
            
.CONVERT_LOOP
                          ; CONVERT READ BUFFER TO NUMBER
                          TST.B   D3
                          BEQ     .DONE
                          SUB.B   #$30,(A1)+
                          SUB.B   #1,D3
                          BRA     .CONVERT_LOOP            
.DONE
                          MOVEQ   #0,D0
.LOOP_CONCAT:
                          MOVE.B  (A0)+,D2
                          ANDI.B  #$0F,D2
                          MULU    #10,D0
                          ADD.B   D2,D0
                          SUBQ.B  #1,D4

                          BNE     .LOOP_CONCAT
            
                          MOVE.L  D0,(HIGH_SCORE2)
                    
                          MOVEM.L (A7)+,D0-D3/A0-A1
                          RTS
                          
; -----------------------------------------------------------------------------
CONVERT_ASCII
; SAVES D0 IN CURRENT_SCORE3 BUFFER IN ASCII
; INPUT    : D0 - DATA
; OUTPUT   : D2 - LENGHT
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVEM.L D0-D1/D3/A0-A1,-(A7)
                          LEA     CURRENT_SCORE2,A0
                          MOVEQ   #0,D1      ; DIGIT COUNTER
                          MOVE.B  #0,(A0)+
    
.CONVERT_LOOP
                          ; SUBTRACT THE NECESSARY VALUE TO REACH A 
                          ; MULTIPLE OF 10, STORE THE NUMBER OF TIMES 
                          ; WE HAVE SUBTRACTED IN THE BUFFER (BYTE)
                          ; REPEAT DIVISION UNTIL THE RESULT OF THE 
                          ; SUBTRACTION IS 0

                          ; WE HAVE THE NUMBERS IN THE BUFFER IN REVERSE ORDER
                          ; READ BUFFER2 AND WRITE IN THE CORRECT ORDER, 
                          ; FOR THIS WE NEED TO HAVE STORED THE LENGTH
                          ; ADD 30 TO EACH NUMBER

                          ; NOTE: THE FIRST BYTE OF THE BUFFER IN REVERSE 
                          ; ORDER WILL ALWAYS BE 0
            
                          ADDQ.W  #1,D1
                          TST.W   D0
                          BEQ     .REVES
                          DIVU    #10,D0
                          CLR.W   D3
.REPETIR                  MOVE.L  D0,D2
                          DIVU    #10,D2
                          SWAP    D2
                          TST.W   D2
                          BEQ     .SEGUIR
                          SUBQ.W  #1,D0
                          ADDQ.W  #1,D3
                          BRA     .REPETIR
.SEGUIR                   MOVE.B  D3,(A0)+
                          BRA     .CONVERT_LOOP
.REVES
                          MOVE.W  D1,D2
                          SUBQ.W  #1,D1
                          LEA     CURRENT_SCORE3,A1
.LOOP_REVES 
                          MOVE.B  -(A0),(A1)
                          ADD.B   #48,(A1)+
                          DBRA    D1,.LOOP_REVES
                          MOVE.B  #0,(A1)+
                          
                          MOVEM.L (A7)+,D0-D1/D3/A0-A1
                          RTS
                          
; -----------------------------------------------------------------------------
GAMPLOT
; PLOTS THE GAME
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          JSR     MAPPLOT
                          JSR     PAC_PLOT
                          JSR     SCOPLOT
                          JSR     BLINKY_PLOT
                          JSR     PINKY_PLOT
                          JSR     INKY_PLOT
                          JSR     CLYDE_PLOT
                          JSR     VANISH
                          JSR     FPS_PLOT

                          RTS




























*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~

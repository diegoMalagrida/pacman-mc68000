; =============================================================================
; SYSTEM
; =============================================================================
            
; -----------------------------------------------------------------------------
SYSINIT
; INITIALIZE SYSTEM.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          ; INSTALL TRAPS ANT INTERRUPTIONS
                          MOVE.L  #SCRPLOT,($80)
                          MOVE.L  #KBDUPD,($84)
                          MOVE.L  #MSUPD,($88)
                          MOVE.L  #SNDPLAY,($8C)
                          MOVE.L  #SCRTIM,($7C)
            
                          JSR     SCRINIT
                          JSR     KBDINIT
                          JSR     SNDINIT
            
                          ; USER MODE
                          MOVE.W SR,-(A7)
                          ANDI.W #$D8FF,(A7)
                          RTE 

; -----------------------------------------------------------------------------
SNDINIT
; SOUND SYSTEM INIT.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVEM.L D0-D1/A0-A1,-(A7)
                          CLR.B   D1
                          LEA     .SNDLIST,A0
.LOOP                     MOVE.L  (A0)+,D0
                          BEQ     .DONE
                          MOVE.L  D0,A1
                          MOVE.B  #74,D0
                          TRAP    #15
                          ADDQ.B  #1,D1
                          BRA     .LOOP
.DONE                     MOVEM.L (A7)+,D0-D1/A0-A1
                          RTS
                          
.SNDSTART                 DC.B    'SND/START.wav',0
.SNDBIGDOT                DC.B    'SND/BIGDOT.wav',0
.SNDCHOMP                 DC.B    'SND/CHOMP.wav',0
.SNDCHOMP2                DC.B    'SND/CHOMP2.wav',0
.SNDDEATH                 DC.B    'SND/DEATH.wav',0
.SNDEATGHOS               DC.B    'SND/EATGHOS.wav',0

.SNDLIST                  DC.L    .SNDSTART,.SNDBIGDOT,.SNDCHOMP,.SNDCHOMP2
                          DC.L    .SNDDEATH,.SNDEATGHOS,0
            
; -----------------------------------------------------------------------------
SNDPLAY
; PLAY SOUND.
; INPUT    : D7 SOUND ID
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVEM.W D0-D1,-(A7)
                          MOVE.B  #75,D0
                          MOVE.B  D7,D1
                          TRAP    #15
                          MOVEM.W (A7)+,D0-D1
                          RTE

; -----------------------------------------------------------------------------
SCRINIT
; INIT SCREEN. SET SCREEN RESOLUTION, SET WINDOWED MODE, CLEAR SCREEN,
; ENABLE DOUBLE BUFFER, ENABLE TIMED INTERRUPT.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------

                          MOVEM.L D0-D1,-(A7)

                          ; SET SCREEN RESOLUTION
                          MOVE.B  #33,D0
                          MOVE.L  #SCRWIDTH<<16|SCRHEIGH,D1
                          TRAP    #15
            
                          ; SET WINDOWED MODE
                          MOVE.L  #1,D1
                          TRAP    #15
            
                          ; CLEAR SCREEN
                          MOVE.B  #11,D0
                          MOVE.W  #$FF00,D1
                          TRAP    #15
            
                          ; ENABLE DOUBLE BUFFER
                          MOVE.B  #92,D0
                          MOVE.B  #17,D1
                          TRAP    #15
            
                          ;ENABLE TIMED INTERRUPT
                          MOVE.B  #32,D0
                          MOVE.B  #6,D1
                          MOVE.B  #$87,D2
                          MOVE.L  #DELAY,D3
                          TRAP    #15
            
                          ; CLEAR INTERUPT COUNTER
                          CLR.W   (SCRINTCT)

                          MOVEM.L (A7)+,D0-D1
            
                          RTS

; -----------------------------------------------------------------------------
SCRPLOT
; UPDATES DOUBLE BUFFER.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          MOVEM.W D0-D1,-(A7)
                          CMP.W   #0,(STANEXT)
                          BEQ     .SALTAR
                          ; SWITCH BUFFERS
                          MOVE.B  #94,D0
                          TRAP    #15
            
                          ; CLEAR HIDDEN BUFFER
                          MOVE.B  #11,D0
                          MOVE.W  #$FF00,D1
                          TRAP    #15
.SALTAR                   MOVEM.W (A7)+,D0-D1
                          RTE

; -----------------------------------------------------------------------------
SCRTIM
; TIMED INTERRUPT SERVICE ROUTINE.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          ADDQ.B  #1,(SCRINTCT)
                          ADDQ.B  #1,(SCRCYCCT)
                          RTE

; -----------------------------------------------------------------------------
KBDINIT
; INIT KEYBOARD.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------

                          CLR.B   (KBDVAL)
                          CLR.B   (KBDEDGE)

                          RTS

; -----------------------------------------------------------------------------
KBDUPD
; UPDATE KEYBOARD INFO.
; 5 -> DEBUG
; 4 -> START
; 3 -> DOWN
; 2 -> RIGHT
; 1 -> UP
; 0 -> LEFT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------

            
                          MOVEM.L D0-D3,-(A7)
            
                          ; READ FIRST PART
                          MOVE.B  #19,D0
                          MOVE.L  #DEBUGKEY<<8|STARTKEY,D1
                          TRAP    #15
            
                          ; CONVERT TO DESIRED FORMAT
                          JSR     .PACK
            
                          ; READ SECOND PART
                          MOVE.B  #19,D0
                          MOVE.L  #KBDDOWN<<24|KBDRIGHT<<16|KBDUP<<8|KBDLEFT,D1
                          TRAP    #15
            
                          ; CONVERT TO DESIRED FORMAT
                          JSR     .PACK
            
                          ; COMPUTE KBDEDGE
                          MOVE.B  (KBDVAL),D0
                          NOT.B   D0
                          AND.B   D2,D0
                          MOVE.B  D0,(KBDEDGE)
            
                          ; STORE KBDVAL
                          MOVE.B  D2,(KBDVAL)
            
                          MOVEM.L (A7)+,D0-D3
            
                          RTE
            
.PACK                     MOVE.W  #3,D3
.LOOP                     LSL.L   #8,D1
                          ROXL.B  #1,D2
                          DBRA.W  D3,.LOOP
                          RTS


; -----------------------------------------------------------------------------
MSINIT
; INIT MOUSE.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------

                          CLR.W   (MSPOSY)
                          CLR.W   (MSPOSX)
                          CLR.W   (MSBUT)
                          RTS

; -----------------------------------------------------------------------------
MSUPD
; UPDATE MOUSE INFO
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; -----------------------------------------------------------------------------
                          ; TRAP ROUTINE TO READ
                          MOVEM.W D0-D1,-(A7)
                          MOVE.B  #61,D0
                          MOVE.B  #0,D1
                          TRAP    #15
                          MOVE.B  D0,(MSBUT)
                          MOVE.W  D1,(MSPOSX)
                          SWAP    D1
                          MOVE.W  D1,(MSPOSY)
            
                          MOVEM.W (A7)+,D0-D1
                          RTE




*~Font name~Fixedsys~
*~Font size~24~
*~Tab type~0~
*~Tab size~4~

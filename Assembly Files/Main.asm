; 10 SYS4096

*=$1000

start
        sei                     ; disable interrupts

        lda #$7f                ; disable CIA timer interrupt
        sta $dc0d               
        sta $dd0d

        ; Setting up a Raster Interrupt to happen at line 100 (Screen)
        SetupRasterInterrupt 100, music_interrupt
        
        lda #$01                ; enable raster interrupt
        sta $d01a

        ; init music
        lda #0
        tax
        tay
        jsr music_player

        cli                     ; enable interrupts

; Main Loop for the Game
main_loop
        jmp main_loop

text_display
        ; Set bit 0 in Interrupt Status Register to acknowledge raster interrupt
        inc $d019
        
        ; actual code goes here
        ; ----------------------------------------------------------------------
        inc $d020


        lda #1
        sta 1023
        lda #2
        sta 1024
        lda #3
        sta 1025
        lda #4
        sta 1026
        lda #5
        sta 1027
        lda #6
        sta 1028
        lda #7
        sta 1029
        lda #8
        sta 1030
        lda #9
        sta 1031
        lda #10
        sta 1032

        ; testing if the ASM I think will work
        ;ldx #11
        ;sta 1032, x

        dec $d020
        ;-----------------------------------------------------------------------

        SetupRasterInterrupt 100, music_interrupt

        ; Restore A, X & Y registers and CPU flags before returing from Interrupt.
        jmp $ea81

; Music Interrupt
music_interrupt
        ; Set bit 0 in Interrupt Status Register to acknowledge raster interrupt
        inc $d019

        ; actual code goes here
        ; ----------------------------------------------------------------------
        inc $d020

        ; play music
        PlayWulfPack

        dec $d020
        ;-----------------------------------------------------------------------

        SetupRasterInterrupt 200, text_display

        ; Restore A, X & Y registers and CPU flags before returing from Interrupt.
        jmp $ea81

; SetupRasterInterrupt Macro - Params: raster line #, pointer to code

defm    SetupRasterInterrupt

        lda #$7f                ; clear high bit of raster line
        and $d011               
        sta $d011

        lda #/1                ; set raster interrupt to trigger on line
        sta $d012

        lda #</2                ; set pointer for raster interrupt
        sta $0314
        lda #>/2
        sta $0315

        endm
defm    PlayWulfPack
        
        jsr music_player + $82

        endm
defm    PlayPanic

        jsr music_player2 + $43FF

        endm

*=$CC91
music_player
incbin "SID Settings\Wulfpack.sid", $7e   ; Wulfpack Code and Data

*=$2500
music_player2
incbin "SID Settings\Panic25.sid", $7e    ; Panic Code and Data







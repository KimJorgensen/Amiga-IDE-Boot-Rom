;
; Header for a ROM based scsi.device.
; Allow autoboot from IDE on Kickstart 1.3
;

RTSIZE      EQU     26                      ; ROM tag size

	section code

DiagStart:  dc.b    $90                     ; da_Config: DAC_WORDWIDE + DAC_CONFIGTIME
            dc.b    $00                     ; da_Flags
            dc.w    Romtag+RTSIZE-DiagStart ; da_Size
            dc.w    DiagEntry-DiagStart     ; da_DiagPoint
            dc.w    BootEntry-DiagStart     ; da_BootPoint
            dc.w    DevName-DiagStart       ; da_Name
            dc.w    0                       ; da_Reserved1
            dc.w    0                       ; da_Reserved2

; success = DiagEntry(BoardBase, DiagCopy, ConfigDev)
; d0                  a0         a2        a3

DiagEntry:  move.l  a1,-(sp)

            moveq   #$40,d0
            rol.l   #1,d0
            add.l   a0,d0                   ; BoardBase + ROM vector ($80)

            lea     Romtag(pc),a0           ; patch the romtag
            lea     Romtag+RTSIZE(pc),a1
            move.l  a0,2(a0)                ; set RT_MATCHWORD
            move.l  a1,6(a0)                ; set RT_ENDSKIP
            add.l   d0,14(a0)               ; adjust RT_NAME
            add.l   d0,18(a0)               ; adjust RT_IDSTRING
            add.l   d0,22(a0)               ; adjust RT_INIT

            moveq   #1,d0                   ; indicate "success"
            movea.l (sp)+,a1
            rts

BootEntry:  lea     DosName(pc),a1          ; 'dos.library'
            jsr     -96(a6)                 ; FindResident

            tst.l   d0                      ; check result
            beq.b   BootEnd

            movea.l d0,a0
            movea.l 22(a0),a0               ; set vector to DOS INIT
            jsr     (a0)                    ; and initialize DOS
BootEnd:    rts

DevName:    dc.b    'IDE Boot ROM',0        ; exec name
            dc.b    0                       ; word align

DosName:    dc.b    'dos.library',0         ; DOS library name

Romtag:                                     ; resident structure (ROM tag) and
                                            ; rest of scsi.device goes here
            END

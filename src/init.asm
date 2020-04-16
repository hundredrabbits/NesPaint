
;; init

  SEI                          ; disable IRQs
  CLD                          ; disable decimal mode
  LDX #$40
  STX JOY2                     ; disable APU frame IRQ
  LDX #$FF
  TXS                          ; Set up stack
  INX                          ; now X = 0
  STX PPUCTRL                  ; disable NMI
  STX PPUMASK                  ; disable rendering
  STX $4010                    ; disable DMC IRQs
@vwait1:                       ; First wait for vblank to make sure PPU is ready
  BIT PPUSTATUS
  BPL @vwait1
@clear:                        ; 
  LDA #$00
  STA $0000, x
  STA $0100, x
  STA $0300, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA $0200, x                 ; move all sprites off screen
  INX
  BNE @clear
@vwait2:                       ; Second wait for vblank, PPU is ready after this
  BIT PPUSTATUS
  BPL @vwait2

;; Init

loadPalette:                   ; [skip]
  BIT PPUSTATUS
  LDA #$3F
  STA PPUADDR
  LDA #$00
  STA PPUADDR
  LDX #$00
@loop:                         ; 
  LDA palettes, x
  STA PPUDATA
  INX
  CPX #$20
  BNE @loop

;;

CreateSprite:                  ; 
  LDA pos_y
  STA $0200                    ; set tile.y pos
  LDA #$01
  STA $0201                    ; set tile.id
  LDA #$00
  STA $0202                    ; set tile.attribute
  LDA pos_x
  STA $0203                    ; set tile.x pos
CreateGui:                     ; 
CreateGuiX:                    ; 
  LDA #$20
  STA $0204                    ; set tile.y pos
  LDA #$21
  STA $0205                    ; set tile.id
  LDA #$00
  STA $0206                    ; set tile.attribute
  LDA #$20
  STA $0207                    ; set tile.x pos
CreateGuiY:                    ; 
  LDA #$20
  STA $0208                    ; set tile.y pos
  LDA #$21
  STA $0209                    ; set tile.id
  LDA #$00
  STA $020a                    ; set tile.attribute
  LDA #$28
  STA $020b                    ; set tile.x pos
  LDA #%10000000               ; enable NMI, sprites from Pattern Table 1
  STA $2000
  LDA #%00010000               ; enable sprites
  STA $2001

;;

;;

Place:                         ; 
  LDA #$88
  STA pos_x
  LDA #$88
  STA pos_y
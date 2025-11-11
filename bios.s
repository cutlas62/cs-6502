.setcpu "65C02"
.debuginfo
.segment "BIOS"

ACIA_DATA   = $5000
ACIA_STATUS = $5001
ACIA_CMD    = $5002
ACIA_CTRL   = $5003

; Input a character from the serial interface.
; On return, carry flag indicates whether a key was pressed.
; If a key was pressed, the key value will be in the A register.

; Modifies: flagas, A
CHRIN:
				LDA 	ACIA_STATUS
				AND 	#$08
				BEQ 	@NO_KEY_PRESSED
				LDA 	ACIA_DATA
				JSR 	CHROUT
				SEC
				RTS

@NO_KEY_PRESSED:
				CLC
				RTS


; Output a character stored in the register A to the serial interface.

; Modifies: flags
CHROUT:
				PHA
				STA 	ACIA_DATA
				LDA 	#$FF
@TX_DELAY: 		DEC
				BNE  	@TX_DELAY
				PLA
				RTS


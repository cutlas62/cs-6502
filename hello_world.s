.setcpu "65C02"
.debuginfo
.segment "HELLO_WORLD"

.export RESET

PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

E = %10000000
RW = %01000000
RS = %00100000


RESET:
				LDX #$FF
				TXS

				LDA #%11111111 ; Set all pins on port B to output
				STA DDRB
				LDA #%11100000 ; Set top 3 pins on port A to output
				STA DDRA

				LDA #%00111000 ; Set 8-bit mode; 2-line display; 5x8 font
				JSR LCD_INSTRUCTION
				LDA #%00001110 ; display on; cursor on; blink off
				JSR LCD_INSTRUCTION
				LDA #%00000110 ; Increment and shift cursor; don't shift display
				JSR LCD_INSTRUCTION
				LDA #$00000001 ; Clear display
				JSR LCD_INSTRUCTION

				LDX #0
PRINT:
				LDA MESSAGE,x
				BEQ LOOP
				JSR PRINT_CHAR
				INX
				JMP PRINT

LOOP:
				JMP LOOP

MESSAGE: .asciiz "Hello there.    General Kenobi."

LCD_WAIT:
				PHA
				LDA #%00000000 ; Port B is input
				STA DDRB
LCDBUSY:
				LDA #RW
				STA PORTA
				LDA #(RW | E)
				STA PORTA
				LDA PORTB
				AND #%10000000
				BNE LCDBUSY

				LDA #RW
				STA PORTA
				LDA #%11111111 ; Port B is output
				STA DDRB
				PLA
				RTS

LCD_INSTRUCTION:
				JSR LCD_WAIT
				STA PORTB
				LDA #0 			; Clear RS/RW/E bits
				STA PORTA
				LDA #E 			; Set E bit to send instruction
				STA PORTA
				LDA #0 			; Clear RS/RW/E bits
				STA PORTA
				RTS

PRINT_CHAR:
				JSR LCD_WAIT
				STA PORTB
				LDA #RS 		; Set RS; Clear RW/E bits
				STA PORTA
				LDA #(RS | E) 	; Set E bit to send instruction
				STA PORTA
				LDA #RS 		; Clear E bits
				STA PORTA
				RTS

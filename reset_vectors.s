.segment "RESET_VECTORS"

.import RESET
.import RESET_WOZMON

                .word   $0F00          ; NMI vector
                .word   RESET_WOZMON   ; RESET vector
                .word   $0000          ; IRQ vector
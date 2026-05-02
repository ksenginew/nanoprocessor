0: MVI R1, 3      ; Load the immediate value 3 into register R1 (Loop Counter)
1: CLR R2         ; Clear register R2 to act as our accumulator
2: INC R2         ; [LOOP START] Increment the accumulator R2 by 1
3: DEC R1         ; Decrement the loop counter R1 by 1
4: JZR R1, 6      ; Branch to instruction 6 if R1 is zero
5: JMP 2          ; Unconditionally jump back to instruction 2 (Loop again)
6: MUL2 R2        ; [LOOP EXIT] Multiply R2 by 2
7: NOP            ; No operation to safely end the program
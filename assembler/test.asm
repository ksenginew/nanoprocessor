MOVI R7, 0   ; R7 = 0
MOVI R2, 3   ; R2 = 3 (Counter)
MOVI R3, 1   ; R3 = 1
NEG R3       ; R3 = -1
ADD R7, R2   ; R7 = R7 + R2
ADD R2, R3   ; R2 = R2 - 1
JZR R2, 6    ; If R2 = 0, Infinite Loop
JZR R0, 4    ; Jump to line 5 (Repeat loop)

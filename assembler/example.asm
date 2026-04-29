MOVI R1, 0b10 ; R1 = 2
MOVI R2, 0b1 ; R2 = 1
NEG R2 ; R2 = -R2
ADD R1, R2 ; R1 = R1 + R2
JZR R1, 6 ; If R1 = 0 jump to line 7
JZR R0, 3 ; If R0 = 0 jump to line 3

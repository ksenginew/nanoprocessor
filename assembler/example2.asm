MOVI R7, 0 ; R7 = 0
MOVI R1, 3 ; R1 = 3
MOVI R2, 1 ; R2 = 1
NEG R2 ; R2 = -R2
ADD R7, R1 ; R7 = R7 + R1
ADD R1, R2 ; R1 = R1 + R2
JZR R1, 8 ; If R1 = 0 jump to line 9
JZR R0, 4 ; If R0 = 0 jump to line 5

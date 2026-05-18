# **Assembly Instruction Set Architecture (ISA) Reference**

## **1\. Architectural State**

### **Register File**

The architecture contains a register file utilizing 3-bit addressing, allowing for 8 distinct registers:

* **R0**: Read-only register, permanently hardwired to 0\. Any write operations to this register are ignored.  
* **R1 to R7**: General-purpose registers (GPR) used for arithmetic, data movement, and control flow operations.

## **2\. Base Instruction Set (Primitives)**

These are the foundational instructions implemented directly in the hardware. All other instructions are translated into these by the assembler.

| Instruction | Format / Encoding | Description |
| :---- | :---- | :---- |
| **ADD A, B, C** | 0 0 A A A B B B C C C X | **Add:** Adds the contents of register B and register C, storing the result in register A. *(X is a don't-care or padding bit).* |
| **SUB A, B, C** | 0 1 A A A B B B C C C X | **Subtract:** Subtracts the contents of register C from register B, storing the result in register A. |
| **ADDI A, B, I** | 1 0 A A A B B B I I I I | **Add Immediate:** Adds the 4-bit immediate value I to the contents of register B, storing the result in register A. |
| **BEQ A, I, D** | 1 1 D D D A A A I I I I | **Branch if Equal (Immediate):** Compares register A to the 4-bit immediate value I. If they are equal, branches to the 3-bit destination address/offset D. |

## 

## **3\. Pseudo-Instructions & Aliases**

The following instructions are synthesized by the assembler using the 4 base instructions and the hardwired R0 (0) register. They simplify programming by supporting 0, 1, 2, and 3 parameter formats, including **implied source/destination parameters**. Multiple supported aliases are provided for flexibility.

### 

### **Data Movement**

| Pseudo-Instruction | Alias / Syntax | Expansion (Base Translation) | Description |
| :---- | :---- | :---- | :---- |
| **Move Register** | MOV A, B or MV A, B | ADD A, B, R0 | Copies the value from register B into register A (A \= B \+ 0). |
| **Load Immediate** | MOVI A, I or MVI A, I | ADDI A, R0, I | Loads the immediate value I directly into register A (A \= 0 \+ I). |
| **Clear Register** | CLR A | ADD A, R0, R0 | Sets the value of register A to exactly 0 (A \= 0 \+ 0). |

### 

### 

### 

### 

### **Arithmetic Operations**

| Pseudo-Instruction | Alias / Syntax | Expansion (Base Translation) | Description |
| :---- | :---- | :---- | :---- |
| **Add (Implied)** | ADD A, B | ADD A, A, B | Adds the contents of B to A, storing the result in A. |
| **Subtract (Implied)** | SUB A, B | SUB A, A, B | Subtracts the contents of B from A, storing the result in A. |
| **Add Imm. (Implied)** | ADDI A, I | ADDI A, A, I | Adds the immediate value I to A, storing the result in A. |
| **Negate** | NEG A, B | SUB A, R0, B | Negates the value in B and stores it in A (A \= 0 \- B). |
| **Negate (Implied)** | NEG A | SUB A, R0, A | Negates the value in A and stores it back in A (A \= 0 \- A). |
| **Increment** | INC A | ADDI A, A, 1 | Increments the value of register A by 1\. |
| **Decrement** | DEC A | ADDI A, A, \-1 | Decrements the value of register A by 1 *(assuming signed immediate)*. |
| **Subtract Imm.** | SUBI A, B, I | ADDI A, B, \-I | Subtracts immediate I from B and stores in A *(requires two's complement assembler evaluation)*. |
| **Sub. Imm. (Implied)** | SUBI A, I | ADDI A, A, \-I | Subtracts immediate I from A and stores in A. |
| **Multiply by 2** | MUL2 A, B | ADD A, B, B | Multiplies B by 2 (equivalent to a logical shift left by 1\) and stores in A. |
| **Mul. by 2 (Implied)** | MUL2 A | ADD A, A, A | Multiplies A by 2 and stores the result back in A. |

### **Control Flow (Branching)**

| Pseudo-Instruction | Alias / Syntax | Expansion (Base Translation) | Description |
| :---- | :---- | :---- | :---- |
| **Branch/Jump Unconditional** | B D, J D, or JMP D | BEQ R0, 0, D | Unconditionally jumps to destination D because R0 (0) \== 0 is always true. |
| **Branch/Jump if Zero** | BEQZ A, D or JZR A, D | BEQ A, 0, D | Jumps to destination D if the value in register A is equal to 0\. |

### **System & Control**

| Pseudo-Instruction | Alias / Syntax | Expansion (Base Translation) | Description |
| :---- | :---- | :---- | :---- |
| **No Operation** | NOP | ADD R0, R0, R0 | Performs no state change. Adds 0 \+ 0 and writes to the read-only R0, safely consuming a cycle. |

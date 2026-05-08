# Nanoprocessor

Small 4-bit nanoprocessor built in VHDL for Vivado. The design includes a register bank, simple ALU, program counter, ROM-based instruction memory, and a seven-segment output path for displaying register data.

## Project Layout

- `nanoprocessor.srcs/sources_1/new/` - synthesizable VHDL sources
- `nanoprocessor.srcs/sim_1/new/` - simulation testbenches
- `assembler/` - Python assembler that converts `.asm` programs into machine code and VHDL ROM content

## Architecture Overview

The CPU executes 12-bit instructions with four base operations:

- `ADD`
- `SUB`
- `ADDI`
- `BEQ`

The assembler also supports pseudo-instructions such as `MOV`, `MOVI`/`MVI`, `CLR`, `NEG`, `INC`, `DEC`, `SUBI`, `MUL2`, `B`/`J`/`JMP`, `BEQZ`/`JZR`, and `NOP`.

## Assembler

Use the assembler to translate an input program into `.hex`, `.oct`, `.bin`, and `.vhdl` files:

```powershell
py .\assembler\main.py .\assembler\test.asm
```

The sample program in `assembler/test.asm` demonstrates the supported syntax and label usage. The assembler accepts decimal, binary, octal, hexadecimal, and label-based immediates.

## Simulation

Each source module has a matching testbench in `nanoprocessor.srcs/sim_1/new/`. Key benches include:

- `tb_Nanoprocessor.vhd`
- `tb_Clock_Divider.vhd`
- `TB_Reg_Bank.vhd`
- `tb_Instruction_Decoder.vhd`
- `TB_MUX_2_way_3_bit.vhd`
- `TB_MUX_2_way_4_bit.vhd`
- `TB_MUX_8_way_4_bit.vhd`
- `TB_Decoder_2_to_4.vhd`
- `TB_Decoder_3_to_8.vhd`
- `D_FF_tb.vhd`
- `TB_FA.vhd`
- `TB_LUT_16_7.vhd`
- `TB_Rom.vhd`

The top-level nanoprocessor testbench uses a shortened clock-divider preload so simulation advances quickly.

## Vivado Build Flow

1. Open `nanoprocessor.xpr` in Vivado.
2. Synthesize the design.
3. Run simulation on the relevant testbench.
4. Implement and generate the bitstream if you want to program hardware.

## Notes

- The design uses low-level gate-style VHDL in several blocks to keep the structure simple and explicit.
- The clock divider is generic so simulation can use a short divide value while synthesis keeps the default hardware divider.

# Nanoprocessor

A small 4-bit nanoprocessor designed in VHDL for Xilinx Vivado. The project includes a register bank, ALU, program counter, ROM-based instruction memory, a clock divider, and a seven-segment output path for displaying register data on BASYS 3.

The repository also contains a custom Python assembler that translates a readable assembly language into 12-bit machine code and can emit a VHDL ROM initialization file for simulation or synthesis.

## What This Project Includes

- A complete top-level processor in VHDL.
- Reusable logic blocks such as adders, multiplexers, decoders, registers, ROM, and a register file.
- A simulation testbench set for individual modules and the top-level CPU.
- A custom assembler with support for labels, pseudo-instructions, and multiple immediate formats.
- A report and ISA reference documenting the design choices and instruction encoding.

## Repository Layout

- `nanoprocessor.srcs/sources_1/new/` - synthesizable VHDL source files.
- `nanoprocessor.srcs/sim_1/new/` - VHDL testbenches for modules and the top-level CPU.
- `assembler/` - Python assembler and sample assembly program.
- `isa.md` - instruction set reference.
- `report.md` - lab report and design write-up.

## Top-Level Architecture

The main entity is `Nanoprocessor` in `nanoprocessor.srcs/sources_1/new/Nanoprocessor.vhd`. It connects the following major blocks:

- Program Counter
- Instruction Decoder
- ROM
- Register Bank
- 4-bit Add/Sub unit
- 2-way and 8-way multiplexers
- Clock Divider
- 7-segment lookup table

The processor uses 12-bit instructions and 3-bit register addresses, giving access to eight registers, with `R0` hardwired to zero.

## Instruction Set

The hardware implements four base instructions:

- `ADD A, B, C`
- `SUB A, B, C`
- `ADDI A, B, I`
- `BEQ A, I, D`

See `isa.md` for the full ISA reference, including pseudo-instructions such as:

- `MOV`, `MV`
- `MOVI`, `MVI`
- `CLR`
- `NEG`
- `INC`, `DEC`
- `SUBI`
- `MUL2`
- `B`, `J`, `JMP`
- `BEQZ`, `JZR`
- `NOP`

## Assembler

The assembler is in `assembler/main.py`. It performs a two-pass translation:

1. Resolve labels.
2. Translate pseudo-instructions into base instructions.
3. Encode the result as 12-bit machine words.
4. Write `.hex`, `.oct`, `.bin`, and `.vhdl` output files.

### Run the sample program

```powershell
py .\assembler\main.py .\assembler\test.asm
```

This will generate:

- `assembler/test.hex`
- `assembler/test.oct`
- `assembler/test.bin`
- `assembler/test.vhdl`

### Supported immediates

The assembler accepts decimal, binary, octal, hexadecimal, negative values, and labels where the instruction format allows them.

### Example program

`assembler/test.asm` contains a short loop that computes the sum of `1 + 2 + 3` and leaves the result in `R7`.

## Simulation

Each main source block has a matching testbench in `nanoprocessor.srcs/sim_1/new/`. Useful benches include:

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

The top-level testbench uses a shortened clock-divider preload so simulation runs quickly.

## Vivado Workflow

1. Open `nanoprocessor.xpr` in Vivado.
2. Run synthesis.
3. Run simulation on the desired testbench.
4. Run implementation.
5. Generate the bitstream if you want to program the BASYS 3 board.

## Notes on Hardware Deployment

- The design uses a clock divider so the processor can be observed at a human-friendly speed on hardware.
- Output is routed to LEDs and a seven-segment display.
- The project was built around BASYS 3 constraints, with board pin mapping handled through `nanoprocessor.srcs/constrs_1/new/Basys3.xdc`.

## Design Style

Several modules are implemented in a gate-level or structural style rather than with high-level behavioral VHDL. This keeps the datapath explicit and makes the design easier to study for computer organization and digital design labs.

## Getting Started

If you just want to inspect the project, start with these files:

- `README.md`
- `isa.md`
- `nanoprocessor.srcs/sources_1/new/Nanoprocessor.vhd`
- `assembler/main.py`
- `assembler/test.asm`

If you want to verify behavior, begin with `tb_Nanoprocessor.vhd` and the module testbenches in `nanoprocessor.srcs/sim_1/new/`.

## Team Credits

This project was completed by a 4-member team. Core responsibilities were split as follows:

- K.A.K.K. Santhusa - Instruction Decoder, Program ROM, and custom Python assembler.
- W. A. A. T. Silva - Multiplexers and decoders, including manual basic-gate Boolean optimization.
- G.Y.S Sanjaya - Arithmetic units, including the adders/subtractors, and the Program Counter.
- P.D.Y Sewwandi - Register file design, project documentation, and report writing.

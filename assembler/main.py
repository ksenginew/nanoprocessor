import sys
import os

# --- Global Masks ---
MASK_12 = 0xFFF
MASK_4  = 0xF
MASK_3  = 0x7

def parse_reg(reg_str):
    """Parses a register string (e.g., 'R1', 'r7', '0') to its 3-bit integer value."""
    reg_str = reg_str.upper().strip()
    if reg_str.startswith('R'):
        reg_str = reg_str[1:]
    try:
        val = int(reg_str)
        if not (0 <= val <= 7):
            raise ValueError
        return val
    except ValueError:
        raise ValueError(f"Invalid register specification: {reg_str}")

def parse_imm(imm_str, bits, labels=None):
    """Parses immediate string values, supporting bin/oct/dec/hex, negatives, and labels."""
    labels = labels or {}
    
    # Check if the immediate is a known label
    if imm_str in labels:
        val = labels[imm_str]
    else:
        try:
            val = int(imm_str, 0) # Base 0 lets Python auto-detect 0x, 0b, 0o
        except ValueError:
            raise ValueError(f"Invalid immediate value or unknown label: {imm_str}")

    # Convert to two's complement based on bit width
    if bits == 4:
        return val & MASK_4
    elif bits == 3:
        return val & MASK_3
    else:
        return val

def translate_pseudo(tokens):
    """Translates pseudo-instructions and implied operand aliases into base primitives."""
    op = tokens[0].upper()
    
    # --- Data Movement ---
    if op in ('MOV', 'MV'):
        return ['ADD', tokens[1], tokens[2], 'R0']
    elif op in ('MOVI', 'MVI'):
        return ['ADDI', tokens[1], 'R0', tokens[2]]
    elif op == 'CLR':
        return ['ADD', tokens[1], 'R0', 'R0']
        
    # --- Arithmetic Operations ---
    elif op == 'ADD' and len(tokens) == 3:
        return ['ADD', tokens[1], tokens[1], tokens[2]]
    elif op == 'SUB' and len(tokens) == 3:
        return ['SUB', tokens[1], tokens[1], tokens[2]]
    elif op == 'ADDI' and len(tokens) == 3:
        return ['ADDI', tokens[1], tokens[1], tokens[2]]
    elif op == 'NEG':
        if len(tokens) == 3:
            return ['SUB', tokens[1], 'R0', tokens[2]]
        else:
            return ['SUB', tokens[1], 'R0', tokens[1]]
    elif op == 'INC':
        return ['ADDI', tokens[1], tokens[1], '1']
    elif op == 'DEC':
        return ['ADDI', tokens[1], tokens[1], '-1']
    elif op == 'SUBI':
        # Subtraction of an immediate evaluates the negative of the immediate in the assembler
        imm_str = tokens[-1]
        try:
            imm_val = int(imm_str, 0)
        except ValueError:
            raise ValueError(f"SUBI requires a literal number, got: {imm_str}")
            
        neg_imm = (-imm_val) & MASK_4
        if len(tokens) == 4: # SUBI A, B, I
            return ['ADDI', tokens[1], tokens[2], str(neg_imm)]
        else: # SUBI A, I
            return ['ADDI', tokens[1], tokens[1], str(neg_imm)]
    elif op == 'MUL2':
        if len(tokens) == 3:
            return ['ADD', tokens[1], tokens[2], tokens[2]]
        else:
            return ['ADD', tokens[1], tokens[1], tokens[1]]
            
    # --- Control Flow ---
    elif op in ('B', 'J', 'JMP'):
        return ['BEQ', 'R0', '0', tokens[1]]
    elif op in ('BEQZ', 'JZR'):
        return ['BEQ', tokens[1], '0', tokens[2]]
        
    # --- System ---
    elif op == 'NOP':
        return ['ADD', 'R0', 'R0', 'R0']
        
    # Base instructions return as-is
    return tokens

def encode_base(tokens, labels):
    """Encodes the 4 base primitives into their 12-bit binary instruction formats."""
    op = tokens[0].upper()
    
    if op == 'ADD':
        A = parse_reg(tokens[1])
        B = parse_reg(tokens[2])
        C = parse_reg(tokens[3])
        return (0b00 << 10) | (A << 7) | (B << 4) | (C << 1) | 0
        
    elif op == 'SUB':
        A = parse_reg(tokens[1])
        B = parse_reg(tokens[2])
        C = parse_reg(tokens[3])
        return (0b01 << 10) | (A << 7) | (B << 4) | (C << 1) | 0
        
    elif op == 'ADDI':
        A = parse_reg(tokens[1])
        B = parse_reg(tokens[2])
        I = parse_imm(tokens[3], 4, labels)
        return (0b10 << 10) | (A << 7) | (B << 4) | I
        
    elif op == 'BEQ':
        A = parse_reg(tokens[1])
        I = parse_imm(tokens[2], 4, labels)
        D = parse_imm(tokens[3], 3, labels) # Dest is a 3-bit address/offset
        return (0b11 << 10) | (D << 7) | (A << 4) | I
        
    else:
        raise ValueError(f"Unknown Instruction: {op}")

def assemble(source_code):
    """Processes full source string to a list of 12-bit integers using two passes."""
    labels = {}
    cleaned_instructions = []
    
    # PASS 1: Clean code and resolve labels
    current_address = 0
    for line in source_code.splitlines():
        # Strip comments
        code_line = line.split(';')[0].split('#')[0].strip()
        if not code_line:
            continue
            
        # Extract labels (e.g., "LOOP: ADD R1, R2")
        if ':' in code_line:
            label_part, inst_part = code_line.split(':', 1)
            label_name = label_part.strip()
            labels[label_name] = current_address
            code_line = inst_part.strip()
            if not code_line:
                continue # Label was on a line by itself
                
        cleaned_instructions.append((current_address + 1, code_line))
        current_address += 1

    # PASS 2: Translate and encode
    machine_code = []
    for line_num, code_line in cleaned_instructions:
        # Tokenize by replacing commas with spaces
        tokens = code_line.replace(',', ' ').split()
        
        try:
            base_tokens = translate_pseudo(tokens)
            binary_word = encode_base(base_tokens, labels)
            machine_code.append(binary_word)
        except Exception as e:
            print(f"Error resolving instruction -> {code_line}")
            print(f"Details: {e}")
            sys.exit(1)
            
    return machine_code

def export_files(machine_code, base_filename):
    """Generates the .hex, .oct, .bin, and .vhdl output files."""
    
    with open(f"{base_filename}.hex", 'w') as f:
        for word in machine_code:
            f.write(f"{word:03X}\n")

    with open(f"{base_filename}.oct", 'w') as f:
        for word in machine_code:
            f.write(f"{word:04o}\n")

    with open(f"{base_filename}.bin", 'w') as f:
        for word in machine_code:
            f.write(f"{word:012b}\n")

    vhdl_template = """library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ROM is
    Port ( addr : in STD_LOGIC_VECTOR (7 downto 0);
           data : out STD_LOGIC_VECTOR (11 downto 0));
end ROM;

architecture Behavioral of ROM is
    type rom_type is array (0 to 8) of STD_LOGIC_VECTOR(11 downto 0);
    constant ROM_CONTENT : rom_type := (
{content}
        others => "000000000000"
    );
begin
    data <= ROM_CONTENT(to_integer(unsigned(addr)));
end Behavioral;
"""
    content_lines = []
    for idx, word in enumerate(machine_code):
        content_lines.append(f'        {idx} => "{word:012b}",')
        
    with open(f"{base_filename}.vhdl", 'w') as f:
        f.write(vhdl_template.replace("{content}", '\n'.join(content_lines)))

    print(f"Successfully assembled {len(machine_code)} instructions.")
    print(f"Outputs generated: {base_filename}.hex, .oct, .bin, .vhdl")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python rv4i_assembler.py <input.asm>")
        sys.exit(1)

    input_file = sys.argv[1]
    base_name = os.path.splitext(input_file)[0]

    with open(input_file, 'r') as f:
        source = f.read()

    machine_code = assemble(source)
    export_files(machine_code, base_name)
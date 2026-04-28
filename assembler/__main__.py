import sys

class NanoprocessorAssembler:
    def __init__(self):
        # 3-bit Opcode (Control) mappings based on our hardware wiring
        self.OP_ADD  = "000"
        self.OP_SUB  = "010"
        self.OP_MOVI = "100"
        self.OP_JZR  = "001"

    def _parse_reg(self, reg_str):
        """Extracts the integer value from a register string (e.g., 'R7' -> '111')."""
        reg_str = reg_str.upper().strip()
        if not reg_str.startswith('R') or not reg_str[1:].isdigit():
            raise ValueError(f"Invalid register format: {reg_str}. Expected R0-R7.")
        
        reg_val = int(reg_str[1:])
        if reg_val < 0 or reg_val > 7:
            raise ValueError(f"Register out of bounds: {reg_str}. Must be R0 to R7.")
        
        return f"{reg_val:03b}"

    def _parse_imm(self, imm_str, bits=4):
        """Parses an immediate integer and converts it to a binary string."""
        imm_val = eval(imm_str.strip())
        mask = (1 << bits) - 1 # 0b1111
        imm_val = imm_val & mask
        return format(imm_val, f'0{bits}b')

    def assemble_line(self, line):
        """Assembles a single line of assembly into a 12-bit binary string."""
        # Strip comments and empty lines
        line = line.split(';')[0].strip()
        if not line:
            return None 
        
        # Tokenize (replace commas with spaces, then split)
        tokens = line.replace(',', ' ').split()
        opcode = tokens[0].upper()

        try:
            # ==========================================
            # DIRECT INSTRUCTIONS & CORE PSEUDO-CODES
            # ==========================================
            
            if opcode in ["MOV", "MOVI"]:
                # Hardware: 100 [R] [00] [d(4-bit)]
                rd = self._parse_reg(tokens[1])
                imm = self._parse_imm(tokens[2], bits=4)
                return f"{self.OP_MOVI}{rd}00{imm}"

            elif opcode == "ADD":
                # Hardware: 000 [Ra] [Rb] [Rc]
                ra = self._parse_reg(tokens[1])
                rb = self._parse_reg(tokens[2])
                if (len(tokens) == 4):
                    rc = self._parse_reg(tokens[3])
                    return f"{self.OP_ADD}{ra}{rb}{rc}"
                else:
                    # Ra = Ra +Rb
                    return f"{self.OP_ADD}{ra}{ra}{rb}"

            elif opcode == "SUB":
                # Hardware: 010 [Ra] [Rb] [Rc]
                ra = self._parse_reg(tokens[1])
                rb = self._parse_reg(tokens[2])
                if (len(tokens) == 4):
                    rc = self._parse_reg(tokens[3])
                    return f"{self.OP_SUB}{ra}{rb}{rc}"
                else:
                    # Ra = Ra - Rb
                    return f"{self.OP_SUB}{ra}{ra}{rb}"

            elif opcode == "JZR":
                # Hardware: 001 [d(3-bit)] [R] [000]
                r = self._parse_reg(tokens[1])
                d = self._parse_imm(tokens[2], bits=3)
                r0 = "000"
                return f"{self.OP_JZR}{d}{r}{r0}"

            # ==========================================
            # ADVANCED PSEUDO-INSTRUCTIONS
            # ==========================================

            elif opcode == "NEG":
                # Pseudo: R = -R
                # Maps to: SUB R, R0, R -> 010 [R] [000] [R]
                r = self._parse_reg(tokens[1])
                r0 = "000"
                return f"{self.OP_SUB}{r}{r0}{r}"

            elif opcode == "CLR":
                # Pseudo: Clear register to 0
                # Maps to: MOVI R, 0 -> 100 [R] 00 0000
                r = self._parse_reg(tokens[1])
                return f"{self.OP_MOVI}{r}000000"

            elif opcode == "JMP":
                # Pseudo: Unconditional Jump
                # Maps to: JZR R0, d -> 001 [d] [000] [000] (Since R0 is always 0, it always jumps)
                d = self._parse_imm(tokens[1], bits=3)
                r0 = "000"
                return f"{self.OP_JZR}{d}{r0}{r0}"

            elif opcode == "COPY":
                # Pseudo: Copy Rb to Ra
                # Maps to: ADD Ra, Rb, R0 -> 000 [Ra] [Rb] [000]
                ra = self._parse_reg(tokens[1])
                rb = self._parse_reg(tokens[2])
                r0 = "000"
                return f"{self.OP_ADD}{ra}{rb}{r0}"
            
            elif opcode == "NOP":
                # Pseudo: No Operation
                # Maps to: ADD R0, R0, R0 -> 000 [000] [000] [000]
                return f"{self.OP_ADD}000000000"

            else:
                raise ValueError(f"Unsupported instruction: {opcode}")

        except IndexError:
            raise SyntaxError(f"Missing operands in line: '{line}'")
        except Exception as e:
            raise Exception(f"Error on line '{line}': {str(e)}")

    def assemble(self, assembly_text):
        """Processes full assembly text and returns all formatted outputs."""
        machine_codes = []
        original_lines = []

        for line in assembly_text.strip().split('\n'):
            parsed_line = line.strip()
            mcode = self.assemble_line(parsed_line)
            if mcode:
                machine_codes.append(mcode)
                original_lines.append(parsed_line)

        return self._generate_outputs(machine_codes, original_lines)

    def _generate_outputs(self, codes, lines):
        """Generates formats: Binary, Hex, Octal, VHDL LUT."""
        out_bin, out_hex, out_oct = [], [], []
        out_vhdl = [
            "type rom_type is array (0 to 15) of std_logic_vector(11 downto 0);",
            "signal ROM : rom_type := ("
        ]

        for i, (bin_str, orig) in enumerate(zip(codes, lines)):
            val = int(bin_str, 2)
            
            out_bin.append(bin_str)
            out_hex.append(f"{val:03X}")
            out_oct.append(f"{val:04o}")
            
            clean_orig = orig.split(';')[0].strip()
            out_vhdl.append(f'    {i:<2} => "{bin_str}", -- {clean_orig}')

        out_vhdl.append('    others => "000000000000"')
        out_vhdl.append(");")

        return {
            "Binary": "\n".join(out_bin),
            "Hexadecimal": "\n".join(out_hex),
            "Octal": "\n".join(out_oct),
            "VHDL_LUT": "\n".join(out_vhdl)
        }

# ==========================================
# Example Usage with New Instructions
# ==========================================
if __name__ == "__main__":
    # write cli tool
    if (len(sys.argv) > 2):
        in_file = sys.argv[1]
        out_file = sys.argv[2]
        with open(in_file, 'r') as f:
            assembly_code = f.read()

            assembler = NanoprocessorAssembler()
            results = assembler.assemble(assembly_code)

        with open(out_file, 'w') as f:
            # check by file ext
            if out_file.endswith('.bin'):
                f.write(results["Binary"])
            elif out_file.endswith('.hex'):
                f.write(results["Hexadecimal"])
            elif out_file.endswith('.oct'):
                f.write(results["Octal"])
            elif out_file.endswith('.vhdl'):
                f.write(results["VHDL_LUT"])
            else:
                print("Unsupported output file format. Please use .bin, .hex, .oct, or .vhdl")

## Appendix: Source Code and Testbench

### Synthesizable Sources

#### Add_Sub_4bit.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity Add_Sub_4bit is
    port (
        A        : in std_logic_vector (3 downto 0);
        B        : in std_logic_vector (3 downto 0);
        Sub      : in std_logic;
        Res      : out std_logic_vector (3 downto 0);
        OverFlow : out std_logic;
        Zero     : out std_logic);
end Add_Sub_4bit;
architecture Behavioral of Add_Sub_4bit is
    signal B_mod : std_logic_vector(3 downto 0);
    component RCA4bit
        port (
            A        : in std_logic_vector(3 downto 0);
            B        : in std_logic_vector(3 downto 0);
            C_in     : in std_logic;
            SUM      : out std_logic_vector(3 downto 0);
            Zero     : out std_logic;
            OverFlow : out std_logic
        );
    end component;
begin
    B_mod(0) <= B(0) xor Sub;
    B_mod(1) <= B(1) xor Sub;
    B_mod(2) <= B(2) xor Sub;
    B_mod(3) <= B(3) xor Sub;
    RCA1 : RCA4bit
    port map
    (
        A        => A,
        B        => B_mod,
        C_in     => Sub,
        SUM      => Res,
        Zero     => Zero,
        OverFlow => OverFlow
    );
end Behavioral;
```

#### Adder3bits.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity Adder3bits is
    port (
        A : in std_logic_vector (2 downto 0);
        E : out std_logic_vector (2 downto 0));
end Adder3bits;
architecture Behavioral of Adder3bits is
    signal B : std_logic_vector (2 downto 0) := "001";
    signal C : std_logic_vector (2 downto 0);
    component FA
        port (
            A     : in std_logic;
            B     : in std_logic;
            C_in  : in std_logic;
            SUM   : out std_logic;
            C_out : out std_logic
        );
    end component;
begin
    FA0 : FA
    port map
    (
        A     => A(0),
        B     => B(0),
        C_in  => '0',
        SUM   => E(0),
        C_out => C(0)
    );
    FA1 : FA
    port map
    (
        A     => A(1),
        B     => B(1),
        C_in  => C(0),
        SUM   => E(1),
        C_out => C(1)
    );
    FA2 : FA
    port map
    (
        A     => A(2),
        B     => B(2),
        C_in  => C(1),
        SUM   => E(2),
        C_out => C(2)
    );
end Behavioral;
```

#### Clock_Divider.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity Clock_Divider is
    generic (
        PRELOAD_VAL : integer := 49999999);
    port (
        clk_in  : in std_logic;
        clk_out : out std_logic);
end Clock_Divider;
architecture Behavioral of Clock_Divider is
    signal count      : integer range 0 to PRELOAD_VAL := 0;
    signal clk_status : std_logic                   := '0';
begin
    process (clk_in) begin
        if rising_edge(clk_in) then
            if count = PRELOAD_VAL then
                clk_status <= not clk_status;
                count      <= 0;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
    clk_out <= clk_status;
end Behavioral;
```

#### D_FF.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity D_FF is
    port (
        D   : in std_logic;
        Res : in std_logic;
        Clk : in std_logic;
        EN  : in std_logic;
        Q   : out std_logic);
end D_FF;
architecture Behavioral of D_FF is
    signal q_reg : std_logic;
begin
    process (Clk, Res)
    begin
        if Res = '1' then
            q_reg <= '0';
        elsif rising_edge(Clk) then
            if EN = '1' then
                q_reg <= D;
            end if;
        end if;
    end process;
    Q <= q_reg;
end Behavioral;
```

#### Decoder_2_to_4.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity Decoder_2_to_4 is
    port (
        I  : in std_logic_vector (1 downto 0);
        EN : in std_logic;
        Y  : out std_logic_vector (3 downto 0));
end Decoder_2_to_4;
architecture Behavioral of Decoder_2_to_4 is
begin
    Y(0) <= not(I(0)) and not(I(1)) and EN;
    Y(1) <= I(0) and not(I(1)) and EN;
    Y(2) <= not(I(0)) and (I(1)) and EN;
    Y(3) <= (I(0)) and (I(1)) and EN;
end Behavioral;
```

#### Decoder_3_to_8.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity Decoder_3_to_8 is
    port (
        I  : in std_logic_vector (2 downto 0);
        EN : in std_logic;
        Y  : out std_logic_vector (7 downto 0));
end Decoder_3_to_8;
architecture Behavioral of Decoder_3_to_8 is
    component Decoder_2_to_4
        port (
            I  : in std_logic_vector;
            EN : in std_logic;
            Y  : out std_logic_vector);
    end component;
    signal I0, I1       : std_logic_vector (1 downto 0);
    signal Y0, Y1       : std_logic_vector (3 downto 0);
    signal en0, en1, I2 : std_logic;
begin
    Decoder_2_to_4_0 : Decoder_2_to_4
    port map
    (
        I  => I0,
        EN => en0,
        Y  => Y0);
    Decoder_2_to_4_1 : Decoder_2_to_4
    port map
    (
        I  => I1,
        EN => en1,
        Y  => Y1);
    en0           <= not(I(2)) and EN;
    en1           <= I(2) and EN;
    I0            <= I(1 downto 0);
    I1            <= I(1 downto 0);
    I2            <= I(2);
    Y(3 downto 0) <= Y0;
    Y(7 downto 4) <= Y1;
end Behavioral;
```

#### FA.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity FA is
    port (
        A     : in std_logic;
        B     : in std_logic;
        C_in  : in std_logic;
        SUM   : out std_logic;
        C_out : out std_logic);
end FA;
architecture Behavioral of FA is
begin
    SUM   <= A xor B xor C_in;
    C_out <= (A and B) or (A and C_in) or (B and C_in);
end Behavioral;
```

#### Instruction_Decoder.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity Instruction_Decoder is
    port (
        Instruction : in std_logic_vector (11 downto 0); -- 12-bit instruction
        Zero_Flag   : in std_logic; -- Zero flag from the 4-bit Add/Sub unit
        Load_Sel     : out std_logic;
        Add_Sub_Sel  : out std_logic;
        Write_Enable : out std_logic;
        Reg_En       : out std_logic_vector (2 downto 0);
        Reg_Sel_A    : out std_logic_vector (2 downto 0);
        Reg_Sel_B    : out std_logic_vector (2 downto 0);
        Imm_Val      : out std_logic_vector (3 downto 0);
        Jump_Addr    : out std_logic_vector (2 downto 0);
        Jump_Flag    : out std_logic
    );
end Instruction_Decoder;
architecture Behavioral of Instruction_Decoder is
    signal Temp_Jump : std_logic;
begin
    Load_Sel    <= Instruction(11);
    Add_Sub_Sel <= Instruction(10);
    Reg_En    <= Instruction(9 downto 7); -- rd
    Jump_Addr <= Instruction(9 downto 7); -- addr
    Reg_Sel_A <= Instruction(6 downto 4); -- rs1
    Reg_Sel_B <= Instruction(3 downto 1); -- rs2
    Imm_Val   <= Instruction(3 downto 0); -- imm
    Temp_Jump <= Instruction(11) and Instruction(10);
    Jump_Flag <= Temp_Jump and Zero_Flag;
    Write_Enable <= not Temp_Jump;
end Behavioral;
```

#### LUT_16_7.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
entity LUT_16_7 is
    port (
        address : in std_logic_vector (3 downto 0);
        data    : out std_logic_vector (6 downto 0));
end LUT_16_7;
architecture Behavioral of LUT_16_7 is
    type rom_type is array (0 to 15) of std_logic_vector(6 downto 0);
    signal sevenSegment_ROM : rom_type := (
    "1000000", --0 
    "1111001", --1 
    "0100100", --2 
    "0110000", --3 
    "0011001", --4 
    "0010010", --5 
    "0000010", --6 
    "1111000", --7 
    "0000000", --8 
    "0010000", --9 
    "0001000", --A 
    "0000011", --B 
    "1000110", --C 
    "0100001", --D 
    "0000110", --E 
    "0001110" --F 
    );
begin
    data <= sevenSegment_ROM(to_integer(unsigned(address)));
end Behavioral;
```

#### MUX_2_way_3_bit.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity MUX_2_way_3_bit is
    port (
        A : in std_logic_vector (2 downto 0);
        B : in std_logic_vector (2 downto 0);
        S : in std_logic;
        Q : out std_logic_vector (2 downto 0));
end MUX_2_way_3_bit;
architecture Behavioral of MUX_2_way_3_bit is
begin
    Q(0) <= (A(0) and not(S)) or (B(0) and S);
    Q(1) <= (A(1) and not(S)) or (B(1) and S);
    Q(2) <= (A(2) and not(S)) or (B(2) and S);
end Behavioral;
```

#### MUX_2_way_4_bit.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity MUX_2_way_4_bit is
    port (
        A : in std_logic_vector (3 downto 0);
        B : in std_logic_vector (3 downto 0);
        S : in std_logic;
        Q : out std_logic_vector (3 downto 0));
end MUX_2_way_4_bit;
architecture Behavioral of MUX_2_way_4_bit is
begin
    Q(0) <= (A(0) and (not S)) or (B(0) and S);
    Q(1) <= (A(1) and (not S)) or (B(1) and S);
    Q(2) <= (A(2) and (not S)) or (B(2) and S);
    Q(3) <= (A(3) and (not S)) or (B(3) and S);
end Behavioral;
```

#### MUX_8_way_4_bit.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity MUX_8_way_4_bit is
    port (
        S  : in std_logic_vector (2 downto 0);
        R0 : in std_logic_vector (3 downto 0);
        R1 : in std_logic_vector (3 downto 0);
        R2 : in std_logic_vector (3 downto 0);
        R3 : in std_logic_vector (3 downto 0);
        R4 : in std_logic_vector (3 downto 0);
        R5 : in std_logic_vector (3 downto 0);
        R6 : in std_logic_vector (3 downto 0);
        R7 : in std_logic_vector (3 downto 0);
        Q  : out std_logic_vector (3 downto 0));
end MUX_8_way_4_bit;
architecture Behavioral of MUX_8_way_4_bit is
    component Decoder_3_to_8
        port (
            I  : in std_logic_vector;
            EN : in std_logic;
            Y  : out std_logic_vector);
    end component;
    signal I0  : std_logic_vector (2 downto 0);
    signal EN0 : std_logic;
    signal X   : std_logic_vector (7 downto 0);
begin
    Decoder_3_to_8_0 : Decoder_3_to_8
    port map
    (
        I  => I0,
        EN => EN0,
        Y  => X);
    EN0  <= '1';
    I0   <= S;
    Q(0) <= (R0(0) and X(0)) or (R1(0) and X(1)) or (R2(0) and X(2)) or (R3(0) and X(3)) or (R4(0) and X(4)) or (R5(0) and X(5)) or (R6(0) and X(6)) or (R7(0) and X(7));
    Q(1) <= (R0(1) and X(0)) or (R1(1) and X(1)) or (R2(1) and X(2)) or (R3(1) and X(3)) or (R4(1) and X(4)) or (R5(1) and X(5)) or (R6(1) and X(6)) or (R7(1) and X(7));
    Q(2) <= (R0(2) and X(0)) or (R1(2) and X(1)) or (R2(2) and X(2)) or (R3(2) and X(3)) or (R4(2) and X(4)) or (R5(2) and X(5)) or (R6(2) and X(6)) or (R7(2) and X(7));
    Q(3) <= (R0(3) and X(0)) or (R1(3) and X(1)) or (R2(3) and X(2)) or (R3(3) and X(3)) or (R4(3) and X(4)) or (R5(3) and X(5)) or (R6(3) and X(6)) or (R7(3) and X(7));
end Behavioral;
```

#### Nanoprocessor.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity Nanoprocessor is
    generic (
        CLK_DIV_PRELOAD : integer := 49999999);
    port (
        Reset    : in std_logic;
        Clk      : in std_logic;
        Out_LED  : out std_logic_vector (3 downto 0);
        Out_SS   : out std_logic_vector (6 downto 0);
        Anode    : out std_logic_vector (3 downto 0);
        Overflow : out std_logic;
        Zero     : out std_logic
    );
end Nanoprocessor;
architecture Behavioral of Nanoprocessor is
    component PC
        port (
            Clk    : in std_logic;
            RESET  : in std_logic;
            PC_in  : in std_logic_vector (2 downto 0);
            PC_out : out std_logic_vector (2 downto 0));
    end component;
    component Instruction_Decoder is
        port (
            Instruction  : in std_logic_vector (11 downto 0);
            Zero_Flag    : in std_logic;
            Load_Sel     : out std_logic;
            Add_Sub_Sel  : out std_logic;
            Write_Enable : out std_logic;
            Reg_En       : out std_logic_vector (2 downto 0);
            Reg_Sel_A    : out std_logic_vector (2 downto 0);
            Reg_Sel_B    : out std_logic_vector (2 downto 0);
            Imm_Val      : out std_logic_vector (3 downto 0);
            Jump_Addr    : out std_logic_vector (2 downto 0);
            Jump_Flag    : out std_logic
        );
    end component;
    component Adder3bits is
        port (
            A : in std_logic_vector (2 downto 0);
            E : out std_logic_vector (2 downto 0));
    end component;
    component MUX_2_way_3_bit is
        port (
            A : in std_logic_vector (2 downto 0);
            B : in std_logic_vector (2 downto 0);
            S : in std_logic;
            Q : out std_logic_vector (2 downto 0));
    end component;
    component Rom
        port (
            Ins_S   : in std_logic_vector (2 downto 0);
            Ins_Out : out std_logic_vector (11 downto 0));
    end component;
    component Reg_Bank is
        port (
            D        : in std_logic_vector(3 downto 0);
            Clk      : in std_logic;
            Res      : in std_logic;
            Reg_sel  : in std_logic_vector(2 downto 0);
            Write_EN : in std_logic;
            R1       : out std_logic_vector(3 downto 0);
            R2       : out std_logic_vector(3 downto 0);
            R3       : out std_logic_vector(3 downto 0);
            R4       : out std_logic_vector(3 downto 0);
            R5       : out std_logic_vector(3 downto 0);
            R6       : out std_logic_vector(3 downto 0);
            R7       : out std_logic_vector(3 downto 0);
            R0       : out std_logic_vector(3 downto 0));
    end component;
    component MUX_8_way_4_bit is
        port (
            S  : in std_logic_vector (2 downto 0);
            R0 : in std_logic_vector (3 downto 0);
            R1 : in std_logic_vector (3 downto 0);
            R2 : in std_logic_vector (3 downto 0);
            R3 : in std_logic_vector (3 downto 0);
            R4 : in std_logic_vector (3 downto 0);
            R5 : in std_logic_vector (3 downto 0);
            R6 : in std_logic_vector (3 downto 0);
            R7 : in std_logic_vector (3 downto 0);
            Q  : out std_logic_vector (3 downto 0));
    end component;
    component Add_Sub_4bit is
        port (
            A        : in std_logic_vector (3 downto 0);
            B        : in std_logic_vector (3 downto 0);
            Sub      : in std_logic;
            Res      : out std_logic_vector (3 downto 0);
            OverFlow : out std_logic;
            Zero     : out std_logic);
    end component;
    component MUX_2_way_4_bit is
        port (
            A : in std_logic_vector (3 downto 0);
            B : in std_logic_vector (3 downto 0);
            S : in std_logic;
            Q : out std_logic_vector (3 downto 0));
    end component;
    component Clock_Divider is
        generic (
            PRELOAD_VAL : integer := 49999999);
        port (
            clk_in  : in std_logic;
            clk_out : out std_logic);
    end component;
    component LUT_16_7 is
        port (
            address : in std_logic_vector (3 downto 0);
            data    : out std_logic_vector (6 downto 0));
    end component;
    signal Slow_Clk : std_logic;
    signal PC_In        : std_logic_vector (2 downto 0);
    signal PC_out       : std_logic_vector (2 downto 0);
    signal PC_Adder_out : std_logic_vector (2 downto 0);
    signal Instruction  : std_logic_vector (11 downto 0);
    signal R1 : std_logic_vector(3 downto 0);
    signal R2 : std_logic_vector(3 downto 0);
    signal R3 : std_logic_vector(3 downto 0);
    signal R4 : std_logic_vector(3 downto 0);
    signal R5 : std_logic_vector(3 downto 0);
    signal R6 : std_logic_vector(3 downto 0);
    signal R7 : std_logic_vector(3 downto 0);
    signal R0 : std_logic_vector(3 downto 0);
    signal Adder_A : std_logic_vector(3 downto 0);
    signal Adder_B : std_logic_vector(3 downto 0);
    signal ALU_Result : std_logic_vector(3 downto 0);
    signal Zero_Flag    : std_logic;
    signal Load_Sel     : std_logic;
    signal Add_Sub_Sel  : std_logic;
    signal Write_Enable : std_logic;
    signal Reg_En       : std_logic_vector (2 downto 0);
    signal Reg_Sel_A    : std_logic_vector (2 downto 0);
    signal Reg_Sel_B    : std_logic_vector (2 downto 0);
    signal Imm_Val      : std_logic_vector (3 downto 0);
    signal Jump_Addr    : std_logic_vector (2 downto 0);
    signal Jump_Flag    : std_logic;
    signal Mux_In : std_logic_vector (3 downto 0);
begin
    Clock : Clock_Divider
    generic map
    (
        PRELOAD_VAL => CLK_DIV_PRELOAD
    )
    port map
    (
        clk_in  => Clk,
        clk_out => Slow_Clk
    );
    PC_Adder_Comp : Adder3bits
    port map
    (
        A => PC_out,
        E => PC_Adder_out
    );
    Mux_2_3_Comp : MUX_2_way_3_bit
    port map
    (
        A => PC_Adder_Out,
        B => Jump_Addr,
        S => Jump_Flag,
        Q => PC_In
    );
    PC_Comp : PC
    port map
    (
        Clk    => Slow_Clk,
        RESET  => Reset,
        PC_in  => PC_In,
        PC_out => PC_Out);
    Rom_Comp : Rom
    port map
    (
        Ins_S   => PC_Out,
        Ins_Out => Instruction
    );
    Instruction_Decoder_Comp : Instruction_Decoder
    port map
    (
        Instruction  => Instruction,
        Zero_Flag    => Zero_Flag,
        Load_Sel     => Load_Sel,
        Add_Sub_Sel  => Add_Sub_Sel,
        Write_Enable => Write_Enable,
        Reg_En       => Reg_En,
        Reg_Sel_A    => Reg_Sel_A,
        Reg_Sel_B    => Reg_Sel_B,
        Imm_Val      => Imm_Val,
        Jump_Addr    => Jump_Addr,
        Jump_Flag    => Jump_Flag
    );
    Reg_Bank_Comp : Reg_Bank
    port map
    (
        D        => ALU_Result,
        Clk      => Slow_Clk,
        Res      => Reset,
        Reg_sel  => Reg_En,
        Write_EN => Write_Enable,
        R1       => R1,
        R2       => R2,
        R3       => R3,
        R4       => R4,
        R5       => R5,
        R6       => R6,
        R7       => R7,
        R0       => R0
    );
    Mux_8_4_Comp_A : MUX_8_way_4_bit
    port map
    (
        S  => Reg_Sel_A,
        R0 => R0,
        R1 => R1,
        R2 => R2,
        R3 => R3,
        R4 => R4,
        R5 => R5,
        R6 => R6,
        R7 => R7,
        Q  => Adder_A);
    Mux_8_4_Comp_B : MUX_8_way_4_bit
    port map
    (
        S  => Reg_Sel_B,
        R0 => R0,
        R1 => R1,
        R2 => R2,
        R3 => R3,
        R4 => R4,
        R5 => R5,
        R6 => R6,
        R7 => R7,
        Q  => Mux_In);
    Adder_Sub_Comp : Add_Sub_4bit
    port map
    (
        A        => Adder_A,
        B        => Adder_B,
        Sub      => Add_Sub_Sel,
        Res      => ALU_Result,
        OverFlow => Overflow,
        Zero     => Zero_Flag
    );
    Mux_2_4_Comp : MUX_2_way_4_bit
    port map
    (
        A => Mux_In,
        B => Imm_Val,
        S => Load_Sel,
        Q => Adder_B
    );
    LUT_Comp : LUT_16_7
    port map
    (
        address => R7,
        data    => Out_SS
    );
    Anode   <= "1110";
    Zero    <= Zero_Flag;
    Out_LED <= R7;
end Behavioral;
```

#### PC.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity PC is
    port (
        CLK    : in std_logic;
        RESET  : in std_logic;
        PC_in  : in std_logic_vector (2 downto 0);
        PC_out : out std_logic_vector (2 downto 0));
end PC;
architecture Structural of PC is
    component D_FF
        port (
            D   : in std_logic;
            Res : in std_logic;
            Clk : in std_logic;
            EN  : in std_logic;
            Q   : out std_logic
        );
    end component;
begin
    FF0 : D_FF
    port map
    (
        D   => PC_in(0),
        Res => RESET,
        CLK => CLK,
        EN  => '1',
        Q   => PC_out(0)
    );
    FF1 : D_FF
    port map
    (
        D   => PC_in(1),
        Res => RESET,
        CLK => CLK,
        EN  => '1',
        Q   => PC_out(1)
    );
    FF2 : D_FF
    port map
    (
        D   => PC_in(2),
        Res => RESET,
        CLK => CLK,
        EN  => '1',
        Q   => PC_out(2)
    );
end Structural;
```

#### RCA4bit.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity RCA4bit is
    port (
        A        : in std_logic_vector (3 downto 0);
        B        : in std_logic_vector (3 downto 0);
        C_in     : in std_logic;
        SUM      : out std_logic_vector (3 downto 0);
        Zero     : out std_logic;
        OverFlow : out std_logic);
end RCA4bit;
architecture Behavioral of RCA4bit is
    signal C   : std_logic_vector(4 downto 0);
    signal res : std_logic_vector(3 downto 0);
    component FA
        port (
            A     : in std_logic;
            B     : in std_logic;
            C_in  : in std_logic;
            SUM   : out std_logic;
            C_out : out std_logic
        );
    end component;
begin
    C(0) <= C_in;
    FA0 : FA
    port map
    (
        A     => A(0),
        B     => B(0),
        C_in  => C(0),
        SUM   => res(0),
        C_out => C(1)
    );
    FA1 : FA
    port map
    (
        A     => A(1),
        B     => B(1),
        C_in  => C(1),
        SUM   => res(1),
        C_out => C(2)
    );
    FA2 : FA
    port map
    (
        A     => A(2),
        B     => B(2),
        C_in  => C(2),
        SUM   => res(2),
        C_out => C(3)
    );
    FA3 : FA
    port map
    (
        A     => A(3),
        B     => B(3),
        C_in  => C(3),
        SUM   => res(3),
        C_out => C(4)
    );
    SUM      <= res;
    OverFlow <= C(4) xor C(3);
    Zero     <= not(res(0) or res(1) or res(2) or res(3));
end Behavioral;
```

#### Reg_4bit.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity Reg_4bit is
    port (
        D   : in std_logic_vector (3 downto 0);
        EN  : in std_logic;
        Res : in std_logic;
        Clk : in std_logic;
        Q   : out std_logic_vector (3 downto 0));
end Reg_4bit;
architecture Behavioral of Reg_4bit is
    component D_FF
        port (
            D   : in std_logic;
            Res : in std_logic;
            Clk : in std_logic;
            EN  : in std_logic;
            Q   : out std_logic
        );
    end component;
    signal q_internal : std_logic_vector(3 downto 0);
begin
    D_FF_0 : D_FF
    port map
    (
        D   => D(0),
        Res => Res,
        Clk => Clk,
        EN  => EN,
        Q   => q_internal(0));
    D_FF_1 : D_FF
    port map
    (
        D   => D(1),
        Res => Res,
        Clk => Clk,
        EN  => EN,
        Q   => q_internal(1));
    D_FF_2 : D_FF
    port map
    (
        D   => D(2),
        Res => Res,
        Clk => Clk,
        EN  => EN,
        Q   => q_internal(2));
    D_FF_3 : D_FF
    port map
    (
        D   => D(3),
        Res => Res,
        Clk => Clk,
        EN  => EN,
        Q   => q_internal(3));
    Q <= q_internal;
end Behavioral;
```

#### Reg_Bank.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity Reg_Bank is
    port (
        D        : in std_logic_vector(3 downto 0);
        Clk      : in std_logic;
        Res      : in std_logic;
        Reg_sel  : in std_logic_vector(2 downto 0);
        Write_EN : in std_logic;
        R1       : out std_logic_vector(3 downto 0);
        R2       : out std_logic_vector(3 downto 0);
        R3       : out std_logic_vector(3 downto 0);
        R4       : out std_logic_vector(3 downto 0);
        R5       : out std_logic_vector(3 downto 0);
        R6       : out std_logic_vector(3 downto 0);
        R7       : out std_logic_vector(3 downto 0);
        R0       : out std_logic_vector(3 downto 0));
end Reg_Bank;
architecture Behavioral of Reg_Bank is
    component Decoder_3_to_8
        port (
            I  : in std_logic_vector (2 downto 0);
            EN : in std_logic;
            Y  : out std_logic_vector (7 downto 0));
    end component;
    component Reg_4bit
        port (
            D   : in std_logic_vector (3 downto 0);
            EN  : in std_logic;
            Res : in std_logic;
            Clk : in std_logic;
            Q   : out std_logic_vector (3 downto 0));
    end component;
    signal EN_lines : std_logic_vector(7 downto 0);
begin
    Decoder : Decoder_3_to_8
    port map
    (
        I  => Reg_sel,
        EN => Write_EN,
        Y  => EN_lines);
    R0 <= "0000";
    Reg_1 : Reg_4bit
    port map
    (
        D   => D,
        EN  => EN_lines(1),
        Res => Res,
        Clk => Clk,
        Q   => R1);
    Reg_2 : Reg_4bit
    port map
    (
        D   => D,
        EN  => EN_lines(2),
        Res => Res,
        Clk => Clk,
        Q   => R2);
    Reg_3 : Reg_4bit
    port map
    (
        D   => D,
        EN  => EN_lines(3),
        Res => Res,
        Clk => Clk,
        Q   => R3);
    Reg_4 : Reg_4bit
    port map
    (
        D   => D,
        EN  => EN_lines(4),
        Res => Res,
        Clk => Clk,
        Q   => R4);
    Reg_5 : Reg_4bit
    port map
    (
        D   => D,
        EN  => EN_lines(5),
        Res => Res,
        Clk => Clk,
        Q   => R5);
    Reg_6 : Reg_4bit
    port map
    (
        D   => D,
        EN  => EN_lines(6),
        Res => Res,
        Clk => Clk,
        Q   => R6);
    Reg_7 : Reg_4bit
    port map
    (
        D   => D,
        EN  => EN_lines(7),
        Res => Res,
        Clk => Clk,
        Q   => R7);
end Behavioral;
```

#### Rom.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
entity Rom is
    port (
        Ins_S   : in std_logic_vector (2 downto 0);
        Ins_Out : out std_logic_vector (11 downto 0));
end Rom;
architecture Behavioral of Rom is
    type Rom_Type is array (7 downto 0) of std_logic_vector (11 downto 0);
    constant Ins_Rom : Rom_Type := (
    0      => "101110000000",
    1      => "100100000011",
    2      => "100110000001",
    3      => "010110000110",
    4      => "001111110100",
    5      => "000100100110",
    6      => "111100100000",
    7      => "111000000000",
    others => "000000000000"
    );
begin
    Ins_Out <= Ins_Rom(to_integer(unsigned(Ins_S)));
end Behavioral;
```

### Simulation Testbenches

#### Add_Sub_4bit_tb.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Add_Sub_4bit_tb is
end Add_Sub_4bit_tb;
architecture Behavioral of Add_Sub_4bit_tb is
    signal A        : STD_LOGIC_VECTOR (3 downto 0);    
    signal B        : STD_LOGIC_VECTOR (3 downto 0);    
    signal Sub      : STD_LOGIC;                      
    signal Res      : STD_LOGIC_VECTOR (3 downto 0); 
    signal C_out    : STD_LOGIC;                   
    signal OverFlow : STD_LOGIC;                
    signal Zero     : STD_LOGIC;        
    component Add_Sub_4bit
        port(
            A        : in  STD_LOGIC_VECTOR (3 downto 0);    
            B        : in  STD_LOGIC_VECTOR (3 downto 0);    
            Sub      : in  STD_LOGIC;                      
            Res      : out STD_LOGIC_VECTOR (3 downto 0); 
            C_out    : out STD_LOGIC;                   
            OverFlow : out STD_LOGIC;                
            Zero     : out STD_LOGIC
            );                   
    end component;           
begin
    UUT : Add_Sub_4bit
        port map(
             A        =>  A        ,
             B        =>  B        ,
             Sub      =>  Sub      ,
             Res      =>  Res      ,
             C_out    =>  C_out    ,
             OverFlow =>  OverFlow ,
             Zero     =>  Zero
        );
     process 
     begin
     A   <= "0000" ;
     B   <= "0011" ;
     Sub <= '0'    ;
     wait for 20 ns;
     A   <= "0111" ;
     B   <= "0101" ;
     Sub <= '0'    ;   
     wait for 20 ns;
     A   <= "0000" ;
     B   <= "0011" ;
     Sub <= '1'    ;
     wait for 20 ns;
     A   <= "0111" ;
     B   <= "0101" ;
     Sub <= '0'    ;
     wait for 20 ns;
     A   <= "0000" ;
     B   <= "0000" ;
     Sub <= '0'    ;
     wait          ;
    end process;
end Behavioral;
```

#### Adder3bits_tb.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Adder3bits_tb is
end Adder3bits_tb;
architecture Behavioral of Adder3bits_tb is
    signal A : STD_LOGIC_VECTOR (2 downto 0); 
    signal E : STD_LOGIC_VECTOR (2 downto 0);
    component Adder3bits 
        port(
            A : in std_logic_vector(2 downto 0);
            E : out std_logic_vector(2 downto 0)
        );
    end component;
begin
    UUT : Adder3bits
    port map(
        A => A,
        E => E
    );
process 
    begin
    A <= "000";
    wait for 20 ns;
    A <= "001";
    wait for 20 ns;
    A <= "011";
    wait for 20 ns;
    A <= "111";
    wait;
    end process;
end Behavioral;
```

#### D_FF_tb.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity D_FF_tb is
end D_FF_tb;
architecture Behavioral of D_FF_tb is
    signal D     : std_logic := '0';
    signal Res   : std_logic := '0';
    signal Clk   : std_logic := '0';
    signal EN    : std_logic := '0';
    signal Q     : std_logic;
    component D_FF
        port (
            D     : in std_logic;
            Res   : in std_logic;
            Clk   : in std_logic;
            EN    : in std_logic;
            Q     : out std_logic);
    end component;
begin
    uut : D_FF
        port map (
            D   => D,
            Res => Res,
            Clk => Clk,
            EN  => EN,
            Q   => Q);
    clk_process : process
    begin
        while true loop
            Clk <= '0';
            wait for 5 ns;
            Clk <= '1';
            wait for 5 ns;
        end loop;
    end process;
    stim_proc : process
    begin
        Res <= '1';
        EN  <= '1';
        D   <= '1';
        wait for 2 ns;
        assert Q = '0'
            report "D_FF reset did not clear the register"
            severity failure;
        Res <= '0';
        wait until rising_edge(Clk);
        wait for 1 ns;
        assert Q = '1'
            report "D_FF did not capture D on an enabled edge"
            severity failure;
        D  <= '0';
        EN <= '0';
        wait until rising_edge(Clk);
        wait for 1 ns;
        assert Q = '1'
            report "D_FF changed state while EN was low"
            severity failure;
        Res <= '1';
        wait for 1 ns;
        assert Q = '0'
            report "D_FF asynchronous reset failed"
            severity failure;
        wait;
    end process;
end Behavioral;
```

#### PC_tb.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity PC_tb is
end PC_tb;
architecture Behavioral of PC_tb is
    signal CLK : std_logic := '0';
    signal RESET : std_logic := '0';
    signal PC_in : std_logic_vector(2 downto 0) := "000";
    signal PC_out : std_logic_vector(2 downto 0);
    component PC
        port(
            CLK : in std_logic;
            RESET : in std_logic;
            PC_in : in std_logic_vector(2 downto 0);
            PC_out : out std_logic_vector(2 downto 0)
        );
    end component;
begin
    UUT: PC
    port map (
        CLK    => CLK,
        RESET  => RESET,
        PC_in  => PC_in,
        PC_out => PC_out
    );
CLK <= not CLK after 10 ns;
process
begin
    RESET <= '1';
    wait for 20 ns;
    RESET <= '0';
    PC_in <= "001";
    wait for 20 ns;
    PC_in <= "010";
    wait for 20 ns;
    PC_in <= "011";
    wait for 20 ns;
    PC_in <= "100";
    wait for 40 ns;
    RESET <= '1';
    wait;
end process;
end Behavioral;
```

#### RCStb.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity RCStb is
end RCStb;
architecture Behavioral of RCStb is
signal A : std_logic_vector(3 downto 0) := "0000";
signal B : std_logic_vector(3 downto 0) := "0000";
signal C_in : std_logic := '0';
signal SUM : std_logic_vector(3 downto 0);
signal C_out : std_logic;
signal Zero : std_logic;
signal OverFlow : std_logic;
component RCA4bit
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           C_in : in STD_LOGIC;
           SUM : out STD_LOGIC_VECTOR (3 downto 0);
           C_out : out STD_LOGIC;
           Zero : out STD_LOGIC;
           OverFlow : out STD_LOGIC);
end component;
begin
    UUT : RCA4bit
    port map(
       A => A,
       B => B,
       C_in => C_in,
       SUM => SUM,
       C_out => C_out,
       Zero => Zero,
       OverFlow => OverFlow
    );
    process 
    begin
        A <= "0000";
        B <= "0000";
        wait for 20 ns;
        A <= "1111";
        B <= "1111";
        wait for 20 ns;
        A <= "0111";
        B <= "0111";
        wait for 20 ns;
        A <= "0110";
        B <= "0011";
        wait for 20 ns;
        A <= "1010";
        B <= "0111";
        wait for 20 ns;B <= "0011";
        wait;
    end process;
end Behavioral;
```

#### TB_Decoder_2_to_4.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity TB_Decoder_2_to_4 is
end TB_Decoder_2_to_4;
architecture Behavioral of TB_Decoder_2_to_4 is
    signal I  : std_logic_vector(1 downto 0) := (others => '0');
    signal EN : std_logic := '0';
    signal Y  : std_logic_vector(3 downto 0);
    constant ZERO4 : std_logic_vector(3 downto 0) := (others => '0');
    component Decoder_2_to_4
        port (
            I  : in std_logic_vector(1 downto 0);
            EN : in std_logic;
            Y  : out std_logic_vector(3 downto 0));
    end component;
begin
    uut : Decoder_2_to_4
        port map (
            I  => I,
            EN => EN,
            Y  => Y);
    stim_proc : process
    begin
        EN <= '1';
        I <= "00"; wait for 1 ns; assert Y = "0001" severity failure;
        I <= "01"; wait for 1 ns; assert Y = "0010" severity failure;
        I <= "10"; wait for 1 ns; assert Y = "0100" severity failure;
        I <= "11"; wait for 1 ns; assert Y = "1000" severity failure;
        EN <= '0';
        wait for 1 ns;
        assert Y = ZERO4
            report "Decoder_2_to_4 should output all zeros when disabled"
            severity failure;
        wait;
    end process;
end Behavioral;
```

#### TB_Decoder_3_to_8.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity TB_Decoder_3_to_8 is
end TB_Decoder_3_to_8;
architecture Behavioral of TB_Decoder_3_to_8 is
    signal I  : std_logic_vector(2 downto 0) := (others => '0');
    signal EN : std_logic := '0';
    signal Y  : std_logic_vector(7 downto 0);
    constant ZERO8 : std_logic_vector(7 downto 0) := (others => '0');
    component Decoder_3_to_8
        port (
            I  : in std_logic_vector(2 downto 0);
            EN : in std_logic;
            Y  : out std_logic_vector(7 downto 0));
    end component;
begin
    uut : Decoder_3_to_8
        port map (
            I  => I,
            EN => EN,
            Y  => Y);
    stim_proc : process
        variable expected : std_logic_vector(7 downto 0);
    begin
        EN <= '1';
        for idx in 0 to 7 loop
            expected := ZERO8;
            expected(idx) := '1';
            I <= std_logic_vector(to_unsigned(idx, 3));
            wait for 1 ns;
            assert Y = expected
                report "Decoder_3_to_8 failed for input " & integer'image(idx)
                severity failure;
        end loop;
        EN <= '0';
        I <= "101";
        wait for 1 ns;
        assert Y = ZERO8
            report "Decoder_3_to_8 should output all zeros when disabled"
            severity failure;
        wait;
    end process;
end Behavioral;
```

#### TB_FA.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity TB_FA is
end TB_FA;
architecture Behavioral of TB_FA is
    signal A     : std_logic := '0';
    signal B     : std_logic := '0';
    signal C_in  : std_logic := '0';
    signal SUM   : std_logic;
    signal C_out : std_logic;
    component FA
        port (
            A     : in std_logic;
            B     : in std_logic;
            C_in  : in std_logic;
            SUM   : out std_logic;
            C_out : out std_logic);
    end component;
begin
    uut : FA
        port map (
            A     => A,
            B     => B,
            C_in  => C_in,
            SUM   => SUM,
            C_out => C_out);
    stim_proc : process
    begin
        A <= '0'; B <= '0'; C_in <= '0'; wait for 1 ns;
        assert SUM = '0' and C_out = '0' severity failure;
        A <= '1'; B <= '1'; C_in <= '0'; wait for 1 ns;
        assert SUM = '0' and C_out = '1' severity failure;
        A <= '1'; B <= '0'; C_in <= '1'; wait for 1 ns;
        assert SUM = '0' and C_out = '1' severity failure;
        A <= '1'; B <= '1'; C_in <= '1'; wait for 1 ns;
        assert SUM = '1' and C_out = '1' severity failure;
        wait;
    end process;
end Behavioral;
```

#### TB_LUT_16_7.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity TB_LUT_16_7 is
end TB_LUT_16_7;
architecture Behavioral of TB_LUT_16_7 is
    signal address : std_logic_vector(3 downto 0) := (others => '0');
    signal data    : std_logic_vector(6 downto 0);
    component LUT_16_7
        port (
            address : in std_logic_vector(3 downto 0);
            data    : out std_logic_vector(6 downto 0));
    end component;
begin
    uut : LUT_16_7
        port map (
            address => address,
            data    => data);
    stim_proc : process
    begin
        address <= x"0"; wait for 1 ns; assert data = "1000000" severity failure;
        address <= x"A"; wait for 1 ns; assert data = "0001000" severity failure;
        address <= x"F"; wait for 1 ns; assert data = "0001110" severity failure;
        wait;
    end process;
end Behavioral;
```

#### TB_MUX_2_way_3_bit.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity TB_MUX_2_way_3_bit is
end TB_MUX_2_way_3_bit;
architecture Behavioral of TB_MUX_2_way_3_bit is
    component MUX_2_way_3_bit is
        port (
            A : in std_logic_vector;
            B : in std_logic_vector;
            s : in std_logic;
            Q : out std_logic_vector);
    end component;
    signal A, B, Q : std_logic_vector(2 downto 0);
    signal C       : std_logic;
begin
    uut : MUX_2_way_3_bit PORT
    map(
    A => A,
    B => B,
    s => C,
    Q => Q);
    process
    begin
        C <= '0';
        A <= "000";
        B <= "000";
        wait for 200ns;
        A <= "010";
        B <= "011";
        wait for 200ns;
        C <= '1';
        wait for 200ns;
        A <= "100";
        B <= "101";
        wait for 200ns;
        C <= '0';
        wait;
    end process;
end Behavioral;
```

#### TB_MUX_2_way_4_bit.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity TB_MUX_2_way_4_bit is
end TB_MUX_2_way_4_bit;
architecture Behavioral of TB_MUX_2_way_4_bit is
    component MUX_2_way_4_bit is
        port (
            A : in std_logic_vector;
            B : in std_logic_vector;
            S : in std_logic;
            Q : out std_logic_vector);
    end component;
    signal A, B, Q : std_logic_vector(3 downto 0);
    signal C       : std_logic;
begin
    uut : MUX_2_way_4_bit PORT
    map(
    A => A,
    B => B,
    S => C,
    Q => Q);
    process
    begin
        A <= "0000";
        B <= "0000";
        C <= '0';
        wait for 100ns; -- Q should be A = 0
        C <= '1';
        wait for 100ns; -- Q should be B = 0
        A <= "0010";
        B <= "0011";
        C <= '0';
        wait for 100ns; -- Q should be A = 2
        C <= '1';
        wait for 100ns; -- Q should be B = 3
        A <= "0100";
        B <= "0101";
        C <= '0';
        wait for 100ns; -- Q should be A = 4
        C <= '1';
        wait for 100ns; -- Q should be B = 5
        A <= "0110";
        B <= "0111";
        C <= '0';
        wait for 100ns; -- Q should be A = 6
        C <= '1';
        wait for 100ns; -- Q should be B = 7
        A <= "1000";
        B <= "1001";
        C <= '0';
        wait for 100ns; -- Q should be A = 8
        C <= '1';
        wait for 100ns; -- Q should be B = 9
        wait;
    end process;
end Behavioral;
```

#### TB_MUX_8_way_4_bit.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
entity TB_MUX_8_way_4_bit is
end TB_MUX_8_way_4_bit;
architecture Behavioral of TB_MUX_8_way_4_bit is
    component MUX_8_way_4_bit is
        port (
            S  : in std_logic_vector;
            R0 : in std_logic_vector;
            R1 : in std_logic_vector;
            R2 : in std_logic_vector;
            R3 : in std_logic_vector;
            R4 : in std_logic_vector;
            R5 : in std_logic_vector;
            R6 : in std_logic_vector;
            R7 : in std_logic_vector;
            Q  : out std_logic_vector);
    end component;
    signal S                                 : std_logic_vector(2 downto 0);
    signal Q, R0, R1, R2, R3, R4, R5, R6, R7 : std_logic_vector (3 downto 0);
begin
    uut : MUX_8_way_4_bit PORT
    map(
    S  => S,
    R0 => R0,
    R1 => R1,
    R2 => R2,
    R3 => R3,
    R4 => R4,
    R5 => R5,
    R6 => R6,
    R7 => R7,
    Q  => Q);
    process
    begin
        R0 <= "0000";
        R1 <= "0001";
        R2 <= "0010";
        R3 <= "0011";
        R4 <= "0100";
        R5 <= "0101";
        R6 <= "0110";
        R7 <= "0111";
        for i in 0 to 7 loop
            S <= std_logic_vector(to_unsigned(i, 3));
            wait for 100ns;
        end loop;
        wait;
    end process;
end Behavioral;
```

#### TB_Reg_4bit.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity TB_Reg_4bit is
end TB_Reg_4bit;
architecture Behavioral of TB_Reg_4bit is
    component Reg_4bit
        port (
            D   : in std_logic_vector (3 downto 0);
            EN  : in std_logic;
            Res : in std_logic;
            Clk : in std_logic;
            Q   : out std_logic_vector (3 downto 0));
    end component;
    signal D   : std_logic_vector(3 downto 0) := "0000";
    signal EN  : std_logic                    := '0';
    signal Res : std_logic                    := '0';
    signal Clk : std_logic                    := '0';
    signal Q   : std_logic_vector(3 downto 0);
begin
    UUT : Reg_4bit
    port map
    (
        D   => D,
        EN  => EN,
        Res => Res,
        Clk => Clk,
        Q   => Q);
    process
    begin
        while true loop
            Clk <= '0';
            wait for 50ns;
            Clk <= '1';
            wait for 50ns;
        end loop;
    end process;
    process
    begin
        Res <= '1';
        wait for 100 ns;
        Res <= '0';
        EN <= '1';
        D  <= "1111";
        wait for 100 ns;
        D <= "1001";
        wait for 100 ns;
        D <= "1100";
        wait for 100 ns;
        EN <= '0';
        D  <= "1010";
        wait for 100 ns;
        EN <= '1';
        D  <= "0110";
        wait for 100 ns;
        Res <= '1';
        wait for 100 ns;
        Res <= '0';
        wait;
    end process;
end Behavioral;
```

#### TB_Reg_Bank.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity TB_Reg_Bank is
end TB_Reg_Bank;
architecture Behavioral of TB_Reg_Bank is
    component Reg_Bank
        port (
            D        : in std_logic_vector(3 downto 0);
            Clk      : in std_logic;
            Res      : in std_logic;
            Reg_sel  : in std_logic_vector(2 downto 0);
            Write_EN : in std_logic;
            R1       : out std_logic_vector(3 downto 0);
            R2       : out std_logic_vector(3 downto 0);
            R3       : out std_logic_vector(3 downto 0);
            R4       : out std_logic_vector(3 downto 0);
            R5       : out std_logic_vector(3 downto 0);
            R6       : out std_logic_vector(3 downto 0);
            R7       : out std_logic_vector(3 downto 0);
            R0       : out std_logic_vector(3 downto 0));
    end component;
    signal D                              : std_logic_vector(3 downto 0) := "0000";
    signal Clk                            : std_logic                    := '0';
    signal Res                            : std_logic                    := '0';
    signal Reg_sel                        : std_logic_vector(2 downto 0) := "000";
    signal Write_EN                       : std_logic                    := '0';
    signal R1, R2, R3, R4, R5, R6, R7, R0 : std_logic_vector(3 downto 0);
begin
    UUT : Reg_Bank
    port map
    (
        D        => D,
        Clk      => Clk,
        Res      => Res,
        Reg_sel  => Reg_sel,
        Write_EN => Write_EN,
        R0       => R0,
        R1       => R1,
        R2       => R2,
        R3       => R3,
        R4       => R4,
        R5       => R5,
        R6       => R6,
        R7       => R7);
    process
    begin
        while true loop
            Clk <= '0';
            wait for 20 ns;
            Clk <= '1';
            wait for 20 ns;
        end loop;
    end process;
    process
    begin
        Res <= '1';
        wait for 50 ns;
        Res <= '0';
        Write_EN <= '1';
        D       <= "0001";
        Reg_sel <= "001";
        wait for 40 ns;
        D       <= "0101";
        Reg_sel <= "010";
        wait for 40 ns;
        D       <= "1100";
        Reg_sel <= "111";
        wait for 40 ns;
        D       <= "1111";
        Reg_sel <= "000";
        wait for 40 ns;
        Write_EN <= '0';
        Reg_sel <= "001";
        wait for 40 ns;
        Reg_sel <= "010";
        wait for 40 ns;
        Reg_sel <= "111";
        wait for 40 ns;
        Reg_sel <= "000";
        wait for 40 ns;
        Res <= '1';
        wait for 40 ns;
        Res <= '0';
        wait;
    end process;
end Behavioral;
```

#### TB_Rom.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity TB_Rom is
end TB_Rom;
architecture Behavioral of TB_Rom is
    signal Ins_S   : std_logic_vector(2 downto 0) := (others => '0');
    signal Ins_Out : std_logic_vector(11 downto 0);
    type rom_type is array (0 to 7) of std_logic_vector(11 downto 0);
    constant expected : rom_type := (
        0      => "101110000000",
    1      => "100100000011",
    2      => "100110000001",
    3      => "010110000110",
    4      => "001111110100",
    5      => "000100100110",
    6      => "111100100000",
    7      => "111000000000");
    component Rom
        port (
            Ins_S   : in std_logic_vector(2 downto 0);
            Ins_Out : out std_logic_vector(11 downto 0));
    end component;
begin
    uut : Rom
        port map (
            Ins_S   => Ins_S,
            Ins_Out => Ins_Out);
    stim_proc : process
    begin
        for idx in 0 to 7 loop
            Ins_S <= std_logic_vector(to_unsigned(idx, 3));
            wait for 1 ns;
            assert Ins_Out = expected(idx)
                report "ROM contents mismatch at address " & integer'image(idx)
                severity failure;
        end loop;
        wait;
    end process;
end Behavioral;
```

#### tb_Clock_Divider.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity tb_Clock_Divider is
end tb_Clock_Divider;
architecture Behavioral of tb_Clock_Divider is
    signal clk_in  : std_logic := '0';
    signal clk_out : std_logic;
    component Clock_Divider
        generic (
            PRELOAD_VAL : integer := 49999999);
        port (
            clk_in  : in std_logic;
            clk_out : out std_logic);
    end component;
begin
    uut : Clock_Divider
        generic map (
            PRELOAD_VAL => 3)
        port map (
            clk_in  => clk_in,
            clk_out => clk_out);
    clk_process : process
    begin
        while true loop
            clk_in <= '0';
            wait for 5 ns;
            clk_in <= '1';
            wait for 5 ns;
        end loop;
    end process;
    stim_proc : process
    begin
        wait until rising_edge(clk_in);
        wait until rising_edge(clk_in);
        wait until rising_edge(clk_in);
        wait until rising_edge(clk_in);
        wait for 1 ns;
        assert clk_out = '1'
            report "Clock divider did not toggle after 4 input edges"
            severity failure;
        wait until rising_edge(clk_in);
        wait until rising_edge(clk_in);
        wait until rising_edge(clk_in);
        wait until rising_edge(clk_in);
        wait for 1 ns;
        assert clk_out = '0'
            report "Clock divider did not toggle back after the next 4 input edges"
            severity failure;
        wait;
    end process;
end Behavioral;
```

#### tb_Instruction_Decoder.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity tb_Instruction_Decoder is
end tb_Instruction_Decoder;
architecture Behavioral of tb_Instruction_Decoder is
component Instruction_Decoder
    Port ( 
        Instruction    : in  STD_LOGIC_VECTOR (11 downto 0); 
        Zero_Flag      : in  STD_LOGIC;                      
        Load_Sel       : out STD_LOGIC;                      
        Add_Sub_Sel    : out STD_LOGIC;                      
        Write_Enable   : out STD_LOGIC;                 
        Reg_En         : out STD_LOGIC_VECTOR (2 downto 0);  
        Reg_Sel_A      : out STD_LOGIC_VECTOR (2 downto 0);  
        Reg_Sel_B      : out STD_LOGIC_VECTOR (2 downto 0);  
        Imm_Val        : out STD_LOGIC_VECTOR (3 downto 0);  
        Jump_Addr      : out STD_LOGIC_VECTOR (2 downto 0);  
        Jump_Flag      : out STD_LOGIC                       
    );
    end component;
    signal Instruction : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
    signal Zero_Flag   : STD_LOGIC := '0';
    signal Load_Sel     : STD_LOGIC;
    signal Add_Sub_Sel  : STD_LOGIC;
    signal Write_Enable : STD_LOGIC;
    signal Reg_En       : STD_LOGIC_VECTOR(2 downto 0);
    signal Reg_Sel_A    : STD_LOGIC_VECTOR(2 downto 0);
    signal Reg_Sel_B    : STD_LOGIC_VECTOR(2 downto 0);
    signal Imm_Val      : STD_LOGIC_VECTOR(3 downto 0);
    signal Jump_Addr    : STD_LOGIC_VECTOR(2 downto 0);
    signal Jump_Flag    : STD_LOGIC;
begin
uut: Instruction_Decoder PORT MAP (
        Instruction  => Instruction,
        Zero_Flag    => Zero_Flag,
        Load_Sel     => Load_Sel,
        Add_Sub_Sel  => Add_Sub_Sel,
        Write_Enable => Write_Enable,
        Reg_En       => Reg_En,
        Reg_Sel_A    => Reg_Sel_A,
        Reg_Sel_B    => Reg_Sel_B,
        Imm_Val      => Imm_Val,
        Jump_Addr    => Jump_Addr,
        Jump_Flag    => Jump_Flag
    );
    stim_proc: process
    begin
        Instruction <= "000010100110";
        Zero_Flag   <= '0';
        wait for 10 ns;
        Instruction <= "011001011101";
        Zero_Flag   <= '0';
        wait for 10 ns;
        Instruction <= "101110011111";
        Zero_Flag   <= '0';
        wait for 10 ns;
        Instruction <= "110110100101";
        Zero_Flag   <= '0';
        wait for 10 ns;
        Instruction <= "110110100101";
        Zero_Flag   <= '1';
        wait for 10 ns;
        wait;
    end process;
end Behavioral;
```

#### tb_Nanoprocessor.vhd

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity tb_Nanoprocessor is
end tb_Nanoprocessor;
architecture Behavioral of tb_Nanoprocessor is
component Nanoprocessor
    generic (
        CLK_DIV_PRELOAD : integer := 49999999);
    port (
        Reset   : in std_logic;
        Clk     : in std_logic;
        Out_LED : out std_logic_vector (3 downto 0);
        Out_SS  : out std_logic_vector (6 downto 0);
        Overflow: out std_logic;
        Zero    : out std_logic;
        Anode   : out std_logic_vector (3 downto 0)
    );
    end component;
    signal Reset : std_logic := '0';
    signal Clk   : std_logic := '0';
    signal Out_LED  : std_logic_vector (3 downto 0);
    signal Out_SS   : std_logic_vector (6 downto 0);
    signal Overflow : std_logic;
    signal Zero     : std_logic;
    signal Anode    : std_logic_vector (3 downto 0);
    constant Clk_period : time := 10 ns;
begin
    uut: Nanoprocessor
    generic map (
        CLK_DIV_PRELOAD => 1)
    port map (
        Reset    => Reset,
        Clk      => Clk,
        Out_LED  => Out_LED,
        Out_SS   => Out_SS,
        Overflow => Overflow,
        Zero     => Zero,
        Anode    => Anode
    );
    Clk_process : process
begin
    Clk <= '0';
    wait for Clk_period/2;
    Clk <= '1';
    wait for Clk_period/2;
end process;
stim_proc : process
begin
    Reset <= '1';
    wait for 100 ns;
        Reset <= '0';
        wait for 2000 ns; 
        wait;
    end process;
end Behavioral;
```


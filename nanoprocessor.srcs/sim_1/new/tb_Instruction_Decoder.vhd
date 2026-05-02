----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2026 01:50:38 AM
-- Design Name: 
-- Module Name: tb_Instruction_Decoder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_Instruction_Decoder is
--  Port ( );
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
        -- TEST 1: ADD Instruction (Opcode: 00)
        -- Format: 0 0 A A A B B B C C C X
        -- Let's test ADD R1, R2, R3 (R1=001, R2=010, R3=011, X=0)
        -- Binary string: "00" & "001" & "010" & "011" & "0"
        -- Expected: Load_Sel=0, Add_Sub_Sel=0, Write_Enable=1
        Instruction <= "000010100110";
        Zero_Flag   <= '0';
        wait for 10 ns;

        -- TEST 2: SUB Instruction (Opcode: 01)
        -- Format: 0 1 A A A B B B C C C X
        -- Let's test SUB R4, R5, R6 (R4=100, R5=101, R6=110, X=1)
        -- Binary string: "01" & "100" & "101" & "110" & "1"
        -- Expected: Load_Sel=0, Add_Sub_Sel=1, Write_Enable=1
        Instruction <= "011001011101";
        Zero_Flag   <= '0';
        wait for 10 ns;

        -- TEST 3: ADDI Instruction (Opcode: 10)
        -- Format: 1 0 A A A B B B I I I I
        -- Let's test ADDI R7, R1, 15 (R7=111, R1=001, I=1111)
        -- Binary string: "10" & "111" & "001" & "1111"
        -- Expected: Load_Sel=1, Add_Sub_Sel=0, Write_Enable=1
        Instruction <= "101110011111";
        Zero_Flag   <= '0';
        wait for 10 ns;

        -- TEST 4: BEQ Instruction (No Branch) (Opcode: 11)
        -- Format: 1 1 D D D A A A I I I I
        -- Let's test BEQ R2, 5, Addr(3) (D=011, A=010, I=0101)
        -- Zero_Flag = '0' (Branch condition NOT met)
        -- Expected: Jump_Flag=0, Write_Enable=0
        Instruction <= "110110100101";
        Zero_Flag   <= '0';
        wait for 10 ns;

        -- TEST 5: BEQ Instruction (Branch Taken) (Opcode: 11)
        -- Keep the exact same instruction but set the Zero_Flag high.
        -- Zero_Flag = '1' (Branch condition IS met)
        -- Expected: Jump_Flag=1, Write_Enable=0
        Instruction <= "110110100101";
        Zero_Flag   <= '1';
        wait for 10 ns;

        -- Simulation Complete
        wait;
    end process;

end Behavioral;

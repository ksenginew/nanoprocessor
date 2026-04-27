----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2026 09:09:24 PM
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
    UUT: Instruction_Decoder port map (
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
        wait for 50 ns;

        -- TEST CASE 1: ADD R1, R2, R3 (rd=1, rs1=2, rs2=3)
        -- 000 [001] [010] [011]
        Instruction <= "000" & "001" & "010" & "011";
        Zero_Flag   <= '0';
        wait for 50 ns;
        
        assert (Write_Enable = '1' and Jump_Flag = '0' and Load_Sel = '0' and Add_Sub_Sel = '0')
        report "TC1 Failed: ADD control logic incorrect" severity error;
        assert (Reg_En = "001" and Reg_Sel_A = "010" and Reg_Sel_B = "011")
        report "TC1 Failed: ADD data routing incorrect" severity error;


        -- TEST CASE 2: MOVI R4, 13 (rd=4, imm=1101)
        -- 100 [100] [00] [1101]
        Instruction <= "100" & "100" & "00" & "1101";
        Zero_Flag   <= '0';
        wait for 50 ns;
        
        assert (Write_Enable = '1' and Jump_Flag = '0' and Load_Sel = '1' and Add_Sub_Sel = '0')
        report "TC2 Failed: MOVI control logic incorrect" severity error;
        assert (Reg_En = "100" and Imm_Val = "1101")
        report "TC2 Failed: MOVI immediate routing incorrect" severity error;


        -- TEST CASE 3: NEG R5 (Under the hood: SUB R5, R0, R5)
        -- 010 [101] [000] [101]
        Instruction <= "010" & "101" & "000" & "101";
        Zero_Flag   <= '0';
        wait for 50 ns;
        
        assert (Write_Enable = '1' and Jump_Flag = '0' and Load_Sel = '0' and Add_Sub_Sel = '1')
        report "TC3 Failed: NEG/SUB control logic incorrect" severity error;
        assert (Reg_En = "101" and Reg_Sel_A = "000" and Reg_Sel_B = "101")
        report "TC3 Failed: NEG/SUB data routing incorrect" severity error;


        -- TEST CASE 4: JZR R6, 7 (Under the hood: JZR 7, R6) -> NO JUMP
        -- 001 [111] [110] [000]
        -- Condition: ALU Zero_Flag is '0' (R6 is not zero)
        -- =========================================================
        Instruction <= "001" & "111" & "110" & "000";
        Zero_Flag   <= '0'; -- Simulating that R6 + 0 did NOT result in zero
        wait for 50 ns;
        
        -- Write Enable MUST be 0 to protect registers during a check
        assert (Write_Enable = '0' and Jump_Flag = '0' and Load_Sel = '0' and Add_Sub_Sel = '0')
        report "TC4 Failed: JZR (No Jump) control logic incorrect" severity error;
        assert (Jump_Addr = "111" and Reg_Sel_A = "110" and Reg_Sel_B = "000")
        report "TC4 Failed: JZR routing incorrect" severity error;


        -- TEST CASE 5: JZR R6, 7 -> SUCCESSFUL JUMP
        -- 001 [111] [110] [000]
        -- Condition: ALU Zero_Flag is '1' (R6 is zero)
        Instruction <= "001" & "111" & "110" & "000";
        Zero_Flag   <= '1'; -- Simulating that R6 + 0 DID result in zero
        wait for 50 ns;
        
        assert (Write_Enable = '0' and Jump_Flag = '1')
        report "TC5 Failed: JZR (Jump) logic failed to trigger Jump_Flag or protect registers" severity error;


        -- End of simulation
        report "Simulation completed successfully.";
        wait; -- Stop execution
        
    end process;
end Behavioral;

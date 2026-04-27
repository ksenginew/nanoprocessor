----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 07:08:55 PM
-- Design Name: 
-- Module Name: Instruction_Decoder - Behavioral
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

entity Instruction_Decoder is
    Port ( 
        -- Inputs
        Instruction    : in  STD_LOGIC_VECTOR (11 downto 0); -- 12-bit instruction
        Zero_Flag      : in  STD_LOGIC;                      -- Zero flag from the 4-bit Add/Sub unit
        
        -- Outputs to Datapath components
        Load_Sel       : out STD_LOGIC;                      -- Selects Immediate (1) or ALU Output (0)
        Add_Sub_Sel    : out STD_LOGIC;                      -- Selects Subtract (1) or Add (0)
        Write_Enable   : out STD_LOGIC;                      -- Enables writing to the Register Bank
        Reg_En         : out STD_LOGIC_VECTOR (2 downto 0);  -- Destination Register address
        Reg_Sel_A      : out STD_LOGIC_VECTOR (2 downto 0);  -- Source Register 1 address (Mux A)
        Reg_Sel_B      : out STD_LOGIC_VECTOR (2 downto 0);  -- Source Register 2 address (Mux B)
        Imm_Val        : out STD_LOGIC_VECTOR (3 downto 0);  -- 4-bit Immediate value
        Jump_Addr      : out STD_LOGIC_VECTOR (2 downto 0);  -- Address to jump to
        Jump_Flag      : out STD_LOGIC                       -- Triggers the PC to jump
    );
end Instruction_Decoder;

architecture Behavioral of Instruction_Decoder is
begin
    -- Control Bits
    Load_Sel    <= Instruction(11); 
    Add_Sub_Sel <= Instruction(10); 
    
    -- Data and Address Bits
    Reg_En      <= Instruction(8 downto 6); -- rd
    Jump_Addr   <= Instruction(8 downto 6); -- addr
    Reg_Sel_A   <= Instruction(5 downto 3); -- rs1
    Reg_Sel_B   <= Instruction(2 downto 0); -- rs2
    Imm_Val     <= Instruction(3 downto 0); -- imm

    -- JUMP FLAG
    Jump_Flag <= Instruction(9) and Zero_Flag;

    -- WRITE ENABLE 
    Write_Enable <= not Instruction(9);
end Behavioral;

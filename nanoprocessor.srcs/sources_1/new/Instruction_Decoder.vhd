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
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Instruction_Decoder is
    port (
        -- Inputs
        Instruction : in std_logic_vector (11 downto 0); -- 12-bit instruction
        Zero_Flag   : in std_logic; -- Zero flag from the 4-bit Add/Sub unit

        -- Outputs to Datapath components
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
    -- Control Bits
    Load_Sel    <= Instruction(11);
    Add_Sub_Sel <= Instruction(10);

    -- Data and Address Bits
    Reg_En    <= Instruction(9 downto 7); -- rd
    Jump_Addr <= Instruction(9 downto 7); -- addr
    Reg_Sel_A <= Instruction(6 downto 4); -- rs1
    Reg_Sel_B <= Instruction(3 downto 1); -- rs2
    Imm_Val   <= Instruction(3 downto 0); -- imm

    Temp_Jump <= Instruction(11) and Instruction(10);

    -- JUMP FLAG
    Jump_Flag <= Temp_Jump and Zero_Flag;

    -- WRITE ENABLE 
    Write_Enable <= not Temp_Jump;
end Behavioral;

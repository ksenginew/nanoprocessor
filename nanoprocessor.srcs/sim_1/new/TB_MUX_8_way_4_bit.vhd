----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 12:23:32 PM
-- Design Name: 
-- Module Name: TB_MUX_8_way_4_bit - Behavioral
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
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB_MUX_8_way_4_bit is
    --  Port ( );
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

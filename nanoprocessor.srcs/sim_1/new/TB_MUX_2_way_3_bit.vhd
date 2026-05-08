----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 12:25:39 PM
-- Design Name: 
-- Module Name: TB_MUX_2_way_3_bit - Behavioral
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

entity TB_MUX_2_way_3_bit is
    --  Port ( );
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

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 12:26:52 PM
-- Design Name: 
-- Module Name: TB_MUX_2_way_4_bit - Behavioral
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

entity TB_MUX_2_way_4_bit is
    --  Port ( );
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
    uut : MUX_2_way_4_bitPORT
    map(
    A => A,
    B => B,
    S => C,
    Q => Q);
    process
    begin
        -- Input pair 1: A=0, B=0
        A <= "0000";
        B <= "0000";
        C <= '0';
        wait for 100ns; -- Q should be A = 0
        C <= '1';
        wait for 100ns; -- Q should be B = 0

        -- Input pair 2: A=2, B=3
        A <= "0010";
        B <= "0011";
        C <= '0';
        wait for 100ns; -- Q should be A = 2
        C <= '1';
        wait for 100ns; -- Q should be B = 3

        -- Input pair 3: A=4, B=5
        A <= "0100";
        B <= "0101";
        C <= '0';
        wait for 100ns; -- Q should be A = 4
        C <= '1';
        wait for 100ns; -- Q should be B = 5

        -- Input pair 4: A=6, B=7
        A <= "0110";
        B <= "0111";
        C <= '0';
        wait for 100ns; -- Q should be A = 6
        C <= '1';
        wait for 100ns; -- Q should be B = 7

        -- Input pair 5: A=8, B=9
        A <= "1000";
        B <= "1001";
        C <= '0';
        wait for 100ns; -- Q should be A = 8
        C <= '1';
        wait for 100ns; -- Q should be B = 9

        wait;
    end process;
end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 12:19:26 PM
-- Design Name: 
-- Module Name: MUX_8_way_4_bit - Behavioral
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

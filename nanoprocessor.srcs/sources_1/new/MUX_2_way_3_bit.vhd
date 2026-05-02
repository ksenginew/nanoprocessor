----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 12:14:13 PM
-- Design Name: 
-- Module Name: MUX_2_way_3_bit - Behavioral
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

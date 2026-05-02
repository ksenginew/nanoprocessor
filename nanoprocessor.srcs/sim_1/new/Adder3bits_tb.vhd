----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2026 08:20:58 PM
-- Design Name: 
-- Module Name: Adder3bits_tb - Behavioral
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

entity Adder3bits_tb is
--  Port ( );
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

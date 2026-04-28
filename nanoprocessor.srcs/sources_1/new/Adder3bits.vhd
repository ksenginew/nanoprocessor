----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2026 11:41:44 PM
-- Design Name: 
-- Module Name: Adder3bits - Behavioral
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

entity Adder3bits is
    Port ( A : in STD_LOGIC_VECTOR (2 downto 0);
           E : out STD_LOGIC_VECTOR (2 downto 0));
end Adder3bits;

architecture Behavioral of Adder3bits is
signal B : std_logic_vector (2 downto 0) := "001";
signal C : std_logic_vector (2 downto 0);

    component FA
        port(
            A : in std_logic;
            B : in std_logic;
            C_in : in std_logic;
            SUM : out std_logic;
            C_out : out std_logic
        );
    end component;
    
begin
    
    FA0 : FA
        port map(
            A => A(0),
            B => B(0),
            C_in => '0',
            SUM => E(0),
            C_out => C(0)
        );
    
    FA1 : FA
        port map(
            A => A(1),
            B => B(1),
            C_in => C(0),
            SUM => E(1),
            C_out => C(1)
        );
        
    FA2 : FA
        port map(
            A => A(2),
            B => B(2),
            C_in => C(1),
            SUM => E(2),
            C_out => C(2)
        );
 
end Behavioral;

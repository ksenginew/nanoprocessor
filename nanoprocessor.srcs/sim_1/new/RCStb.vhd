----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2026 02:25:38 PM
-- Design Name: 
-- Module Name: RCStb - Behavioral
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

entity RCStb is
--  Port ( );
end RCStb;

architecture Behavioral of RCStb is
signal A : std_logic_vector(3 downto 0) := "0000";
signal B : std_logic_vector(3 downto 0) := "0000";
signal C_in : std_logic := '0';
signal SUM : std_logic_vector(3 downto 0);
signal C_out : std_logic;
signal Zero : std_logic;
signal OverFlow : std_logic;

component RCA4bit
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           C_in : in STD_LOGIC;
           SUM : out STD_LOGIC_VECTOR (3 downto 0);
           C_out : out STD_LOGIC;
           Zero : out STD_LOGIC;
           OverFlow : out STD_LOGIC);
end component;

begin
    UUT : RCA4bit
    port map(
       A => A,
       B => B,
       C_in => C_in,
       SUM => SUM,
       C_out => C_out,
       Zero => Zero,
       OverFlow => OverFlow
    );

    process 
    begin
        A <= "0000";
        B <= "0000";
        wait for 20 ns;
        
        A <= "1111";
        B <= "1111";
        wait for 20 ns;
        
        A <= "0111";
        B <= "0111";
        wait for 20 ns;
        
        A <= "0110";
        B <= "0011";
        wait for 20 ns;
        
        A <= "1010";
        B <= "0111";
        wait for 20 ns;B <= "0011";
        wait;
    end process;
    
end Behavioral;

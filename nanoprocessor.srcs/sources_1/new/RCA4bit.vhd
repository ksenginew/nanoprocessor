----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2026 05:27:13 AM
-- Design Name: 
-- Module Name: RCA4bit - Behavioral
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

entity RCA4bit is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           C_in : in STD_LOGIC;
           SUM : out STD_LOGIC_VECTOR (3 downto 0);
           C_out : out STD_LOGIC;
           Zero : out STD_LOGIC;
           OverFlow : out STD_LOGIC);
end RCA4bit;

architecture Behavioral of RCA4bit is
signal C : std_logic_vector(4 downto 0);
signal res : std_logic_vector(3 downto 0);

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
    C(0) <= C_in;
    
    FA0 : FA
        port map(
            A => A(0),
            B => B(0),
            C_in => C(0),
            SUM => res(0),
            C_out => C(1)
        );
    
    FA1 : FA 
        port map(
            A => A(1),
            B => B(1),
            C_in => C(1),
            SUM => res(1),
            C_out => C(2)
        );
        
    FA2 : FA 
        port map(
            A => A(2),
            B => B(2),
            C_in => C(2),
            SUM => res(2),
            C_out => C(3)
        );
        
    FA3 : FA 
        port map(
            A => A(3),
            B => B(3),
            C_in => C(3),
            SUM => res(3),
            C_out => C(4)
        );
    
    SUM <= res;  
    OverFlow <= C(4) xor C(3);
    C_out <= C(4);
    Zero <= not(res(0) or res(1) or res(2) or res(3));

end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 07:30:33 AM
-- Design Name: 
-- Module Name: PC - Behavioral
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

entity PC is
    Port ( CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           PC_in : in STD_LOGIC_VECTOR (2 downto 0);
           PC_out : out STD_LOGIC_VECTOR (2 downto 0));
end PC;

architecture Structural of PC is
    component DFF
        port(
            D : in STD_LOGIC;
            CLK : in std_logic;
            RESET : in std_logic;
            Q : out std_logic
            );
     end component;
     
begin
    FF0 : DFF
        port map(
            D => PC_in(0),
            CLK => CLK,
            RESET => RESET,
            Q => PC_out(0)
            );
    
    FF1 : DFF 
    port map (
        D => PC_in(1),
        CLK => CLK,
        RESET => RESET,
        Q => PC_out(1)
        );
        
    FF2 : DFF
    port map(
        D => PC_in(2),
        CLK => CLK,
        RESET => RESET,
        Q => PC_out(2)
        );

end Structural;

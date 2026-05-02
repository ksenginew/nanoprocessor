----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 07:20:01 AM
-- Design Name: 
-- Module Name: DFF - Behavioral
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

entity DFF is
    port (
        D     : in std_logic;
        CLK   : in std_logic;
        RESET : in std_logic;
        Q     : out std_logic);
end DFF;

architecture Behavioral of DFF is
    signal Q_reg : std_logic;

begin
    process (CLK, RESET)
    begin
        if RESET = '1' then
            Q_reg <= '0';
        elsif rising_edge(CLK) then
            Q_reg <= D;
        end if;
    end process;
    Q <= Q_reg;
end Behavioral;

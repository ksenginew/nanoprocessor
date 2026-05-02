----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 11:20:36 AM
-- Design Name: 
-- Module Name: D_FF - Behavioral
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

entity D_FF is
    port (
        D   : in std_logic;
        Res : in std_logic;
        Clk : in std_logic;
        EN  : in std_logic;
        Q   : out std_logic);
end D_FF;

architecture Behavioral of D_FF is

    signal q_reg : std_logic;

begin
    process (Clk, Res)
    begin
        if Res = '1' then
            q_reg <= '0';

        elsif rising_edge(Clk) then
            if EN = '1' then
                q_reg <= D;
            end if;
        end if;
    end process;

    Q <= q_reg;

end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 05:03:59 PM
-- Design Name: 
-- Module Name: Clock_Divider - Behavioral
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
entity Clock_Divider is
    generic (
        PRELOAD_VAL : integer := 49999999);
    port (
        clk_in  : in std_logic;
        clk_out : out std_logic);
end Clock_Divider;

architecture Behavioral of Clock_Divider is
    signal count      : integer range 0 to PRELOAD_VAL := 0;
    signal clk_status : std_logic                   := '0';
begin
    process (clk_in) begin
        if rising_edge(clk_in) then
            if count = PRELOAD_VAL then
                clk_status <= not clk_status;
                count      <= 0;
            else
                count <= count + 1;
            end if;
        end if;
    end process;

    clk_out <= clk_status;
end Behavioral;
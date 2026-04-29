----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 05:03:59 PM
-- Design Name: 
-- Module Name: clock_divider - Behavioral
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
entity clock_divider is
    Port ( clk_100MHz : in  STD_LOGIC; -- Your W5 pin
           reset      : in  STD_LOGIC;
           clk_1Hz    : out STD_LOGIC); -- Your new slow clock
end clock_divider;

architecture Behavioral of clock_divider is
    -- Signal to hold the current count
    signal count : integer range 0 to 49999999 := 0;
    -- Signal to hold the current state of the new clock
    signal tmp_clk : std_logic := '0';
begin
    process(clk_100MHz, reset)
    begin
        if reset = '1' then
            count <= 0;
            tmp_clk <= '0';
        elsif rising_edge(clk_100MHz) then
            if count = 49999999 then
                tmp_clk <= not tmp_clk; -- Toggle the clock state
                count <= 0;             -- Reset the counter
            else
                count <= count + 1;
            end if;
        end if;
    end process;
    
    clk_1Hz <= tmp_clk;
end Behavioral;
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2026 12:01:42 AM
-- Design Name: 
-- Module Name: Rom - Behavioral
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
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Rom is
    port (
        Ins_S   : in std_logic_vector (2 downto 0);
        Ins_Out : out std_logic_vector (11 downto 0));
end Rom;

architecture Behavioral of Rom is

    type Rom_Type is array (7 downto 0) of std_logic_vector (11 downto 0);

    -- Constant forces Distributed ROM instead of Block RAM.
    constant Ins_Rom : Rom_Type := (
    0      => "100010000011",
    1      => "000100000000",
    2      => "100100100001",
    3      => "100010011111",
    4      => "111100010000",
    5      => "110100000000",
    6      => "000100100100",
    7      => "000000000000",
    others => "000000000000"
    );

begin

    Ins_Out <= Ins_Rom(to_integer(unsigned(Ins_S)));

end Behavioral;

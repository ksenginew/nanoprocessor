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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Rom is
    Port ( Ins_S : in STD_LOGIC_VECTOR (2 downto 0);
           Ins_Out : out STD_LOGIC_VECTOR (11 downto 0));
end Rom;

architecture Behavioral of Rom is

type Rom_Type is array (7 downto 0) of std_logic_vector (11 downto 0);

-- Constant forces Distributed ROM instead of Block RAM.
constant Ins_Rom : Rom_Type := (
  "000000000000",
  "000000000000",
  "000000000000",
  "000000000000",
  "000000000000",
  "000000000000",
  "000000000000",
  "000000000000"  
);

begin

    Ins_Out <= Ins_Rom(to_integer(unsigned(Ins_S)));

end Behavioral;

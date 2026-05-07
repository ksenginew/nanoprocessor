library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ROM is
    Port ( addr : in STD_LOGIC_VECTOR (7 downto 0);
           data : out STD_LOGIC_VECTOR (11 downto 0));
end ROM;

architecture Behavioral of ROM is
    type rom_type is array (0 to 8) of STD_LOGIC_VECTOR(11 downto 0);
    constant ROM_CONTENT : rom_type := (
        0 => "101110000000",
        1 => "100100000011",
        2 => "100110000001",
        3 => "010110000110",
        4 => "001111110100",
        5 => "000100100110",
        6 => "111100100000",
        7 => "111000000000",
        others => "000000000000"
    );
begin
    data <= ROM_CONTENT(to_integer(unsigned(addr)));
end Behavioral;

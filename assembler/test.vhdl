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
        0 => "100010000011",
        1 => "000100000000",
        2 => "100100100001",
        3 => "100010011111",
        4 => "111100010000",
        5 => "110100000000",
        6 => "000100100100",
        7 => "000000000000",
        others => "000000000000"
    );
begin
    data <= ROM_CONTENT(to_integer(unsigned(addr)));
end Behavioral;

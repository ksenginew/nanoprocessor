----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_Rom is
end TB_Rom;

architecture Behavioral of TB_Rom is
    signal Ins_S   : std_logic_vector(2 downto 0) := (others => '0');
    signal Ins_Out : std_logic_vector(11 downto 0);

    type rom_type is array (0 to 7) of std_logic_vector(11 downto 0);
    constant expected : rom_type := (
        0      => "101110000000",
    1      => "100100000011",
    2      => "100110000001",
    3      => "010110000110",
    4      => "001111110100",
    5      => "000100100110",
    6      => "111100100000",
    7      => "111000000000");

    component Rom
        port (
            Ins_S   : in std_logic_vector(2 downto 0);
            Ins_Out : out std_logic_vector(11 downto 0));
    end component;
begin
    uut : Rom
        port map (
            Ins_S   => Ins_S,
            Ins_Out => Ins_Out);

    stim_proc : process
    begin
        for idx in 0 to 7 loop
            Ins_S <= std_logic_vector(to_unsigned(idx, 3));
            wait for 1 ns;
            assert Ins_Out = expected(idx)
                report "ROM contents mismatch at address " & integer'image(idx)
                severity failure;
        end loop;

        wait;
    end process;
end Behavioral;
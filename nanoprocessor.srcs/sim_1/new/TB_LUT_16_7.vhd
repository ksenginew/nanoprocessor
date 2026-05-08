----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_LUT_16_7 is
end TB_LUT_16_7;

architecture Behavioral of TB_LUT_16_7 is
    signal address : std_logic_vector(3 downto 0) := (others => '0');
    signal data    : std_logic_vector(6 downto 0);

    component LUT_16_7
        port (
            address : in std_logic_vector(3 downto 0);
            data    : out std_logic_vector(6 downto 0));
    end component;
begin
    uut : LUT_16_7
        port map (
            address => address,
            data    => data);

    stim_proc : process
    begin
        address <= x"0"; wait for 1 ns; assert data = "1000000" severity failure;
        address <= x"A"; wait for 1 ns; assert data = "0001000" severity failure;
        address <= x"F"; wait for 1 ns; assert data = "0001110" severity failure;

        wait;
    end process;
end Behavioral;
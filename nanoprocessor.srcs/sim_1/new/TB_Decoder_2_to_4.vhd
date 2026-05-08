----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_Decoder_2_to_4 is
end TB_Decoder_2_to_4;

architecture Behavioral of TB_Decoder_2_to_4 is
    signal I  : std_logic_vector(1 downto 0) := (others => '0');
    signal EN : std_logic := '0';
    signal Y  : std_logic_vector(3 downto 0);

    constant ZERO4 : std_logic_vector(3 downto 0) := (others => '0');

    component Decoder_2_to_4
        port (
            I  : in std_logic_vector(1 downto 0);
            EN : in std_logic;
            Y  : out std_logic_vector(3 downto 0));
    end component;
begin
    uut : Decoder_2_to_4
        port map (
            I  => I,
            EN => EN,
            Y  => Y);

    stim_proc : process
    begin
        EN <= '1';

        I <= "00"; wait for 1 ns; assert Y = "0001" severity failure;
        I <= "01"; wait for 1 ns; assert Y = "0010" severity failure;
        I <= "10"; wait for 1 ns; assert Y = "0100" severity failure;
        I <= "11"; wait for 1 ns; assert Y = "1000" severity failure;

        EN <= '0';
        wait for 1 ns;
        assert Y = ZERO4
            report "Decoder_2_to_4 should output all zeros when disabled"
            severity failure;

        wait;
    end process;
end Behavioral;
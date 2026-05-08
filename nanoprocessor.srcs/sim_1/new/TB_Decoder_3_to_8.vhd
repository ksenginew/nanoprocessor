----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_Decoder_3_to_8 is
end TB_Decoder_3_to_8;

architecture Behavioral of TB_Decoder_3_to_8 is
    signal I  : std_logic_vector(2 downto 0) := (others => '0');
    signal EN : std_logic := '0';
    signal Y  : std_logic_vector(7 downto 0);

    constant ZERO8 : std_logic_vector(7 downto 0) := (others => '0');

    component Decoder_3_to_8
        port (
            I  : in std_logic_vector(2 downto 0);
            EN : in std_logic;
            Y  : out std_logic_vector(7 downto 0));
    end component;
begin
    uut : Decoder_3_to_8
        port map (
            I  => I,
            EN => EN,
            Y  => Y);

    stim_proc : process
        variable expected : std_logic_vector(7 downto 0);
    begin
        EN <= '1';

        for idx in 0 to 7 loop
            expected := ZERO8;
            expected(idx) := '1';
            I <= std_logic_vector(to_unsigned(idx, 3));
            wait for 1 ns;
            assert Y = expected
                report "Decoder_3_to_8 failed for input " & integer'image(idx)
                severity failure;
        end loop;

        EN <= '0';
        I <= "101";
        wait for 1 ns;
        assert Y = ZERO8
            report "Decoder_3_to_8 should output all zeros when disabled"
            severity failure;

        wait;
    end process;
end Behavioral;
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_FA is
end TB_FA;

architecture Behavioral of TB_FA is
    signal A     : std_logic := '0';
    signal B     : std_logic := '0';
    signal C_in  : std_logic := '0';
    signal SUM   : std_logic;
    signal C_out : std_logic;

    component FA
        port (
            A     : in std_logic;
            B     : in std_logic;
            C_in  : in std_logic;
            SUM   : out std_logic;
            C_out : out std_logic);
    end component;
begin
    uut : FA
        port map (
            A     => A,
            B     => B,
            C_in  => C_in,
            SUM   => SUM,
            C_out => C_out);

    stim_proc : process
    begin
        A <= '0'; B <= '0'; C_in <= '0'; wait for 1 ns;
        assert SUM = '0' and C_out = '0' severity failure;

        A <= '1'; B <= '1'; C_in <= '0'; wait for 1 ns;
        assert SUM = '0' and C_out = '1' severity failure;

        A <= '1'; B <= '0'; C_in <= '1'; wait for 1 ns;
        assert SUM = '0' and C_out = '1' severity failure;

        A <= '1'; B <= '1'; C_in <= '1'; wait for 1 ns;
        assert SUM = '1' and C_out = '1' severity failure;

        wait;
    end process;
end Behavioral;
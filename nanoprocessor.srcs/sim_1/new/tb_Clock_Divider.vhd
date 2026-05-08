----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Clock_Divider is
end tb_Clock_Divider;

architecture Behavioral of tb_Clock_Divider is
    signal clk_in  : std_logic := '0';
    signal clk_out : std_logic;

    component Clock_Divider
        generic (
            PRELOAD_VAL : integer := 49999999);
        port (
            clk_in  : in std_logic;
            clk_out : out std_logic);
    end component;
begin
    uut : Clock_Divider
        generic map (
            PRELOAD_VAL => 3)
        port map (
            clk_in  => clk_in,
            clk_out => clk_out);

    clk_process : process
    begin
        while true loop
            clk_in <= '0';
            wait for 5 ns;
            clk_in <= '1';
            wait for 5 ns;
        end loop;
    end process;

    stim_proc : process
    begin
        wait until rising_edge(clk_in);
        wait until rising_edge(clk_in);
        wait until rising_edge(clk_in);
        wait until rising_edge(clk_in);
        wait for 1 ns;
        assert clk_out = '1'
            report "Clock divider did not toggle after 4 input edges"
            severity failure;

        wait until rising_edge(clk_in);
        wait until rising_edge(clk_in);
        wait until rising_edge(clk_in);
        wait until rising_edge(clk_in);
        wait for 1 ns;
        assert clk_out = '0'
            report "Clock divider did not toggle back after the next 4 input edges"
            severity failure;

        wait;
    end process;
end Behavioral;
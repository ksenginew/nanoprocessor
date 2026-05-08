----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_FF_tb is
end D_FF_tb;

architecture Behavioral of D_FF_tb is
    signal D     : std_logic := '0';
    signal Res   : std_logic := '0';
    signal Clk   : std_logic := '0';
    signal EN    : std_logic := '0';
    signal Q     : std_logic;

    component D_FF
        port (
            D     : in std_logic;
            Res   : in std_logic;
            Clk   : in std_logic;
            EN    : in std_logic;
            Q     : out std_logic);
    end component;
begin
    uut : D_FF
        port map (
            D   => D,
            Res => Res,
            Clk => Clk,
            EN  => EN,
            Q   => Q);

    clk_process : process
    begin
        while true loop
            Clk <= '0';
            wait for 5 ns;
            Clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    stim_proc : process
    begin
        Res <= '1';
        EN  <= '1';
        D   <= '1';
        wait for 2 ns;
        assert Q = '0'
            report "D_FF reset did not clear the register"
            severity failure;

        Res <= '0';
        wait until rising_edge(Clk);
        wait for 1 ns;
        assert Q = '1'
            report "D_FF did not capture D on an enabled edge"
            severity failure;

        D  <= '0';
        EN <= '0';
        wait until rising_edge(Clk);
        wait for 1 ns;
        assert Q = '1'
            report "D_FF changed state while EN was low"
            severity failure;

        Res <= '1';
        wait for 1 ns;
        assert Q = '0'
            report "D_FF asynchronous reset failed"
            severity failure;

        wait;
    end process;
end Behavioral;
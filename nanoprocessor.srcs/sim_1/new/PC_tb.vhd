----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 07:46:44 AM
-- Design Name: 
-- Module Name: PC_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC_tb is
--  Port ( );
end PC_tb;

architecture Behavioral of PC_tb is

    signal CLK : std_logic := '0';
    signal RESET : std_logic := '0';
    signal PC_in : std_logic_vector(2 downto 0) := "000";
    signal PC_out : std_logic_vector(2 downto 0);
    
    component PC
        port(
            CLK : in std_logic;
            RESET : in std_logic;
            PC_in : in std_logic_vector(2 downto 0);
            PC_out : out std_logic_vector(2 downto 0)
        );
    end component;

begin
    UUT: PC
    port map (
        CLK    => CLK,
        RESET  => RESET,
        PC_in  => PC_in,
        PC_out => PC_out
    );

CLK <= not CLK after 10 ns;

process
begin
    RESET <= '1';
    wait for 20 ns;

    RESET <= '0';
    PC_in <= "001";
    wait for 20 ns;

    PC_in <= "010";
    wait for 20 ns;

    PC_in <= "011";
    wait for 20 ns;

    PC_in <= "100";
    wait for 40 ns;
    
    RESET <= '1';
    wait;
end process;

end Behavioral;

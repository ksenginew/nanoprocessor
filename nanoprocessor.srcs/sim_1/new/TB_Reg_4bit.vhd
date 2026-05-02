----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 01:42:41 PM
-- Design Name: 
-- Module Name: TB_Reg_4bit - Behavioral
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
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB_Reg_4bit is
    --  Port ( );
end TB_Reg_4bit;

architecture Behavioral of TB_Reg_4bit is

    component Reg_4bit
        port (
            D   : in std_logic_vector (3 downto 0);
            EN  : in std_logic;
            Res : in std_logic;
            Clk : in std_logic;
            Q   : out std_logic_vector (3 downto 0));
    end component;

    signal D   : std_logic_vector(3 downto 0) := "0000";
    signal EN  : std_logic                    := '0';
    signal Res : std_logic                    := '0';
    signal Clk : std_logic                    := '0';
    signal Q   : std_logic_vector(3 downto 0);

begin
    UUT : Reg_4bit
    port map
    (
        D   => D,
        EN  => EN,
        Res => Res,
        Clk => Clk,
        Q   => Q);
    process
    begin
        while true loop
            Clk <= '0';
            wait for 50ns;
            Clk <= '1';
            wait for 50ns;
        end loop;
    end process;

    process
    begin
        Res <= '1';
        wait for 100 ns;
        Res <= '0';

        EN <= '1';
        D  <= "1111";
        wait for 100 ns;

        D <= "1001";
        wait for 100 ns;

        D <= "1100";
        wait for 100 ns;

        EN <= '0';
        D  <= "1010";
        wait for 100 ns;

        EN <= '1';
        D  <= "0110";
        wait for 100 ns;

        Res <= '1';
        wait for 100 ns;
        Res <= '0';

        wait;
    end process;

end Behavioral;

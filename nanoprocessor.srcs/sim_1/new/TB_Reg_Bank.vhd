----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 02:11:27 PM
-- Design Name: 
-- Module Name: TB_Reg_Bank - Behavioral
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

entity TB_Reg_Bank is
    --  Port ( );
end TB_Reg_Bank;

architecture Behavioral of TB_Reg_Bank is

    component Reg_Bank
        port (
            D        : in std_logic_vector(3 downto 0);
            Clk      : in std_logic;
            Res      : in std_logic;
            Reg_sel  : in std_logic_vector(2 downto 0);
            Write_EN : in std_logic;
            R1       : out std_logic_vector(3 downto 0);
            R2       : out std_logic_vector(3 downto 0);
            R3       : out std_logic_vector(3 downto 0);
            R4       : out std_logic_vector(3 downto 0);
            R5       : out std_logic_vector(3 downto 0);
            R6       : out std_logic_vector(3 downto 0);
            R7       : out std_logic_vector(3 downto 0);
            R0       : out std_logic_vector(3 downto 0));
    end component;

    signal D                              : std_logic_vector(3 downto 0) := "0000";
    signal Clk                            : std_logic                    := '0';
    signal Res                            : std_logic                    := '0';
    signal Reg_sel                        : std_logic_vector(2 downto 0) := "000";
    signal Write_EN                       : std_logic                    := '0';
    signal R1, R2, R3, R4, R5, R6, R7, R0 : std_logic_vector(3 downto 0);

begin
    UUT : Reg_Bank
    port map
    (
        D        => D,
        Clk      => Clk,
        Res      => Res,
        Reg_sel  => Reg_sel,
        Write_EN => Write_EN,
        R0       => R0,
        R1       => R1,
        R2       => R2,
        R3       => R3,
        R4       => R4,
        R5       => R5,
        R6       => R6,
        R7       => R7);
    process
    begin
        while true loop
            Clk <= '0';
            wait for 20 ns;
            Clk <= '1';
            wait for 20 ns;
        end loop;
    end process;

    process
    begin
        Res <= '1';
        wait for 50 ns;
        Res <= '0';

        Write_EN <= '1';

        D       <= "0001";
        Reg_sel <= "001";
        wait for 40 ns;

        D       <= "0101";
        Reg_sel <= "010";
        wait for 40 ns;

        D       <= "1100";
        Reg_sel <= "111";
        wait for 40 ns;

        D       <= "1111";
        Reg_sel <= "000";
        wait for 40 ns;

        Write_EN <= '0';

        Reg_sel <= "001";
        wait for 40 ns;

        Reg_sel <= "010";
        wait for 40 ns;

        Reg_sel <= "111";
        wait for 40 ns;

        Reg_sel <= "000";
        wait for 40 ns;

        Res <= '1';
        wait for 40 ns;
        Res <= '0';

        wait;
    end process;

end Behavioral;

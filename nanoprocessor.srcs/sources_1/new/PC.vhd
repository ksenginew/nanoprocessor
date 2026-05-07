----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 07:30:33 AM
-- Design Name: 
-- Module Name: PC - Behavioral
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

entity PC is
    port (
        CLK    : in std_logic;
        RESET  : in std_logic;
        PC_in  : in std_logic_vector (2 downto 0);
        PC_out : out std_logic_vector (2 downto 0));
end PC;

architecture Structural of PC is
    component D_FF
        port (
            D   : in std_logic;
            Res : in std_logic;
            Clk : in std_logic;
            EN  : in std_logic;
            Q   : out std_logic
        );
    end component;

begin
    FF0 : D_FF
    port map
    (
        D   => PC_in(0),
        Res => RESET,
        CLK => CLK,
        EN  => '1',
        Q   => PC_out(0)
    );

    FF1 : D_FF
    port map
    (
        D   => PC_in(1),
        Res => RESET,
        CLK => CLK,
        EN  => '1',
        Q   => PC_out(1)
    );

    FF2 : D_FF
    port map
    (
        D   => PC_in(2),
        Res => RESET,
        CLK => CLK,
        EN  => '1',
        Q   => PC_out(2)
    );

end Structural;

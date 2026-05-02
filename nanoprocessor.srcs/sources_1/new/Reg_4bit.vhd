----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 11:51:34 AM
-- Design Name: 
-- Module Name: Reg_4bit - Behavioral
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

entity Reg_4bit is
    port (
        D   : in std_logic_vector (3 downto 0);
        EN  : in std_logic;
        Res : in std_logic;
        Clk : in std_logic;
        Q   : out std_logic_vector (3 downto 0));
end Reg_4bit;

architecture Behavioral of Reg_4bit is

    component D_FF
        port (
            D   : in std_logic;
            Res : in std_logic;
            Clk : in std_logic;
            EN  : in std_logic;
            Q   : out std_logic
        );
    end component;

    signal q_internal : std_logic_vector(3 downto 0);

begin
    D_FF_0 : D_FF
    port map
    (
        D   => D(0),
        Res => Res,
        Clk => Clk,
        EN  => EN,
        Q   => q_internal(0));

    D_FF_1 : D_FF
    port map
    (
        D   => D(1),
        Res => Res,
        Clk => Clk,
        EN  => EN,
        Q   => q_internal(1));

    D_FF_2 : D_FF
    port map
    (
        D   => D(2),
        Res => Res,
        Clk => Clk,
        EN  => EN,
        Q   => q_internal(2));

    D_FF_3 : D_FF
    port map
    (
        D   => D(3),
        Res => Res,
        Clk => Clk,
        EN  => EN,
        Q   => q_internal(3));

    Q <= q_internal;

end Behavioral;
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2026 05:57:44 AM
-- Design Name: 
-- Module Name: Add_Sub_4bit - Behavioral
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

entity Add_Sub_4bit is
    port (
        A        : in std_logic_vector (3 downto 0);
        B        : in std_logic_vector (3 downto 0);
        Sub      : in std_logic;
        Res      : out std_logic_vector (3 downto 0);
        OverFlow : out std_logic;
        Zero     : out std_logic);
end Add_Sub_4bit;

architecture Behavioral of Add_Sub_4bit is
    signal B_mod : std_logic_vector(3 downto 0);

    component RCA4bit
        port (
            A        : in std_logic_vector(3 downto 0);
            B        : in std_logic_vector(3 downto 0);
            C_in     : in std_logic;
            SUM      : out std_logic_vector(3 downto 0);
            Zero     : out std_logic;
            OverFlow : out std_logic
        );
    end component;

begin
    B_mod(0) <= B(0) xor Sub;
    B_mod(1) <= B(1) xor Sub;
    B_mod(2) <= B(2) xor Sub;
    B_mod(3) <= B(3) xor Sub;
    RCA1 : RCA4bit
    port map
    (
        A        => A,
        B        => B_mod,
        C_in     => Sub,
        SUM      => Res,
        Zero     => Zero,
        OverFlow => OverFlow
    );

end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 03:22:31 PM
-- Design Name: 
-- Module Name: tb_Nanoprocessor - Behavioral
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

entity tb_Nanoprocessor is
--  Port ( );
end tb_Nanoprocessor;

architecture Behavioral of tb_Nanoprocessor is

component Nanoprocessor
    port (
        Reset   : in std_logic;
        Clk     : in std_logic;
        Out_LED : out std_logic_vector (3 downto 0);
        Out_SS  : out std_logic_vector (6 downto 0);
        Overflow: out std_logic;
        Zero    : out std_logic;
        Anode   : out std_logic_vector (3 downto 0)
    );
    end component;
    
    signal Reset : std_logic := '0';
    signal Clk   : std_logic := '0';
    
    signal Out_LED  : std_logic_vector (3 downto 0);
    signal Out_SS   : std_logic_vector (6 downto 0);
    signal Overflow : std_logic;
    signal Zero     : std_logic;
    signal Anode    : std_logic_vector (3 downto 0);
    
    constant Clk_period : time := 10 ns;
begin

    uut: Nanoprocessor port map (
        Reset    => Reset,
        Clk      => Clk,
        Out_LED  => Out_LED,
        Out_SS   => Out_SS,
        Overflow => Overflow,
        Zero     => Zero,
        Anode    => Anode
    );
    
    Clk_process :process
    begin
        Clk <= '0';
        wait for Clk_period/2;
        Clk <= '1';
        wait for Clk_period/2;
    end process;
    
    stim_proc: process
    begin
        Reset <= '1';
        wait for 100 ns;  
        
        Reset <= '0';
        
        wait for 2000 ns; 

        wait;
    end process;
end Behavioral;

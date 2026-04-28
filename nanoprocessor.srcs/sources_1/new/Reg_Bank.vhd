----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2026 11:54:13 AM
-- Design Name: 
-- Module Name: Reg_Bank - Behavioral
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

entity Reg_Bank is
   Port (
        D        : in  STD_LOGIC_VECTOR(3 downto 0);
        Clk      : in  STD_LOGIC;
        Res      : in  STD_LOGIC;
        Reg_sel  : in  STD_LOGIC_VECTOR(2 downto 0);
        Write_EN : in  STD_LOGIC;
        R1   : out STD_LOGIC_VECTOR(3 downto 0);
        R2   : out STD_LOGIC_VECTOR(3 downto 0);
        R3   : out STD_LOGIC_VECTOR(3 downto 0);
        R4   : out STD_LOGIC_VECTOR(3 downto 0);
        R5   : out STD_LOGIC_VECTOR(3 downto 0);
        R6   : out STD_LOGIC_VECTOR(3 downto 0);
        R7   : out STD_LOGIC_VECTOR(3 downto 0);
        R0   : out STD_LOGIC_VECTOR(3 downto 0));
end Reg_Bank;

architecture Behavioral of Reg_Bank is

   component Decoder_3_to_8
        Port (
            I  : in  STD_LOGIC_VECTOR (2 downto 0);
            EN : in  STD_LOGIC;
            Y  : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component Reg_4bit
         Port (
             D   : in  STD_LOGIC_VECTOR (3 downto 0);
             EN  : in  STD_LOGIC;
             Res : in  STD_LOGIC;
             Clk : in  STD_LOGIC;
             Q   : out STD_LOGIC_VECTOR (3 downto 0));
     end component;

     signal EN_lines : STD_LOGIC_VECTOR(7 downto 0);

   
begin
  Decoder: Decoder_3_to_8
     port map(
        I  => Reg_sel,
        EN => Write_EN,
        Y  => EN_lines);
  
  R0 <= "0000";
        
  Reg_1: Reg_4bit 
     port map(
        D => D, 
        EN => EN_lines(1), 
        Res => Res, 
        Clk => Clk, 
        Q => R1);
                
  Reg_2: Reg_4bit 
      port map(
         D => D, 
         EN => EN_lines(2), 
         Res => Res, 
         Clk => Clk, 
         Q => R2);
         
  Reg_3: Reg_4bit 
      port map(
        D => D, 
        EN => EN_lines(3), 
        Res => Res, 
        Clk => Clk, 
        Q => R3);
         
  Reg_4: Reg_4bit 
     port map(
        D => D, 
        EN => EN_lines(4), 
        Res => Res, 
        Clk => Clk, 
        Q => R4);
                
  Reg_5: Reg_4bit
     port map(
        D => D, 
        EN => EN_lines(5), 
        Res => Res, 
        Clk => Clk, 
        Q => R5);
                
  Reg_6: Reg_4bit 
     port map(
        D => D, 
        EN => EN_lines(6), 
        Res => Res, 
        Clk => Clk, 
        Q => R6);
                
  Reg_7: Reg_4bit 
     port map(
        D => D, 
        EN => EN_lines(7), 
        Res => Res, 
        Clk => Clk, 
        Q => R7);
  
  
end Behavioral;

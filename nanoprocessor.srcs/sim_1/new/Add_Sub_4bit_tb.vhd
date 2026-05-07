----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2026 08:55:01 PM
-- Design Name: 
-- Module Name: Add_Sub_4bit_tb - Behavioral
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

entity Add_Sub_4bit_tb is
--  Port ( );
end Add_Sub_4bit_tb;

architecture Behavioral of Add_Sub_4bit_tb is
    signal A        : STD_LOGIC_VECTOR (3 downto 0);    
    signal B        : STD_LOGIC_VECTOR (3 downto 0);    
    signal Sub      : STD_LOGIC;                      
    signal Res      : STD_LOGIC_VECTOR (3 downto 0); 
    signal C_out    : STD_LOGIC;                   
    signal OverFlow : STD_LOGIC;                
    signal Zero     : STD_LOGIC;        
    
    component Add_Sub_4bit
        port(
            A        : in  STD_LOGIC_VECTOR (3 downto 0);    
            B        : in  STD_LOGIC_VECTOR (3 downto 0);    
            Sub      : in  STD_LOGIC;                      
            Res      : out STD_LOGIC_VECTOR (3 downto 0); 
            C_out    : out STD_LOGIC;                   
            OverFlow : out STD_LOGIC;                
            Zero     : out STD_LOGIC
            );                   
    end component;           
begin

    UUT : Add_Sub_4bit
        port map(
             A        =>  A        ,
             B        =>  B        ,
             Sub      =>  Sub      ,
             Res      =>  Res      ,
             C_out    =>  C_out    ,
             OverFlow =>  OverFlow ,
             Zero     =>  Zero
        );
        
     process 
     begin
     
     A   <= "0000" ;
     B   <= "0011" ;
     Sub <= '0'    ;
     wait for 20 ns;
     
     A   <= "0111" ;
     B   <= "0101" ;
     Sub <= '0'    ;   
     wait for 20 ns;
     
     A   <= "0000" ;
     B   <= "0011" ;
     Sub <= '1'    ;
     wait for 20 ns;

     A   <= "0111" ;
     B   <= "0101" ;
     Sub <= '0'    ;
     wait for 20 ns;
     
     A   <= "0000" ;
     B   <= "0000" ;
     Sub <= '0'    ;
     wait          ;

    end process;
end Behavioral;

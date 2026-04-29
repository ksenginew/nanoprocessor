----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 01:31:17 PM
-- Design Name: 
-- Module Name: Nanoprocessor - Behavioral
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

entity Nanoprocessor is
  port (
    Reset   : in std_logic;
    Clk     : in std_logic;
    Out_LED : out std_logic_vector (3 downto 0);
    Overflow   : out std_logic;
    Zero    : out std_logic
    );
end Nanoprocessor;

architecture Behavioral of Nanoprocessor is
  component PC
    port (
      Clk    : in std_logic;
      RESET  : in std_logic;
      PC_in  : in std_logic_vector (2 downto 0);
      PC_out : out std_logic_vector (2 downto 0));
  end component;

  component Instruction_Decoder is
    port (
      Instruction  : in std_logic_vector (11 downto 0);
      Zero_Flag    : in std_logic;
      Load_Sel     : out std_logic;
      Add_Sub_Sel  : out std_logic;
      Write_Enable : out std_logic;
      Reg_En       : out std_logic_vector (2 downto 0);
      Reg_Sel_A    : out std_logic_vector (2 downto 0);
      Reg_Sel_B    : out std_logic_vector (2 downto 0);
      Imm_Val      : out std_logic_vector (3 downto 0);
      Jump_Addr    : out std_logic_vector (2 downto 0);
      Jump_Flag    : out std_logic
    );
  end component;

  component Adder3bits is
    port (
      A : in std_logic_vector (2 downto 0);
      E : out std_logic_vector (2 downto 0));
  end component;

  component MUX_2_way_3_bit is
    port (
      A : in std_logic_vector (2 downto 0);
      B : in std_logic_vector (2 downto 0);
      S : in std_logic;
      Q : out std_logic_vector (2 downto 0));
  end component;

  component Rom
    port (
      Ins_S   : in std_logic_vector (2 downto 0);
      Ins_Out : out std_logic_vector (11 downto 0));
  end component;

  component Reg_Bank is
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

  component MUX_8_way_4_bit is
    port (
      S  : in std_logic_vector (2 downto 0);
      R0 : in std_logic_vector (3 downto 0);
      R1 : in std_logic_vector (3 downto 0);
      R2 : in std_logic_vector (3 downto 0);
      R3 : in std_logic_vector (3 downto 0);
      R4 : in std_logic_vector (3 downto 0);
      R5 : in std_logic_vector (3 downto 0);
      R6 : in std_logic_vector (3 downto 0);
      R7 : in std_logic_vector (3 downto 0);
      Q  : out std_logic_vector (3 downto 0));
  end component;

  component Add_Sub_4bit is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           Sub : in STD_LOGIC;
           Res : out STD_LOGIC_VECTOR (3 downto 0);
           OverFlow : out STD_LOGIC;
           Zero : out STD_LOGIC);
    end component;

    component MUX_2_way_4_bit is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           S : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

component clock_divider is
    Port ( clk_100MHz : in  STD_LOGIC;
           reset      : in  STD_LOGIC;
           clk_1Hz    : out STD_LOGIC); 
end component;
  signal Slow_Clk        : std_logic;
  
  signal PC_In        : std_logic_vector (2 downto 0);
  signal PC_out       : std_logic_vector (2 downto 0);
  signal PC_Adder_out : std_logic_vector (2 downto 0);
  signal Instruction  : std_logic_vector (11 downto 0);

  -- Register Bank Signals
  signal R1  : std_logic_vector(3 downto 0);
  signal R2  : std_logic_vector(3 downto 0);
  signal R3  : std_logic_vector(3 downto 0);
  signal R4  : std_logic_vector(3 downto 0);
  signal R5  : std_logic_vector(3 downto 0);
  signal R6  : std_logic_vector(3 downto 0);
  signal R7  : std_logic_vector(3 downto 0);
  signal R0  : std_logic_vector(3 downto 0);

  -- Mux Signals
  signal Adder_A : std_logic_vector(3 downto 0);
  signal Adder_B : std_logic_vector(3 downto 0);

  -- ALU Signals
    signal ALU_Result  : std_logic_vector(3 downto 0);

  signal Zero_Flag    : std_logic;
  signal Load_Sel     : std_logic;
  signal Add_Sub_Sel  : std_logic;
  signal Write_Enable : std_logic;
  signal Reg_En       : std_logic_vector (2 downto 0);
  signal Reg_Sel_A    : std_logic_vector (2 downto 0);
  signal Reg_Sel_B    : std_logic_vector (2 downto 0);
  signal Imm_Val      : std_logic_vector (3 downto 0);
  signal Jump_Addr    : std_logic_vector (2 downto 0);
  signal Jump_Flag    : std_logic;

  -- Output Mux for Register Bank and Immediate Value
    signal Mux_Out      : std_logic_vector (3 downto 0);
begin

  Clock: clock_divider
  port map (
    clk_100MHz => Clk,
    clk_1Hz => Slow_Clk,
    reset => Reset
  );
  PC_Adder_Comp : Adder3bits
  port map
  (
    A => PC_out,
    E => PC_Adder_out
  );

  Mux_2_3_Comp : MUX_2_way_3_bit
  port map
  (
    A => PC_Adder_Out,
    B => Jump_Addr,
    S => Jump_Flag,
    Q => PC_In
  );

  PC_Comp : PC
  port map
  (
    Clk    => Slow_Clk,
    RESET  => Reset,
    PC_in  => PC_In,
    PC_out => PC_Out);

  Rom_Comp : Rom
  port map
  (
    Ins_S   => PC_Out,
    Ins_Out => Instruction
  );

  Instruction_Decoder_Comp : Instruction_Decoder
  port map
  (
    Instruction  => Instruction,
    Zero_Flag    => Zero_Flag,
    Load_Sel     => Load_Sel,
    Add_Sub_Sel  => Add_Sub_Sel,
    Write_Enable => Write_Enable,
    Reg_En       => Reg_En,
    Reg_Sel_A    => Reg_Sel_A,
    Reg_Sel_B    => Reg_Sel_B,
    Imm_Val      => Imm_Val,
    Jump_Addr    => Jump_Addr,
    Jump_Flag    => Jump_Flag
  );

  Reg_Bank_Comp : Reg_Bank
  port map
  (
    D        => Mux_Out,
    Clk      => Slow_Clk,
    Res      => Reset,
    Reg_sel  => Reg_En,
    Write_EN => Write_Enable,
    R1       => R1,
    R2       => R2,
    R3       => R3,
    R4       => R4,
    R5       => R5,
    R6       => R6,
    R7       => R7,
    R0       => R0
  );

  Mux_8_4_Comp_A : MUX_8_way_4_bit
  port map(
    S  => Reg_Sel_A, 
    R0 => R0,
    R1 => R1,
    R2 => R2,
    R3 => R3,
    R4 => R4,
    R5 => R5,
    R6 => R6,
    R7 => R7,
    Q  => Adder_A );

  Mux_8_4_Comp_B : MUX_8_way_4_bit
  port map(
    S  => Reg_Sel_B, 
    R0 => R0,
    R1 => R1,
    R2 => R2,
    R3 => R3,
    R4 => R4,
    R5 => R5,
    R6 => R6,
    R7 => R7,
    Q  => Adder_B );

    Adder_Sub_Comp : Add_Sub_4bit
    port map(
        A => Adder_A,
        B => Adder_B,
        Sub => Add_Sub_Sel,
        Res => ALU_Result,
        OverFlow => Overflow,
        Zero => Zero_Flag
    );

    Mux_2_4_Comp : MUX_2_way_4_bit
    port map(
        A => ALU_Result,
        B => Imm_Val,
        S => Load_Sel,
        Q => Mux_Out
    );

    Zero <= Zero_Flag;
    Out_LED <= R7;
end Behavioral;

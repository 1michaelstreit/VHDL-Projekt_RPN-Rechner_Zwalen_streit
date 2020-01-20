-------------------------------------------------------------------------------
-- Filename 	: rpn_calculator_top.vhd
-- Title    	: Top layer of the calculator 
-- Author   	: Patrick Zwahlen
-- Date     	: 07.01.2020
-- Projectname	: VHDL-Projekt_RPN-Rechner_Zwahlen_Streit
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity rpn_calculator_top is

  port (
    clock    : in  std_logic;    -- clock for the calculators state memory
    reset    : in  std_logic;    -- reset for the calculators state memory
    buttons  : in  std_logic_vector(3 downto 0));   

end entity rpn_calculator_top;

-------------------------------------------------------------------------------

architecture str of rpn_calculator_top is
	signal por			: std_logic; 
	signal strobe		: std_logic;
	signal value		: std_logic_vector(3 downto 0);

begin  -- architecture str

  -- buttons on the GECKO4-EDUCATION are low-active
	por <= not reset;

	Keypad_1: entity work.Keypad(rtl)
	port map (
	clk			=> clock,
	por			=> por,
	buttons		=> buttons,
	strobe		=> strobe,
	value		=> value);

end architecture str;

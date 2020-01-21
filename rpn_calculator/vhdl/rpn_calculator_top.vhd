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
    column	 : out std_logic_vector(3 downto 0);
    row		 : in  std_logic_vector(3 downto 0);
    segment1 : out std_logic_vector(7 downto 0));

end entity rpn_calculator_top;

-------------------------------------------------------------------------------

architecture str of rpn_calculator_top is
	type led_row is array (12 downto 1) of std_logic;
	type led_matrix is array (10 downto 1) of led_row;
	type rows is array (3 downto 0) of std_logic;
	type cols is array (3 downto 0) of std_logic;
	signal por			: std_logic; 
	signal value		: std_logic_vector(4 downto 0);
	signal seg1			: std_logic_vector(7 downto 0);
	signal seg2			: std_logic_vector(7 downto 0);
	signal seg3			: std_logic_vector(7 downto 0);
	signal seg4			: std_logic_vector(7 downto 0);
	signal s_column		: std_logic_vector(3 downto 0);
	signal r_row		: std_logic_vector(3 downto 0);

begin  -- architecture str

  -- buttons on the GECKO4-EDUCATION are low-active
	por <= not reset;
	column <= s_column;
	r_row <= row;

	Keypad_1: entity work.Keypad(rtl)
	port map (
	clk			=> clock,
	por			=> por,
	col			=> s_column,
	row			=> r_row,
	output_value=> value);
					 
	with value select
		seg1 <=  "11111100" when "10000", --0
					  "01100000" when "10001", --1
					  "11001010" when "10010", --2
					  "11110010" when "10011", --3
					  "01100110" when "10100", --4
					  "10110110" when "10101", --5
					  "10111110" when "10110", --6
					  "11100000" when "10111", --7
					  "11111110" when "11000", --8
					  "11110110" when "11001", --9
					  "00000001" when others;
	segment1 <= seg1;

end architecture str;

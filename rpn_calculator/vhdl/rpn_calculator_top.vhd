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
    clock   	: in  std_logic;    -- clock for the calculators state memory
    reset   	: in  std_logic;    -- reset for the calculators state memory
    kp_column	: out std_logic_vector(3 downto 0);
    kp_row		: in  std_logic_vector(3 downto 0);
    segment1	: out std_logic_vector(7 downto 0);
    segment2	: out std_logic_vector(7 downto 0);
    segment3	: out std_logic_vector(7 downto 0);
    segment4	: out std_logic_vector(7 downto 0);
	led_matrix1	: out std_logic_vector(11 downto 0));

end entity rpn_calculator_top;

-------------------------------------------------------------------------------

architecture str of rpn_calculator_top is
	type rows is array (3 downto 0) of std_logic;
	type cols is array (3 downto 0) of std_logic;
	signal por			: std_logic; 
	signal value		: std_logic_vector(4 downto 0);
	signal seg1			: std_logic_vector(7 downto 0);
	signal seg2			: std_logic_vector(7 downto 0);
	signal seg3			: std_logic_vector(7 downto 0);
	signal seg4			: std_logic_vector(7 downto 0);
	signal led1			: std_logic;
	signal s_column		: std_logic_vector(3 downto 0);
	signal r_row		: std_logic_vector(3 downto 0);

begin  -- architecture str

  -- buttons on the GECKO4-EDUCATION are low-active
	por <= not reset;
	kp_column <= s_column;
	r_row <= kp_row;

	Keypad_1: entity work.Keypad(rtl)
	port map (
	clk			=> clock,
	por			=> por,
	col			=> s_column,
	row			=> r_row,
	output_value=> value);
	
--	Test section for outputs
--	led_matrix1(1) <= reset;
--					 
--	with value select
--		seg1 <=  "00111111" when "10000", --0
--					  "00000110" when "10001", --1
--					  "01011011" when "10010", --2
--					  "01001111" when "10011", --3
--					  "01100110" when "10100", --4
--					  "01101101" when "10101", --5
--					  "01111101" when "10110", --6
--					  "00000111" when "10111", --7
--					  "01111111" when "11000", --8
--					  "01101111" when "11001", --9
--					  "01000000" when "11011", --Nagative
--					  "10000000" when "11111", --DIV#0
--					  "00000000" when others;
--	segment1 <= seg1;

end architecture str;

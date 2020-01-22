-------------------------------------------------------------------------------
-- Filename 	: Shift_Register_tb.vhd
-- Title    	: Shift Register Test Bench
-- Author   	: Michael Streit
-- Date     	: 20.01.2020
-- Projectname	: VHDL-Projekt_RPN-Rechner_Zwahlen_Streit
-- Notes		: Testet das Register. Der Ausgang s_data_reg ist beim testen
--				undefiniert. 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity Shift_Register_tb is
	generic(NBIT : positive:= 12);

end entity Shift_Register_tb;

-------------------------------------------------------------------------------

architecture bench of Shift_Register_tb is
	-- component ports
	signal clk,rst : std_logic := '0';
	signal s_forward_en, s_shift_en,s_new_number_input : std_logic :='0';
	signal s_data_result, s_data_reg : std_logic_vector(NBIT-1 downto 0) := (others => '0');
	signal s_data_in_button : std_logic_vector(3 downto 0);
	

	signal tb_finished : boolean := false;


begin  -- architecture bench

	ADD: entity work.Shift_Register
		generic map(
			NBIT => NBIT
		)
		port map (
			clk => clk,
			rst => rst,
			New_Number_Input => s_new_number_input,
			s_forward_en => s_forward_en,
			s_shift_en => s_shift_en,
			data_in_button => s_data_in_button,
			data_in_Result => s_data_result,
			data_out => s_data_reg);

	-- clock generation
	clk <= not clk after 10 ps when not tb_finished else
         '0';

	STIMULI: process
	begin
		wait until clk = '1';
		rst <= '1';
		wait until clk = '1';
		rst <= '0';
		wait until clk = '1';
		wait until clk = '1';
		s_data_in_button <= x"5";
		s_shift_en <= '1';
		wait until clk = '1';
		s_shift_en <= '0';
		wait until clk = '1';
		wait until clk = '1';
		wait until clk = '1';
		s_data_in_button <= x"8";
		s_shift_en <= '1';
		wait until clk = '1';
		s_shift_en <= '0';
		wait until clk = '1';
		wait until clk = '1';
		wait until clk = '1';
		s_data_in_button <= x"7";
		s_shift_en <= '1';
		wait until clk = '1';
		s_shift_en <= '0';
		wait until clk = '1';
		wait until clk = '1';
		wait until clk = '1';
		s_data_in_button <= x"3";
		s_shift_en <= '1';
		wait until clk = '1';
		s_shift_en <= '0';
		wait until clk = '1';

		wait for 50 ps;
		tb_finished <= true;
		wait;
	end process STIMULI;

end architecture bench;

-------------------------------------------------------------------------------

configuration d_Shift_Register_tb_bench_cfg of Shift_Register_tb is
	for bench
	end for;
end d_Shift_Register_tb_bench_cfg;

-------------------------------------------------------------------------------

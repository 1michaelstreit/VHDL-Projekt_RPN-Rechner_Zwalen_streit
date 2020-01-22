-------------------------------------------------------------------------------
-- Filename 	: Subtractor_tb.vhd
-- Title    	: Subtrahierer
-- Author   	: Michael Streit
-- Date     	: 20.01.2020
-- Projectname	: VHDL-Projekt_RPN-Rechner_Zwahlen_Streit
-- Notes		: Testet Subtractor
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity subtractor_tb is

end entity subtractor_tb;

-------------------------------------------------------------------------------

architecture bench of subtractor_tb is
	-- component ports
	signal clk : std_logic := '0';
	signal a,b   : std_logic_vector(11 downto 0);
	signal c	: std_logic_vector(11 downto 0);

	signal tb_finished : boolean := false;


begin  -- architecture bench

	ADD: entity work.Subtractor
		port map (
			en => '1',
			a => a,
			b => b,
			c => c);

	-- clock generation
	clk <= not clk after 10 ns when not tb_finished else
         '0';

	STIMULI: process
	begin
		a <= "000000001001";
		b <= "100000000110";
		wait until clk = '1';
		a <= "100000000001";
		b <= "000000000110";
		wait until clk = '1';
		a <= "100000000001";
		b <= "000000000001";
		wait until clk = '1';
		a <= "100000000001";
		b <= "000000000010";
		wait until clk = '1';
		a <= "111111111111";
		b <= "000000000001";
		wait until clk = '1';
		a <= "000000000000";
		b <= "000000000001";

		wait for 50 ns;
		tb_finished <= true;
		wait;
	end process STIMULI;

end architecture bench;

-------------------------------------------------------------------------------

configuration d_subtractor_tb_bench_cfg of subtractor_tb is
	for bench
	end for;
end d_subtractor_tb_bench_cfg;

-------------------------------------------------------------------------------

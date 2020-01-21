library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity FSM_Menu_tb is

end entity FSM_Menu_tb;

-------------------------------------------------------------------------------

architecture bench of FSM_Menu_tb is
	-- component ports
	signal clk,rst : std_logic := '0';
	signal error: std_logic := '0';
	signal strobe_newButton : std_logic :='0';
	signal data_in_button : std_logic_vector(3 downto 0);
	signal data_out :std_logic_vector(11 downto 0);
	signal tb_finished : boolean := false;


begin  -- architecture bench

	ADD: entity work.FSM_Menu
		port map (
			data_in_button => data_in_button,
			clk => clk,
			rst => rst,
			strobe_newButton => strobe_newButton,
			data_out => data_out,
			error => error
		);

	-- clock generation
	clk <= not clk after 10 ns when not tb_finished else
         '0';

	STIMULI: process
	begin
		-- Reset
		wait until clk = '1';
		rst <= '1';
		wait until clk = '1';
		rst <= '0';
		wait until clk = '1';
		wait until clk = '1';
		wait until clk = '1';
		wait until clk = '1';
		wait until clk = '1';
		-- Button read
		strobe_newButton <= '1';
		data_in_button <= x"1";
		wait until clk = '1';
		strobe_newButton <= '0';
		-- wait some clks
		wait until clk = '1';
		wait until clk = '1';
		-- second button read
		strobe_newButton <='1';
		data_in_button <= x"2";
		wait until clk = '1';
		strobe_newButton <='0';
		wait until clk = '1';
		wait until clk = '1';
		-- Enter
		strobe_newButton <='1';
		data_in_button <= x"E";
		wait until clk = '1';
		strobe_newButton <= '0';
		wait until clk = '1';
		wait until clk = '1';
		-- Button Read
		strobe_newButton <= '1';
		data_in_button <= x"2";
		wait until clk = '1';
		strobe_newButton <= '0';
		-- wait some clks
		wait until clk = '1';
		wait until clk = '1';
		-- Addition
		strobe_newButton <= '1';
		data_in_button <= x"A";
		wait until clk = '1';
		wait until clk = '1';
		
		
		


		wait for 50 ns;
		tb_finished <= true;
		wait;
	end process STIMULI;

end architecture bench;

-------------------------------------------------------------------------------

configuration d_FSM_Menu_tb_bench_cfg of FSM_Menu_tb is
	for bench
	end for;
end d_FSM_Menu_tb_bench_cfg;

-------------------------------------------------------------------------------

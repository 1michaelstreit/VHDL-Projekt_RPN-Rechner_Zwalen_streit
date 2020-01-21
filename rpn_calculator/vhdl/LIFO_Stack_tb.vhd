library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity lifo_stack_tb is

end entity lifo_stack_tb;

-------------------------------------------------------------------------------

architecture bench of lifo_stack_tb is
	-- component ports
	signal clk,rst : std_logic := '0';
	signal s_data_reg,s_data_stack :std_logic_vector(11 downto 0):=(others => '0');
	signal PUSH,POP	: std_logic :='0';
	signal stack_full, stack_empty : std_logic := '0';
	signal SP_debugg :integer;

	signal tb_finished : boolean := false;


begin  -- architecture bench

	ADD: entity work.stack
		port map (
			Clk => clk, Reset => rst,
			Data_In => s_data_reg,
			PUSH => PUSH,
			POP => POP, -- input
			Data_Out => s_data_stack,
			Stack_Full => stack_full,
			Stack_Empty => stack_empty,
			SP_debugg => SP_debugg); --output

	-- clock generation
	clk <= not clk after 10 ns when not tb_finished else
         '0';

	STIMULI: process
	begin
		wait until clk = '1';
		wait until clk = '1';
		wait until clk = '1';
		s_data_reg <= "000000000001";
		wait until clk = '1';
		PUSH <= '1';
		wait until clk = '1';
		PUSH <= '0';
		wait until clk = '1';
		s_data_reg <= "100000000010";
		wait until clk = '1';
		PUSH <= '1';
		wait until clk = '1';
		Push <= '0';
		s_data_reg <= "100000000011";
		wait until clk = '1';
		PUSH <= '1';
		wait until clk = '1';
		Push <= '0';
		s_data_reg <= "100000000100";
		wait until clk = '1';
		PUSH <= '1';
		wait until clk = '1';
		Push <= '0';
		wait until clk = '1';
		POP <= '1';
		wait until clk = '1';
		POP <= '0';
		wait until clk = '1';
		POP <= '1';
		wait until clk = '1';
		POP <= '0';
		wait until clk = '1';
		POP <= '1';
		wait until clk = '1';
		POP <= '0';
		wait until clk = '1';
		POP <= '1';
		wait until clk = '1';
		POP <= '0';
		wait until clk = '1';

		wait for 50 ns;
		tb_finished <= true;
		wait;
	end process STIMULI;

end architecture bench;

-------------------------------------------------------------------------------

configuration d_stack_tb_bench_cfg of lifo_stack_tb is
	for bench
	end for;
end d_stack_tb_bench_cfg;

-------------------------------------------------------------------------------

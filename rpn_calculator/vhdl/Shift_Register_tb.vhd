library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity Shift_Register_tb is

end entity Shift_Register_tb;

-------------------------------------------------------------------------------

architecture bench of Shift_Register_tb is
	-- component ports
	signal clk,rst : std_logic := '0';
	signal s_Res_en, s_Reg_en : std_logic;
	signal s_data_result, s_data_reg : std_logic_vector(11 downto 0);
	signal s_data_in_button : std_logic_vector(3 downto 0):= (others => '0');
	

	signal tb_finished : boolean := false;


begin  -- architecture bench

	ADD: entity work.Shift_Register
		generic map(
			NBIT => 11
		)
		port map (
			s_shift_en => s_Reg_en,
			s_forward_en => s_Res_en,
			clk => clk,
			rst => rst,
			data_in_7Seg => s_data_in_button,
			data_in_Result => s_data_result, 
			data_out => s_data_reg);

	-- clock generation
	clk <= not clk after 10 ns when not tb_finished else
         '0';

	STIMULI: process
	begin
		wait until clk = '1';
		rst <= '1';
		wait until clk = '1';
		s_data_in_button <= x"5";
		s_Reg_en <= '1';
		wait until clk = '1';



		wait for 50 ns;
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

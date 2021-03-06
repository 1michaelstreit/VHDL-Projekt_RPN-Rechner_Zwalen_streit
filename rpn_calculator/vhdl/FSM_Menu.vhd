-------------------------------------------------------------------------------
-- Filename 	: FSM_Menu.vhd
-- Title    	: FSM Menu 
-- Author   	: Michael Streit
-- Date     	: 20.01.2020
-- Projectname	: VHDL-Projekt_RPN-Rechner_Zwahlen_Streit
-- Notes		: Steuert den gesammten Rechner konnte mit der Hardware nicht
--				getestet werden, weil das anzeigen nicht funktioniert
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM_Menu is
	Generic(
		NBIT : positive := 12);
	port(
		clk,rst 			: in std_logic;
		strobe_newButton 	: in std_logic;
		data_in_button		: in std_logic_vector(3 downto 0);
		data_out			: out std_logic_vector(NBIT-1 downto 0);
		error				: out std_logic := '0'
	);
end entity FSM_Menu;

architecture RTL of FSM_Menu is
	type state_type is (S_Idle, S_Addition, S_Subtraction, S_Multiplication, S_Division, S_ChangeSign, S_Stack, S_Register);
	signal state_next, state_reg	: state_type;
	signal stack_full, stack_empty	: std_logic;
	signal PUSH, POP, s_error, s_new_number_input	:std_logic;
	signal SP_debugg : integer;
	signal s_data_stack, s_data_result, s_data_reg : std_logic_vector(NBIT-1 downto 0);
	signal s_add_en, s_sub_en, s_Mul_en, s_Div_en, s_shift_en, s_forward_en, s_Stack_en :std_logic;
begin

	REG: process(clk, rst) is
	begin
		if rst = '1' then -- reset
			state_reg <= S_Idle;
			--state_next <= S_Idle;
			--data_out <= (others =>'0');
			PUSH <= '0';
			POP <= '0';
			s_error <= '0';
			s_new_number_input <= '0';
			error <= '0';
			s_data_stack <= (others => '0');
			s_data_result <= (others => '0');
			s_data_reg <= (others => '0');
			s_add_en <= '0';
			s_sub_en <= '0';
			s_Mul_en <= '0';
			s_Div_en <= '0';
			s_shift_en <= '0';
			s_forward_en <= '0';
			s_Stack_en <= '0';
			
		elsif rising_edge(clk) then
			state_reg <= state_next;
		end if;
	end process REG;

	NSL: process(strobe_newButton, data_in_button, state_reg)
	begin
		state_next <= state_reg;

		case(state_reg) is
			when S_Idle =>
				if strobe_newButton ='1' and data_in_button < x"A" then
					state_next <= S_Register;
					s_shift_en <= '1';
					s_new_number_input <= '0';
				else 
					s_new_number_input <= '1';
				end if;

				if strobe_newButton ='1' and data_in_button = x"A" then
					state_next <= S_Addition;
					s_add_en <= '1';
					POP <= '1';

				end if;

				if strobe_newButton ='1' and data_in_button = x"B" then
					state_next <= S_Subtraction;
					s_sub_en <= '1';
				end if;

				if strobe_newButton ='1' and data_in_button = x"C" then
					state_next <= S_Multiplication;
					s_Mul_en <= '1';
				end if;

				if strobe_newButton ='1' and data_in_button = x"D" then
					state_next <= S_Division;
					s_Div_en <= '1';
				end if;

				if strobe_newButton ='1' and data_in_button = x"E" then
					state_next <= S_Stack;
					s_Stack_en <= '1';
					PUSH <= '1';
				end if;

				if strobe_newButton ='1' and data_in_button = x"F" then
					state_next <= S_ChangeSign;
				end if;
				null;

			when S_Addition =>
				state_next <= S_Register;
				s_forward_en <= '1';
				s_add_en <= '0';
				s_shift_en <= '1';
				null;
			when S_Subtraction =>
				state_next <= S_Register;
				s_forward_en <= '1';
				s_sub_en <= '0';
				null;
			when S_Multiplication =>
				state_next <= S_Register;
				s_forward_en <= '1';
				s_Mul_en <= '0';
				null;
			when S_Division =>
				state_next <= S_Register;
				s_forward_en <= '1';
				s_Div_en <= '0';
				null;
			when S_ChangeSign =>
				state_next <= S_Register;
				s_forward_en <= '1';
				null;
			when S_Stack =>
				state_next <= S_Idle;
				s_Stack_en <= '0';
				PUSH <= '0';
				null;
				
			when S_Register =>
				state_next <= S_Idle;
				s_forward_en <= '0';
				s_shift_en <= '0';
				null;

		end case;
	end process NSL;
	
	Adder : entity work.Adder
		generic map(
			NBIT => NBIT
		)
		port map(
			en => s_add_en,
			a => s_data_stack,
			b => s_data_reg,
			c => s_data_result);

	Subtractor : entity work.Subtractor
		generic map(
			NBIT => NBIT
		)
		port map(
			en => s_sub_en,
			a => s_data_stack,
			b => s_data_reg,
			c => s_data_result);

	Multiplier : entity work.Multiplier
		generic map(
			NBIT => NBIT
		)
		port map(
			en => s_Mul_en,
			a => s_data_stack,
			b => s_data_reg,
			c => s_data_result);
			
	Divider : entity work.Divider
		generic map(
			NBIT => NBIT
		)
		port map(
			
			en => s_Div_en,
			a => s_data_stack,
			b => s_data_reg,
			errorsig => error,
			c => s_data_result);
	

	Shift_Register : entity work.Shift_Register
		generic map(
			NBIT => NBIT
		)
		port map(
			clk => clk,
			rst => rst,
			New_Number_Input => s_new_number_input,
			s_forward_en => s_forward_en,
			s_shift_en => s_shift_en,
			data_in_button => data_in_button,
			data_in_Result => s_data_result,
			data_out => s_data_reg);


	Stack : entity work.stack
		generic map(
			DEPTH => 10,
			WIDTHE => NBIT
		)
		port map (
			Clk => clk,
			Reset => rst,
			Enable => s_Stack_en,
			Data_In => s_data_reg,
			PUSH => PUSH,
			POP => POP, -- input
			Data_Out => s_data_stack,
			Stack_Full => stack_full,
			Stack_Empty => stack_empty,
			SP_debugg => SP_debugg); --output
		

	
	
	OL :
	--s_data_result(NBIT-1) 	<= s_data_reg(NBIT-1) XOR '1' when state_reg = S_ChangeSign;	
		
	data_out	<= s_data_reg;

	error 		<= s_error when state_reg = S_Division;
	


end architecture RTL;

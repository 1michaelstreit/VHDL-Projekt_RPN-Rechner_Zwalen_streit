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
	signal PUSH, POP, s_error	:std_logic;
	signal s_data_stack, s_data_out, s_data_result, s_data_in_button, s_data_reg : std_logic_vector(NBIT-1 downto 0);
begin

	REG: process(clk, rst) is
	begin
		if rst = '1' then
			state_reg <= S_Idle;
			data_out <= (others =>'0');
			PUSH <= '0';
			POP <= '0';
			error <= '0';
		elsif rising_edge(clk) then
			state_reg <= state_next;
		end if;
	end process REG;

	NSL: process(strobe_newButton, data_in_button)
	begin
		state_next <= state_reg;

		case(state_reg) is
			when S_Idle =>
				if strobe_newButton ='1' and data_in_button < x"A" then
					state_next <= S_Register;
				end if;

				if strobe_newButton ='1' and data_in_button = x"A" then
					state_next <= S_Addition;
				end if;

				if strobe_newButton ='1' and data_in_button = x"B" then
					state_next <= S_Subtraction;
				end if;

				if strobe_newButton ='1' and data_in_button = x"C" then
					state_next <= S_Multiplication;
				end if;

				if strobe_newButton ='1' and data_in_button = x"D" then
					state_next <= S_Division;
				end if;

				if strobe_newButton ='1' and data_in_button = x"E" then
					state_next <= S_Stack;
				end if;

				if strobe_newButton ='1' and data_in_button = x"F" then
					state_next <= S_ChangeSign;
				end if;
				null;

			when S_Addition =>
				state_next <= S_Idle;
				null;
			when S_Subtraction =>
				state_next <= S_Idle;
				null;
			when S_Multiplication =>
				state_next <= S_Idle;
				null;
			when S_Division =>
				state_next <= S_Idle;
				null;
			when S_ChangeSign =>
				state_next <= S_Idle;
				null;
			when S_Stack =>
				state_next <= S_Idle;
				null;
			when S_Register =>
				state_next <= S_Idle;
				null;
			/*when S_SignMagnitude =>
				state_next <= S_Idle;
				null;*/

		end case;
	end process NSL;
	
	Adder : entity work.Adder
		port map(
			a => s_data_stack,
			b => s_data_reg,
			c => s_data_result);
			
	Subtractor : entity work.Subtractor
		port map(
			a => s_data_stack,
			b => s_data_reg,
			c => s_data_result);
	

	Shift_Register : entity work.Shift_Register
		port map(
			clk => clk, 
			rst => rst, 
			data_in => data_in_button, 
			data_out => s_data_reg);
	/*Signed_Magnitude : entity work.Signed_Magnitude
		port map(
 			data_reg => s_data_reg,
			data_signedMagnitude => s_data_sigMag);*/
			
	Stack : entity work.stack
		generic map(
			DEPTH => 9,
			WIDTHE => 12
		)
		port map (
			Clk => clk, Reset => rst, 
			Data_In => data_out, 
			PUSH => PUSH, 
			POP => POP, -- input
			Data_Out => s_data_stack, 
			Stack_Full => stack_full, 
			Stack_Empty => stack_empty); --output
		

	
	
	OL :
		
	data_out	<= s_data_out when state_reg = S_Idle;
	
	data_out	<= s_data_stack when state_reg = S_Stack; 

	error 		<= s_error when state_reg = S_Division;
	


end architecture RTL;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM_Menu is
	port(
		clk,rst 			: in std_logic;
		strobe_newButton 	: in std_logic;
		value				: in std_logic_vector(3 downto 0)
		
	);
end entity FSM_Menu;

architecture RTL of FSM_Menu is
	type state_type is (S_Idle, S_Addition, S_Subtraction, S_Multiplication, S_Division, S_ChangeSign, S_Stack,S_SignMagnitude, S_Register);
	signal state_next, state_reg	: state_type;
begin

	REG: process(clk, rst) is
	begin
		if rst = '1' then
			state_reg <= S_Idle;
		elsif rising_edge(clk) then
			state_reg <= state_next;
		end if;
	end process REG;

	NSL: process(strobe_newButton, value)
	begin
		state_next <= state_reg;

		case(state_reg) is
			when S_Idle =>
				if strobe_newButton ='1' and value < x"A" then
					state_next <= S_Register;
				end if;

				if strobe_newButton ='1' and value = x"A" then
					state_next <= S_Addition;
				end if;

				if strobe_newButton ='1' and value = x"B" then
					state_next <= S_Subtraction;
				end if;

				if strobe_newButton ='1' and value = x"C" then
					state_next <= S_Multiplication;
				end if;

				if strobe_newButton ='1' and value = x"D" then
					state_next <= S_Division;
				end if;

				if strobe_newButton ='1' and value = x"E" then
					state_next <= S_Stack;
				end if;

				if strobe_newButton ='1' and value = x"F" then
					state_next <= S_ChangeSign;
				end if;
				null;

			when S_Addition =>
				state_next <= S_SignMagnitude;
				null;
			when S_Subtraction =>
				state_next <= S_SignMagnitude;
				null;
			when S_Multiplication =>
				state_next <= S_SignMagnitude;
				null;
			when S_Division =>
				state_next <= S_SignMagnitude;
				null;
			when S_ChangeSign =>
				state_next <= S_SignMagnitude;
				null;
			when S_Stack =>
				state_next <= S_SignMagnitude;
				null;
			when S_Register =>
				state_next <= S_SignMagnitude;
				null;
			when S_SignMagnitude =>
				state_next <= S_Idle;
				null;

		end case;
	end process NSL;


end architecture RTL;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stack is
	generic (
		DEPTH : positive := 9;
		WIDTHE : positive := 12);
	port(   Clk : in std_logic;  --Clock for the stack.
	     Reset : in std_logic; --active high reset.    
	     Data_In : in std_logic_vector(WIDTHE-1 downto 0);  --Data to be pushed to stack (
	     PUSH	: in std_logic;
	     POP	: in std_logic;
	     Data_Out : out std_logic_vector(WIDTHE-1 downto 0);  --Data popped from the stack.  
	     Stack_Full : out std_logic;  --Goes high when the stack is full.
	     Stack_Empty : out std_logic;  --Goes high when the stack is empty.
	     SP_debugg : out integer
	    );
end stack;

architecture Behavioral of stack is

	type mem_type is array (0 to DEPTH) of std_logic_vector(WIDTHE-1 downto 0);
	signal stack_mem : mem_type := (others => (others => '0'));
	signal POP_PUSH_indicator : std_logic := '0'; --active low for POP and active high for PUSH.
	signal Enable : std_logic;  --Enable the stack. Otherwise neither push nor pop will happen.
	signal full,empty : std_logic := '0';
	signal prev_PP : std_logic := '0';
	signal s_push : std_logic := '1';
	signal s_pop : std_logic := '0';	
	signal SP : integer := 0;  --for simulation and debugging. 

begin

	Stack_Full <= full;
	Stack_Empty <= empty;

	--PUSH and POP process for the stack.
	P_PUSH : process(Clk,Reset)
		variable stack_ptr : integer := DEPTH;
	begin
		if(Reset = '1') then
			stack_ptr := DEPTH;  --stack grows downwards.
			full <= '0';
			empty <= '0';
			Data_Out <= (others => '0');
			prev_PP <= '0';
		elsif(rising_edge(Clk)) then

			if PUSH = '1' then
				POP_PUSH_indicator <= s_push;
				Enable <= '1';
			elsif POP = '1' then
				POP_PUSH_indicator <= s_pop;
				Enable <= '1';
			else 
				Enable <= '0';
			end if;
     	
     
          if(Enable = '1') then
				prev_PP <= POP_PUSH_indicator;
			else
				prev_PP <= '0';
			end if;
			--POP section.
			if (Enable = '1' and POP_PUSH_indicator = s_pop and empty = '0') then
				--setting empty flag.           
				if(stack_ptr = DEPTH) then
					full <= '0';
					empty <= '1';
				else
					full <= '0';
					empty <= '0';
				end if;
				--when the push becomes pop, before stack is full. 
				if(prev_PP = s_push and full = '0') then
					stack_ptr := stack_ptr + 1;
				end if;
				--Data has to be taken from the next highest address(empty descending type stack).              
				Data_Out <= stack_mem(stack_ptr);
				if(stack_ptr /= DEPTH) then
					stack_ptr := stack_ptr + 1;
				end if;
			end if;

			--PUSH section.
			if (Enable = '1' and POP_PUSH_indicator = s_push and full = '0') then
				--setting full flag.
				if(stack_ptr = 0) then
					full <= '1';
					empty <= '0';
				else
					full <= '0';
					empty <= '0';
				end if;
				--when the pop becomes push, before stack is empty.
				if(prev_PP = s_pop and empty = '0') then
					stack_ptr := stack_ptr - 1;
				end if;
				--Data pushed to the current address.       
				stack_mem(stack_ptr) <= Data_In;
				if(stack_ptr /= 0) then
					stack_ptr := stack_ptr - 1;
				end if;
			end if;
			SP <= stack_ptr;  --for debugging/simulation.
			SP_debugg <= SP; 
		end if;
	end process;

end Behavioral;
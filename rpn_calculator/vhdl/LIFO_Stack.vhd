-------------------------------------------------------------------------------
-- Filename 	: LIFO_Stack.vhd
-- Title    	: LIFO Stack
-- Author   	: Michael Streit
-- Date     	: 20.01.2020
-- Projectname	: VHDL-Projekt_RPN-Rechner_Zwahlen_Streit
-- Notes		: Wert kann mit Push im Stack gespeichert werden und mit Pop
--				zur�ck geholt werden. Es wird induziert ob der Stack voll oder
--				leer ist. Die Breite ist 12 und es k�nnen 10 Werte gespeichert 
--				werden. Die LED anzeige konnte nicht realisert werden, da die
--				Anzeige nicht funktioniert
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stack is
	generic (
		DEPTH : positive := 10;
		WIDTHE : positive := 12);
	port(   Clk : in std_logic;  --Clock for the stack.
	     Reset : in std_logic; --active high reset.    
	     Enable : in std_logic;  --Enable the stack. Otherwise neither push nor pop will happen.
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
			SP <= 0;
			full <= '0';
			empty <= '0';
			Data_Out <= (others => '0');
			prev_PP <= '0';
		elsif(rising_edge(Clk)) then
     
			if(Enable = '1') then
				if(PUSH = '1') then
					prev_PP <= '1';
				end if;
				if(POP = '1') then
					prev_PP <= '0';
				end if;
			else
				prev_PP <= '0';
			end if;
			
			--POP section.
			if (Enable = '1' and POP = '1' and empty = '0') then
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
			if (Enable = '1' and PUSH = '1' and full = '0') then
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
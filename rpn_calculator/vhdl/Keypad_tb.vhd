-------------------------------------------------------------------------------
-- Filename 	: Keypad_tb.vhd
-- Title    	: Keypad Testbench 
-- Author   	: Patrick Zwahlen
-- Date     	: 20.01.2020
-- Projectname	: VHDL-Projekt_RPN-Rechner_Zwahlen_Streit
-- Notes		: The waiting periods inbetween the loops are used to skip 
--				  the colums befor, but it only works once and repeats column 1
--				  in other cases.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Keypad_tb is


end Keypad_tb;

architecture bench of Keypad_tb is
    -- component ports
    signal input, output, res       : std_logic_vector(3 downto 0);
    signal press            : std_logic;
    signal clk              : std_logic := '0';
    signal rst_b            : std_logic;

    -- stimuli constants
    constant CLK_PERIOD : time := 0.01 sec;
    signal tb_done : boolean := false;
begin  -- architecture bench

    -- component instantiation
    DUT: entity work.Keypad(rtl)

    port map (
        row => input,
		col => output,
        output_value(3 downto 0) => res,
        output_value(4) => press,
        clk => clk,
        por => rst_b);

    -- clock and reset generation
    clk <= not clk after 0.5 * CLK_PERIOD when not tb_done else
         '0';

    rst_b <= '0',
           '1' after 0.25 * CLK_PERIOD,
           '0' after 1.75 * CLK_PERIOD;

    TEST: process
    begin                
        
		input <= "1111";
		-- wait for first clock
		wait for 0.5 * CLK_PERIOD;

		-- test column1
        for i in 0 to 3 loop            
			input(i) <= '0';
			-- wait for end of FSM
			wait for 10 * CLK_PERIOD;                
            input <= "1111";
        end loop;
		
		-- wait to skip the first column
		wait for 4 * CLK_PERIOD;
		
		-- test column2
		for i in 0 to 3 loop       		
			input(i) <= '0';	
			-- wait for end of FSM		
			wait for 8 * CLK_PERIOD;                
            input <= "1111";	
			-- wait to skip the first column		
			wait for 2 * CLK_PERIOD;
        end loop;
		
		-- wait to skip the columns 1 and 2
		wait for 2 * CLK_PERIOD;

		-- test column3
        for i in 0 to 3 loop            
			input(i) <= '0';		
			-- wait for end of FSM	
			wait for 6 * CLK_PERIOD;                
            input <= "1111";
			-- wait to skip the columns 1 and 2			
			wait for 4 * CLK_PERIOD;
        end loop;
		
		-- wait to skip the columns 1, 2 and 3
		wait for 2 * CLK_PERIOD;

		-- test column4
        for i in 0 to 3 loop            
			input(i) <= '0';	
			-- wait for end of FSM		
			wait for 4 * CLK_PERIOD;                
            input <= "1111";
			-- wait to skip the columns 1, 2 and 3			
			wait for 6 * CLK_PERIOD;
        end loop;
		
		-- wait for last value
		wait for 10 * CLK_PERIOD;

        -- and so on
        tb_done <= true;
        wait;
    end process TEST;

end architecture bench;

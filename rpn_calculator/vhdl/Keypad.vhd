-------------------------------------------------------------------------------
-- Filename 	: Keypad.vhd
-- Title    	: Read PmodKYPD keypad 
-- Author   	: Patrick Zwahlen
-- Date     	: 30.12.2019
-- Projectname	: VHDL-Projekt_RPN-Rechner_Zwahlen_Streit
-- Notes		:
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity keypad is
    port (
        clk, por		: in  std_logic;
        row			    : in  std_logic_vector(3 downto 0);
        col				: out  std_logic_vector(3 downto 0);
		output_value	: out std_logic_vector(4 downto 0));
		
end entity keypad;

architecture rtl of keypad is
	type states is (INIT, INIT_COL1, INIT_COL2, INIT_COL3, INIT_COL4, 
		READ_COL1, READ_COL2, READ_COL3, READ_COL4, DATA_OUT);			-- FSM states
	signal r_row					: std_logic_vector (3 downto 0);
	signal state_reg, state_next	: states;
	signal value					: std_logic_vector(3 downto 0);
	signal strobe					: std_logic;
	signal selection				: std_logic_vector(3 downto 0);
	
begin
  REG: process (clk, por) is
  begin  -- process REG
    if por = '1' then                 									-- asynchronous reset when active high
      state_reg <= INIT;
    elsif clk'event and clk = '1' then  								-- rising edge clock
      state_reg <= state_next;
    end if;
  end process REG;
 
 -- Next state logic for the FSM
  NSL: process (state_reg, r_row, row, strobe) is
  begin  -- process NSL
  	-- state_next <= state_reg;
  	case state_reg is
  	when INIT =>
  		strobe <= '0';
  		col <= "1111";
  		state_next <= INIT_COL1;
  	when INIT_COL1 =>
  		col <= "1110";
  		r_row <= "1111";
  		state_next <= READ_COL1;
  	when READ_COL1 =>
  		r_row <= row;
  		case r_row is
  			when "1110" =>
      			value <= x"1";
				strobe <= '1';
  			when "1101" =>
				value <= x"4";
				strobe <= '1';
			when "1011" =>
				value <= x"7";
				strobe <= '1';
			when "0111" =>
				value <= x"0";
				strobe <= '1';
			when others => null;
		end case;
  		state_next <= INIT_COL2;
  	when INIT_COL2 =>
  		col <= "1101";
  		state_next <= READ_COL2;
  	when READ_COL2 =>
  		r_row <= row;
  		r_row <= "1111";
  		if strobe = '0' then
	  		case r_row is
  				when "1110" =>
					value <= x"2";
					strobe <= '1';
	  			when "1101" =>
					value <= x"5";
					strobe <= '1';
  				when "1011" =>
					value <= x"8";
					strobe <= '1';
  				when "0111"  =>
					value <= x"F";
					strobe <= '1';
				when others => null;
			end case;
		end if;
  		state_next <= INIT_COL3;
  	when INIT_COL3 =>
  		col <= "1011";
  		r_row <= "1111";
  		state_next <= READ_COL3;
  	when READ_COL3 =>
  		r_row <= row;
  		if strobe = '0' then
    		case r_row is
  				when "1110" =>
					value <= x"3";
					strobe <= '1';
  				when "1101" =>
					value <= x"6";
					strobe <= '1';
  				when "1011" =>
					value <= x"9";
					strobe <= '1';
  				when "0111" =>
					value <= x"E";
					strobe <= '1';
				when others => null;
			end case;
		end if;
  		state_next <= INIT_COL4;
  	when INIT_COL4 =>
  		col <= "0111";
  		r_row <= "1111";
  		state_next <= READ_COL4;
  	when READ_COL4 =>
  		r_row <= row;
  		if strobe = '0' then
    		case r_row is
  				when "1110" =>
					value <= x"A";
					strobe <= '1';
  				when "1101" =>
					value <= x"B";
					strobe <= '1';
  				when "1011" =>
					value <= x"C";
					strobe <= '1';
  				when "0111" =>
					value <= x"D";
					strobe <= '1';
				when others => null;
			end case;
		end if;
		state_next <= DATA_OUT;
	when DATA_OUT =>
  		state_next <= INIT;  		
  	end case;

  end process NSL;

-- Output logic of the FSM
  OL: process (state_reg, strobe, value) is
  begin  -- process
  	case state_reg is
  		when DATA_OUT =>
      		output_value(3 downto 0) <= value;
			output_value(4) <= strobe;
		when others => output_value(4) <= '0';
    end case;
  end process OL;
end architecture rtl;

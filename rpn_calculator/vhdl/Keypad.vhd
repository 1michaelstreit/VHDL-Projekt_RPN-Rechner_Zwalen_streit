-------------------------------------------------------------------------------
-- Filename 	: Keypad.vhd
-- Title    	: Read PmodKYPD keypad 
-- Author   	: Patrick Zwahlen
-- Date     	: 30.12.2019
-- Projectname	: VHDL-Projekt_RPN-Rechner_Zwahlen_Streit
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity keypad is
    port (
        clk, por		: in  std_logic;
		column			: out std_logic_vector(3 downto 0);
        buttons		    : in  std_logic_vector(3 downto 0);
        strobe          : out std_logic;
		value			: out std_logic_vector(3 downto 0));
end entity keypad;

architecture rtl of keypad is
	type states is (INIT, INIT_COL1, INIT_COL2, INIT_COL3, INIT_COL4, 
		READ_COL1, READ_COL2, READ_COL3, READ_COL4, DATA_OUT);
	signal r_column					: integer;
	signal r_value					: std_logic_vector (3 downto 0);
	signal state_reg, state_next	: states;  -- state register
	signal value_out				: std_logic_vector(3 downto 0);
	signal strobe_buffer			: std_logic;
	
begin
  REG: process (clk, por) is
  begin  -- process REG
    if por = '1' then                 -- asynchronous reset when active high
      state_reg <= INIT;
    elsif clk'event and clk = '1' then  -- rising edge clock
      state_reg <= state_next;
    end if;
  end process REG;
 
 -- Next state logic for the FSM
  NSL: process (state_reg) is
  begin  -- process NSL
  	state_next <= state_reg;
  	case state_reg is
  	when INIT =>
  		state_next <= INIT_COL1;
  	when INIT_COL1 =>
  		state_next <= READ_COL1;
  	when READ_COL1 =>
  		state_next <= INIT_COL2;
  	when INIT_COL2 =>
  		state_next <= READ_COL2;
  	when READ_COL2 =>
  		state_next <= INIT_COL3;
  	when INIT_COL3 =>
  		state_next <= READ_COL3;
  	when READ_COL3 =>
  		state_next <= INIT_COL4;
  	when INIT_COL4 =>
  		state_next <= READ_COL4;
  	when READ_COL4 =>
  		state_next <= DATA_OUT;
  	when DATA_OUT =>
  		state_next <= INIT;  		
  	end case;
  		
  		
--  	if state_reg then
--  	column_loop : 
--  		for i in 3 downto 0 loop
--  			if button /= "1111" then
--  				r_column <= i;
--  				r_value <= button;
--  				exit column_loop;
--  			end if;
--  		end loop;
--  	end if;

  end process NSL;

-- Output logic of the FSM
  OL: process (state_reg, r_value) is
  begin  -- process
    strobe_buffer  <= '0';
    value_out <= x"0";
    r_value <= "1111";
    case state_reg is
      when INIT =>
		strobe_buffer  <= '0';
      when INIT_COL1 =>
    	r_value <= buttons;
      when READ_COL1 =>
    	if r_value = "0111" then
    		value_out	<= x"1";
		elsif r_value = "1011" then
			value_out	<= x"4";
		elsif r_value = "1101" then
			value_out	<= x"7";
		elsif r_value = "1110" then
			value_out	<= x"0";
		end if;
		if r_value /= "1111" and strobe_buffer = '0' then
			strobe_buffer <= '1';
		else strobe <= '0';
		end if;
      when INIT_COL2 =>
    	r_value <= buttons;
      when READ_COL2 =>
		if r_value = "0111" then
			value_out	<= x"2";
		elsif r_value = "1011" then
			value_out	<= x"5";
		elsif r_value = "1101" then
			value_out	<= x"8";
		elsif r_value = "1110" then
			value_out	<= x"F";
		end if;
		if r_value /= "1111" and strobe_buffer = '0' then
			strobe_buffer <= '1';
		else strobe_buffer <= '0';
		end if;
      when INIT_COL3 =>
    	r_value <= buttons;
      when READ_COL3 =>
		if r_value = "0111" then
			value_out	<= x"3";
		elsif r_value = "1011" then
			value_out	<= x"6";
		elsif r_value = "1101" then
			value_out	<= x"9";
		elsif r_value = "1110" then
			value_out	<= x"E";
		end if;
		if r_value /= "1111" and strobe_buffer = '0' then
			strobe_buffer <= '1';
		else strobe_buffer <= '0';
		end if;
      when INIT_COL4 =>
    	r_value <= buttons;
      when READ_COL4 =>
		if r_value = "0111" then
			value_out	<= x"A";
		elsif r_value = "1011" then
			value_out	<= x"B";
		elsif r_value = "1101" then
			value_out	<= x"C";
		elsif r_value = "1110" then
			value_out	<= x"D";
		end if;
		if r_value /= "1111" and strobe_buffer = '0' then
			strobe_buffer <= '1';
		else strobe_buffer <= '0';
		end if;
	  when DATA_OUT =>
		if strobe_buffer = '1' then
			value <= value_out;
		end if;
      when others => null;
    end case;
    strobe <= strobe_buffer;
	value <= value_out;
  end process OL;
end architecture rtl;

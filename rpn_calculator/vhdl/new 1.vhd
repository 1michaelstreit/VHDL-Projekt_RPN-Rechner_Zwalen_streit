library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity read_keypad is
    port (
        key_row         : in  std_logic_vector(3 downto 0);
        clk, por		: in  std_logic;
		key_col			: out std_logic_vector(3 downto 0);
        strobe          : out std_logic;
		v_out			: out std_logic_vector(3 downto 0));
end read_keypad;

architecture rtl of read_keypad is
    type states is (S_COL1, S_COL2, S_COL3, S_COL4,
					S_ROW1, S_ROW2, S_ROW3, S_ROW4,
					S_INIT, S_DOUT);
	signal state_reg, state_next : states;  -- state register
	signal key_current, key_next : std_logic_vector(4 downto 0);
	signal key, dout			 : std_logic_vector(3 downto 0);
	signal press_key 			 : std_logic_vector(4 downto 0);
	
begin
  -- purpose: state register
  -- type   : sequential
  -- inputs : clk, rst_b, state_next
  -- outputs: state_reg
  
  REG: process (clk, por) is
  begin  -- process REG
    if por = '1' then                 -- asynchronous reset (active high)
      state_reg <= S_INIT;
    elsif clk'event and clk = '1' then  -- rising clock edge
      state_reg <= state_next;
	  if key_next(4) = '1' then
		key_current <= key_next;
	  end if;
    end if;
  end process REG;
 
 -- purpose: next state logic
  -- type   : combinational
  -- inputs : state_reg
  -- outputs: state_next
  NSL: process (state_reg) is
  begin  -- process NSL
    state_next <= state_reg;
	--key_next <= "00000";
    case state_reg is
      when S_INIT =>
          state_next <= S_COL1;
		  
      when S_COL1 =>
          state_next <= S_ROW1;
		  
      when S_ROW1 =>
		key(0) <= '1';
		case key_row is
			when "0111" =>
				key_next <= '1' & x"1"; 
			when "1011" =>
				key_next <= '1' & x"2"; 
			when "1101" =>
				key_next <= '1' & x"3"; 
			when "1110" =>
				key_next <= '1' & x"A"; 
			when others =>
				key(0) <= '0';
		end case;
		state_next <= S_COL2;
		
      when S_COL2 =>
          state_next <= S_ROW2;
		  
      when S_ROW2 =>
		key(1) <= '1';
		case key_row is
			when "0111" =>
				key_next <= '1' & x"4"; 
			when "1011" =>
				key_next <= '1' & x"5"; 
			when "1101" =>
				key_next <= '1' & x"6"; 
			when "1110" =>
				key_next <= '1' & x"B"; 
			when others =>
			key(1) <= '0';
		end case;
		state_next <= S_COL3;
		
      when S_COL3 =>
          state_next <= S_ROW3;
		  
      when S_ROW3 =>
		key(2) <= '1';
		case key_row is
			when "0111" =>
				key_next <= '1' & x"7"; 
			when "1011" =>
				key_next <= '1' & x"8"; 
			when "1101" =>
				key_next <= '1' & x"9"; 
			when "1110" =>
				key_next <= '1' & x"C";
			when others =>
			key(2) <= '0';
		end case;
		state_next <= S_COL4;
		
      when S_COL4 =>
          state_next <= S_ROW4;
		  
      when S_ROW4 =>
		key(3) <= '1';
		case key_row is
			when "0111" =>
				key_next <= '1' & x"0"; 
			when "1011" =>
				key_next <= '1' & x"E"; 
			when "1101" =>
				key_next <= '1' & x"F"; 
			when "1110" =>
				key_next <= '1' & x"D"; 
			when others =>
			key(3) <= '0';
		end case;
			state_next <= S_DOUT;
			
      when S_DOUT =>
		state_next <= S_INIT;
		if key = "0000" then
			key_next <= "00000";
		end if;
      when others => null;
    end case;
  end process NSL;
  
  
  -- purpose: output logic
  -- type   : combinational
  -- inputs : state_reg, key_row
  -- outputs: key_col, strobe, v_out
  OL: process (state_reg, key_row) is
  begin  -- process
    case state_reg is
      when S_INIT =>
		dout	<= "0000";
      when S_COL1 =>
        key_col <= "0111";
      when S_COL2 => 
        key_col <= "1011";
      when S_COL3 =>
        key_col <= "1101";
      when S_COL4 =>
        key_col <= "1110";
      when S_DOUT =>
		--if key = "0000" then
			--key_next <= "0000";
		--end if;
		
      when others => null;
    end case;
  end process OL;	
 
	v_out <= key_current(3 downto 0);
	strobe <= '1' when state_reg = S_DOUT
					and key_current(4) = '1'
					and	key_next(4) = '0'
					else '0';
		

end rtl;

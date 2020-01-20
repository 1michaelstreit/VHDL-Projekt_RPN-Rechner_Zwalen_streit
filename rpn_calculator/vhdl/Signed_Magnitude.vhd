library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Signed_Magnitude is
	port(
		data_reg : in std_logic_vector(11 downto 0);
		data_signedMagnitude : out std_logic_vector(11 downto 0)
	);
end entity Signed_Magnitude;

architecture RTL of Signed_Magnitude is
	signal s_data_out : std_logic_vector(11 downto 0);
begin
	REG:	process(data_reg, s_data_out) is
	begin
		if data_reg < x"A" then
			s_data_out(3 downto 0) <= data_reg(3 downto 0) ;
			s_data_out <= std_logic_vector(unsigned(s_data_out) + unsigned(data_reg(7 downto 4)) * 10); 
			s_data_out <= std_logic_vector(unsigned(s_data_out) + unsigned(data_reg(11 downto 8))*100); 
		end if;
	end process REG;
	
	OL :
	
	data_signedMagnitude(10 downto 0) <= s_data_out(10 downto 0);
	data_signedMagnitude(11) <= '0';
end architecture RTL;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Shift_Register is
	generic (NBIT : positive := 12);
	port(
		clk : in std_logic;
		rst : in std_logic;
		s_Res_en, s_Reg_en:in std_logic;
		data_in_7Seg :in std_logic_vector(3 downto 0);
		data_in_Result: in std_logic_vector(NBIT-1 downto 0);
		data_out : out std_logic_vector(NBIT-1 downto 0)
	);
end entity Shift_Register;

architecture RTL of Shift_Register is
	signal r0_data, r1_data, r2_data : std_logic_vector(3 downto 0);
	signal s_data_out : std_logic_vector(11 downto 0);
begin

	process(clk, rst) is
	begin
		if rst = '1' then
			r0_data <= (others => '0');
			r1_data <= (others => '0');
			r2_data <= (others => '0');
		elsif rising_edge(clk) then
			r2_data <= r1_data;
			r1_data <= r0_data;
			r0_data <= data_in_7Seg;
		end if;
			s_data_out(3 downto 0) <= r0_data ;
			s_data_out <= std_logic_vector(unsigned(s_data_out) + unsigned(r1_data) * 10); 
			s_data_out <= std_logic_vector(unsigned(s_data_out) + unsigned(r2_data)*100); 
	end process;
	
		
	OL :
	
	data_out(10 downto 0) <= s_data_out(10 downto 0) when s_Reg_en = '1';
	data_out(11) <= '0' when s_Reg_en = '1';
	
	data_out <= data_in_Result when s_Res_en = '1';

end architecture RTL;

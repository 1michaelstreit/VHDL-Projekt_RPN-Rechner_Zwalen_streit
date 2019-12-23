library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Shift_Register is
	port(
		clk : in std_logic;
		rst : in std_logic;
		data_in :in std_logic_vector(3 downto 0);
		data_out : out std_logic_vector(11 downto 0)
	);
end entity Shift_Register;

architecture RTL of Shift_Register is
	signal r0_data, r1_data, r2_data : std_logic_vector(3 downto 0);
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
			r0_data <= data_in;
		end if;
	end process;
	
	OL: data_out(11 downto 8) <= r2_data;
		data_out(7 downto 4) <= r1_data;
		data_out(3 downto 0) <= r0_data;

end architecture RTL;

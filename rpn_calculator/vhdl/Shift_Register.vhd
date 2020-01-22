-------------------------------------------------------------------------------
-- Filename 	: Shift_Register.vhd
-- Title    	: Shift Register
-- Author   	: Michael Streit
-- Date     	: 20.01.2020
-- Projectname	: VHDL-Projekt_RPN-Rechner_Zwahlen_Streit
-- Notes		: Der wert von der Tastatur wird im Register gespeichert und 
--				Weitergeschoben, wenn ein neuer erscheint. Danach wird der Wert
--				in signed Magnitude umgewandelt. Nach dem ein Ergebnis berechnet
--				wird es auch im Register data_out ausgegen. Die Ausgabe vom 
--				Register wird dann direkt an die anzeige als Signed Magnitude
--				übergeben-> Anzeige funktioniert nicht-> konnte nicht getestet
--				werden 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Shift_Register is
	generic (NBIT : positive := 12);
	port(
		clk : in std_logic;
		rst : in std_logic;
		New_Number_Input :in std_logic;
		s_forward_en, s_shift_en:in std_logic;
		data_in_button :in std_logic_vector(3 downto 0);
		data_in_Result: in std_logic_vector(NBIT-1 downto 0);
		data_out : out std_logic_vector(NBIT-1 downto 0)
	);
end entity Shift_Register;

architecture RTL of Shift_Register is
	signal r0_data, r1_data, r2_data,r0_data_next,r1_data_next,r2_data_next : std_logic_vector(3 downto 0);
begin

	REG: process(clk,rst) is
		
	begin
		if rst = '1' then
			r0_data <= (others => '0');
			r1_data <= (others => '0');
			r2_data <= (others => '0');
			r0_data_next <= (others => '0');
			r1_data_next <= (others => '0');
			r2_data_next <= (others => '0');
		elsif rising_edge(clk) then
			r0_data <= r0_data_next;
			r1_data <= r1_data_next;
			r2_data <= r2_data_next;
		end if;
	end process REG;

	NSL: process(s_shift_en, s_forward_en, data_in_button, data_in_Result, r0_data, r0_data_next, r1_data, r1_data_next, r2_data_next, New_Number_Input, r2_data)
		variable s_data_out_int : unsigned(NBIT-1 downto 0):=  (others => '0');
	begin

		if New_Number_Input = '1' then
			r0_data <= (others => '0');
			r1_data <= (others => '0');
			r2_data <= (others => '0');
		end if;

		if s_shift_en = '1' then
			r2_data_next <= r1_data;
			r1_data_next <= r0_data;
			r0_data_next <= data_in_button;
			s_data_out_int(3 downto 0) := unsigned(r0_data_next);
			s_data_out_int := s_data_out_int + (unsigned(r1_data_next) * 10);
			s_data_out_int := s_data_out_int + (unsigned(r2_data_next)*100);
			data_out <= std_logic_vector(s_data_out_int);

		end if;

		if s_forward_en = '1' then
			data_out <= data_in_Result;
		end if;
	end process NSL;
	
		
	--OL :

	--data_out <= s_data_out;


end architecture RTL;

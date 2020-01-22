-------------------------------------------------------------------------------
-- Filename 	: Adder.vhd
-- Title    	: Addierer 
-- Author   	: Michael Streit
-- Date     	: 20.01.2020
-- Projectname	: VHDL-Projekt_RPN-Rechner_Zwahlen_Streit
-- Notes		: Addiert a+b und gibt das Resultat in c aus falls en enabled
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Adder is
	generic (NBIT : positive := 12);
	port(
		en : in std_logic;
		a,b : in std_logic_vector(NBIT-1 downto 0);
		c : out std_logic_vector(NBIT-1 downto 0)
	);
end entity Adder;

architecture RTL of Adder is
	signal s_c : unsigned(NBIT-1 downto 0) := (others => '0');
	signal sign_a, sign_b : std_logic;
	signal abs_a, abs_b : std_logic_vector(NBIT-2 downto 0);
begin
	sign_a <= a(NBIT-1);
	sign_b <= b(NBIT-1);
	abs_a <= a(NBIT-2 downto 0);
	abs_b <= b(NBIT-2 downto 0);

	ADD : process (abs_a,abs_b, sign_a, sign_b, en) is
	begin
		if en = '1' then
			if sign_a = sign_b then

				s_c(NBIT-2 downto 0) <= unsigned(abs_a) + unsigned(abs_b);
				s_c(NBIT-1) <= sign_a;

			elsif abs_a >= abs_b then

				s_c(NBIT-2 downto 0) <= unsigned(abs_a) - unsigned(abs_b);

				if sign_a = '0' then
					s_c(NBIT-1) <= '0';
				else
					s_c(NBIT-1) <= '1';
				end if;
			elsif abs_a < abs_b then
				s_c(NBIT-2 downto 0) <= unsigned(abs_b) - unsigned(abs_a);

				if sign_b = '0' then
					s_c(NBIT-1) <= '0';
				else
					s_c(NBIT-1) <= '1';
				end if;
			end if;
		end if;
	end process ADD;

	
	c <= std_logic_vector(s_c) when en = '1';

end architecture RTL;

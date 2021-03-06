-------------------------------------------------------------------------------
-- Filename 	: Subtractor.vhd
-- Title    	: Subtrahierer
-- Author   	: Michael Streit
-- Date     	: 20.01.2020
-- Projectname	: VHDL-Projekt_RPN-Rechner_Zwahlen_Streit
-- Notes		: Rechnet a-b wird in c ausgegeben
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Subtractor is
	generic (NBIT : positive := 12);
	port(
		en : in std_logic;
		a,b : in std_logic_vector(NBIT-1 downto 0);
		c : out std_logic_vector(NBIT-1 downto 0)
	);
end entity Subtractor;

architecture RTL of Subtractor is
	signal s_c : unsigned(NBIT-1 downto 0) := (others => '0');
	signal sign_a, sign_b : std_logic;
begin
	sign_a <= a(NBIT-1);
	sign_b <= b(NBIT-1);

	SUB : process (a,b, sign_a, sign_b,en) is
	begin
		if en = '1' then
			if a(NBIT-2 downto 0) >= b(NBIT-2 downto 0) then
				if sign_a = '0' then
					if sign_b = '0' then
						s_c(NBIT-2 downto 0) <= unsigned(a(NBIT-2 downto 0)) - unsigned(b(NBIT-2 downto 0));
					else
						s_c(NBIT-2 downto 0) <= unsigned(a(NBIT-2 downto 0)) + unsigned(b(NBIT-2 downto 0));
					end if;
					s_c(NBIT-1) <= '0';
				else
					if sign_b = '0' then
						s_c(NBIT-2 downto 0) <= unsigned(a(NBIT-2 downto 0)) + unsigned(b(NBIT-2 downto 0));
					else
						s_c(NBIT-2 downto 0) <= unsigned(a(NBIT-2 downto 0)) - unsigned(b(NBIT-2 downto 0));
					end if;
					s_c(NBIT-1) <= '1';
				end if;
			else
				if sign_b = '0' then
					if sign_a = '0' then
						s_c(NBIT-2 downto 0) <= unsigned(b(NBIT-2 downto 0)) - unsigned(a(NBIT-2 downto 0));
					else
						s_c(NBIT-2 downto 0) <= unsigned(b(NBIT-2 downto 0)) + unsigned(a(NBIT-2 downto 0));
					end if;
					s_c(NBIT-1) <= '1';
				else
					if sign_a = '0' then
						s_c(NBIT-2 downto 0) <= unsigned(b(NBIT-2 downto 0)) + unsigned(a(NBIT-2 downto 0));
					else
						s_c(NBIT-2 downto 0) <= unsigned(b(NBIT-2 downto 0)) - unsigned(a(NBIT-2 downto 0));
					end if;
					s_c(NBIT-1) <= '0';
				end if;
			end if;
		end if;
	end process SUB;

	
	c <= std_logic_vector(s_c) when en = '1';
end architecture RTL;

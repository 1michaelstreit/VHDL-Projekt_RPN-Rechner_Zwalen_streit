library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Adder is
	generic (NBIT : positive := 12);
	port(
		a,b : in std_logic_vector(NBIT-1 downto 0);
		c : out std_logic_vector(NBIT-1 downto 0)
	);
end entity Adder;

architecture RTL of Adder is
	signal s_c : unsigned(NBIT-1 downto 0) := (others => '0');
	signal sign_a, sign_b : std_logic;
begin
	sign_a <= a(NBIT-1);
	sign_b <= b(NBIT-1);

	ADD : process (a,b, sign_a, sign_b) is
	begin
		if sign_a = sign_b then
			
			s_c(NBIT-2 downto 0) <= unsigned(a(NBIT-2 downto 0)) + unsigned(b(NBIT-2 downto 0));
			s_c(NBIT-1) <= sign_a;
			
		elsif a(NBIT-2 downto 0) >= b(NBIT-2 downto 0) then
			
			s_c(NBIT-2 downto 0) <= unsigned(a(NBIT-2 downto 0)) - unsigned(b(NBIT-2 downto 0));

			if sign_a = '0' then
				s_c(NBIT-1) <= '0';
			else
				s_c(NBIT-1) <= '1';
			end if;
		elsif a(NBIT-2 downto 0) < b(NBIT-2 downto 0) then
			s_c(NBIT-2 downto 0) <= unsigned(b(NBIT-2 downto 0)) - unsigned(a(NBIT-2 downto 0));
			
			if sign_b = '0' then
				s_c(NBIT-1) <= '0';
			else
				s_c(NBIT-1) <= '1';
			end if;
		end if;
	end process ADD;

	
	c <= std_logic_vector(s_c);
end architecture RTL;

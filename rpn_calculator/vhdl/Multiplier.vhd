library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Multiplier is
	generic(NBIT : positive := 12);
	port(
		en : in std_logic;
		a,b : in std_logic_vector(NBIT-1 downto 0);
		c : out std_logic_vector(NBIT-1 downto 0)
	);
end entity Multiplier;

architecture RTL of Multiplier is
	signal abs_a, abs_b : std_logic_vector(NBIT-2 downto 0);
	signal sign_a, sign_b : std_logic;

begin
	sign_a <= a(NBIT-1);
	sign_b <= b(NBIT-1);
	abs_a <= a(NBIT-2 downto 0);
	abs_b <= b(NBIT-2 downto 0);

	CABS: process(abs_a,abs_b,en) is
		variable pp : unsigned(NBIT+NBIT-3 downto 0);
		variable z_pp : unsigned(NBIT-2 downto 0);

	begin
		if en = '1' then
			pp := (others => '0');
			z_pp := (others => '0');

			for i in 0 to NBIT-2 loop
				for u in 0 to NBIT-2 loop
					z_pp(u) := abs_a(u) and abs_b(i);
				end loop;
				pp := pp + (z_pp sll i);
			end loop;
			c(NBIT-2 downto 0) <= std_logic_vector(pp(NBIT-2 downto 0));
		end if;
	end process CABS;



	c(NBIT-1) <= '0' when (sign_a = sign_b AND en ='1') else '1' when en = '1';

end architecture RTL;

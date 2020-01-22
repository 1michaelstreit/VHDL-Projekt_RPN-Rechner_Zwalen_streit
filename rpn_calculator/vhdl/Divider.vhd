-------------------------------------------------------------------------------
-- Filename 	: Divider.vhd
-- Title    	: Dividerer 
-- Author   	: Michael Streit
-- Date     	: 20.01.2020
-- Projectname	: VHDL-Projekt_RPN-Rechner_Zwahlen_Streit
-- Notes		: Dividiert a/b und gibt das Ergebnis in c aus falls durch 0
--				dividiert wird wird ein Error signal ausgegeben
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Divider is
	generic(NBIT : positive := 12);
	port(
		en : in std_logic;
		a,b:     in std_logic_vector(NBIT-1 downto 0);
		errorsig:     out std_logic := '0';
		--result_low:   out std_logic_vector(NBIT-2 downto 0);
		c:  out std_logic_vector(NBIT-1 downto 0)
	);
end Divider;

architecture Behave_Unsigned of Divider is
	constant all_zeros : std_logic_vector(NBIT-2 downto 0) := (others => '0');
	signal abs_a, abs_b : std_logic_vector(NBIT-2 downto 0);
	signal sign_a, sign_b : std_logic;
begin

	sign_a <= a(NBIT-1);
	sign_b <= b(NBIT-1);
	abs_a <= a(NBIT-2 downto 0);
	abs_b <= b(NBIT-2 downto 0);

	UNLABELED:

    process(abs_a,abs_b)
		variable quotient:  unsigned (NBIT-2 downto 0);
		variable remainder: unsigned (NBIT-2 downto 0);
	begin
		if en = '1' then
			errorsig <= '0';
			if abs_b = all_zeros then -- Achtung
				assert  abs_b /= all_zeros
				report "Division by Zero Exception"
				severity ERROR;
				errorsig <= '1';
			else
				quotient := (others => '0');
				remainder := (others => '0');
				for i in NBIT-2 downto 0 loop
					remainder := remainder (NBIT-3 downto 0) & '0';   -- r << 1
					remainder(0) := abs_a(i);       -- operanda is numerator
					if remainder >= unsigned(abs_b) then  -- operandb denominator
						remainder := remainder - unsigned(abs_b);
						quotient(i) := '1';
					end if;
				end loop;
				c(NBIT-2 downto 0) <= std_logic_vector(quotient); -- for error keeps
			end if;
		end if;
	end process;

	c(NBIT-1) <= '0' when (sign_a = sign_b AND en ='1') else '1' when en ='1';
end architecture;
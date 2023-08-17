library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity SignExtend is
port ( 
	x: in std_logic_vector(31 downto 0);
    y: out std_logic_vector(63 downto 0)
	);

end SignExtend;


architecture behavioral of SignExtend is

begin

	process (x) is
	begin

	if x(31 downto 26) = "000101" then -- B
		y <= (63 downto 26 => x(25), 25 downto 0 => x(25 downto 0));
	
	elsif x(31 downto 23) = "111110000" and x(21) = '0' then
		y <= (63 downto 9 => x(20), 8 downto 0 => x(20 downto 12)); -- STUR
	
	elsif x(31) = '1' and x(28 downto 26) = "100" and x(23 downto 22) = "00" then
		y <= (63 downto 12 => x(21), 11 downto 0 => x(21 downto 10)); -- LDUR
	
	elsif x(31 downto 25) = "1011010" then
		y <= (63 downto 19 => x(23), 18 downto 0 => x(23 downto 5)); -- CBZ/CBNZ
	
	elsif x(31 downto 22) = "1101001101" then
		y <= (63 downto 6 => '0', 5 downto 0 => x(15 downto 10)); -- LSL/LSR
	
	else
		y <= (63 downto 32 => x(31), 31 downto 0 => x(31 downto 0));
	
	end if;


	end process;

	-- with x(31 downto 21) select
	-- 	y <= (63 downto 26 => x(25), 25 downto 0 => x(25 downto 0)) when "000101XXXXX",
	-- 	(63 downto 9 => x(20), 8 downto 0 => x(20 downto 12)) when "111110000X0",
	-- 	(63 downto 12 => x(21), 11 downto 0 => x(21 downto 10)) when "1XX100XX00X",
	-- 	(63 downto 19 => x(23), 18 downto 0 => x(23 downto 5)) when "1011010XXXX",
	-- 	(63 downto 32 => x(31), 31 downto 0 => x(31 downto 0)) when others;




end;
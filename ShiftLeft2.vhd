library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ShiftLeft2 is
port ( 
	x: in std_logic_vector(63 downto 0);
   	y: out std_logic_vector(63 downto 0)
	);

end ShiftLeft2;


architecture behavioral of ShiftLeft2 is
begin

y <= x(61 downto 0) & "00";

end;
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity PC is
port ( 
	clk: in std_logic;
	write_enable: in std_logic;
    rst: in std_logic;
	AddressIn: in std_logic_vector(63 downto 0);
    AddressOut: out std_logic_vector(63 downto 0)
	);

end PC;


architecture behavioral of PC is

begin


process (clk, rst) is
begin

    if rst = '1' then
        AddressOut <= (others => '0');
    
    elsif rising_edge(clk) and write_enable = '1' then
        AddressOut <= AddressIn;
    end if;

end process; 


end;
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity twosComp is 
port (
        num: in std_logic_vector(63 downto 0);
        res: out std_logic_vector(63 downto 0)
);
end twosComp;

architecture behavioral of twosComp is

component ADD is
-- Adds two signed 64-bit inputs
-- output = in1 + in2
port(
    in0 : in STD_LOGIC_VECTOR(63 downto 0);
    in1 : in STD_LOGIC_VECTOR(63 downto 0);
    output: out STD_LOGIC_VECTOR(63 downto 0)
);
end component;

signal inverted: std_logic_vector(63 downto 0);

begin

    
    inverted <= not num;

    adder: ADD port map (inverted, 64d"1", res);



end;
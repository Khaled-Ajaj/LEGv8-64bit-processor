library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ADD is
-- Adds two signed 64-bit inputs
-- output = in1 + in2
port(
    in0 : in STD_LOGIC_VECTOR(63 downto 0);
    in1 : in STD_LOGIC_VECTOR(63 downto 0);
    output : out STD_LOGIC_VECTOR(63 downto 0)
);
end ADD;


architecture Behavioral of ADD is

component rca32bit is
Port ( num1, num2: in std_logic_vector (31 downto 0);
        Ci: in std_logic;
        S: out std_logic_vector(31 downto 0);
        Co: out std_logic );
end component;

signal carry: std_logic;

begin


    lower: rca32bit port map(in0(31 downto 0), in1(31 downto 0), '0', output(31 downto 0), carry);
    upper: rca32bit port map(in0(63 downto 32), in1(63 downto 32), carry, output(63 downto 32));


end;
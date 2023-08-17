----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/07/2022 05:03:53 PM
-- Design Name: 
-- Module Name: RippleAdder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RippleAdder is
  Port (A,B: in std_logic_vector(3 downto 0);
        Ci: in std_logic;
        S: out std_logic_vector(3 downto 0);
        Co: out std_logic );
end RippleAdder;

architecture Behavioral of RippleAdder is

component adder is 
port ( num1: in std_logic;
num2: in std_logic;
cin: in std_logic;
cout: out std_logic;
result: out std_logic);

end component;

signal c1, c2, c3: std_logic;


begin


adder0: adder port map (A(0), B(0), Ci, c1, S(0));
adder1: adder port map (A(1), B(1), C1, c2, S(1));
adder2: adder port map (A(2), B(2), C2, c3, S(2));
adder3: adder port map (A(3), B(3), C3, Co, S(3));




end Behavioral;

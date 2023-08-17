----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/24/2022 04:39:41 PM
-- Design Name: 
-- Module Name: rca32bit - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rca32bit is
Port ( num1, num2: in std_logic_vector (31 downto 0);
        Ci: in std_logic;
        S: out std_logic_vector(31 downto 0);
        Co: out std_logic );
end rca32bit;




architecture Behavioral of rca32bit is

component RippleAdder is
  Port (A,B: in std_logic_vector(3 downto 0);
        Ci: in std_logic;
        S: out std_logic_vector(3 downto 0);
        Co: out std_logic );
end component;

signal c1, c2, c3, c4, c5, c6, c7: std_logic;

begin

    adder0: RippleAdder port map(num1(3 downto 0), num2(3 downto 0), Ci, S(3 downto 0), c1);
    adder1: RippleAdder port map(num1(7 downto 4), num2(7 downto 4), C1, S(7 downto 4), c2);
    adder2: RippleAdder port map(num1(11 downto 8), num2(11 downto 8), C2, S(11 downto 8), c3);
    adder3: RippleAdder port map(num1(15 downto 12), num2(15 downto 12), C3, S(15 downto 12), c4);
    adder4: RippleAdder port map(num1(19 downto 16), num2(19 downto 16), C4, S(19 downto 16), c5);
    adder5: RippleAdder port map(num1(23 downto 20), num2(23 downto 20), C5, S(23 downto 20), c6);
    adder6: RippleAdder port map(num1(27 downto 24), num2(27 downto 24), C6, S(27 downto 24), c7);
    adder7: RippleAdder port map(num1(31 downto 28), num2(31 downto 28), C7, S(31 downto 28), co);
    
    

end Behavioral;

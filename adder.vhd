----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/07/2022 04:39:38 PM
-- Design Name: 
-- Module Name: adder - Behavioral
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
use IEEE.numeric_std.all;



-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adder is 
port ( num1: in std_logic;
num2: in std_logic;
cin: in std_logic;
cout: out std_logic;
result: out std_logic);

end adder;


architecture Behavioral of adder is
--signal result_ext: unsigned (1 downto 0);	--intermediate result with extended bit 
--signal n1, n2: std_logic_vector (1 downto 0);
begin

--select between addition and subtraction using multiplexer
-- n1 <= '0' & num1;
-- n2 <= '0' & num2;
--result_ext <= unsigned(n1) + unsigned(n2) + cin
--when select_sig = '0' else (unsigned(n1)-unsigned(n2) - cin);

--outputs of adder
	--result <= result_ext(0);
	--cout <= result_ext(1);
	result <= (num1 xor num2) xor cin;
	cout<= (num1 and (num2 or cin)) or (cin and num2); 

end Behavioral;

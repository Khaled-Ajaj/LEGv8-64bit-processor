library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.ALL; -- to_integer and unsigned



entity ALU is
-- Implement: AND, OR, ADD (signed), SUBTRACT (signed)
-- as described in Section 4.4 in the textbook.
-- The functionality of each instruction can be found on the ’ARM Reference Data’ sheet at the
-- front of the textbook (or the Green Card pdf on Canvas).
port(
    in0 : in STD_LOGIC_VECTOR(63 downto 0);
    in1 : in STD_LOGIC_VECTOR(63 downto 0);
    operation : in STD_LOGIC_VECTOR(3 downto 0);
    result : buffer STD_LOGIC_VECTOR(63 downto 0);
    zero : buffer STD_LOGIC;
    overflow : buffer STD_LOGIC
);
end ALU;


architecture behavioral of ALU is 

component ADD is

port(
    in0 : in STD_LOGIC_VECTOR(63 downto 0);
    in1 : in STD_LOGIC_VECTOR(63 downto 0);
    output : out STD_LOGIC_VECTOR(63 downto 0)
);
end component;

component twosComp is 
port (
        num: in std_logic_vector(63 downto 0);
        res: out std_logic_vector(63 downto 0)
);
end component;



signal op0, op1, addRes, twosComplement: std_logic_vector(63 downto 0);
signal zeroFlag, notZero: std_logic;
begin

    adder: ADD port map (op0, op1, addRes);
    complementer: twosComp port map (in1, twosComplement);

    op0 <= 64d"0" when (operation(2 downto 0) = "111") else in0;
    op1 <= twosComplement when operation = "0110" else in1;
    
    
    result <= (in0 and in1) when operation = "0000" else
             (in0 or in1) when operation = "0001" else
             (in0 sll to_integer(unsigned(in1))) when operation = "1101" else
             (in0 srl to_integer(unsigned(in1))) when operation = "1110" else
                addRes;

    zeroFlag <= '1' when result = 64d"0" else '0';
    notZero <= not zero;

    zero <= notZero when operation = "1111" else zeroFlag;

    -- overflow when adding two positives and getting a negative, or adding two negatives and getting a positive.
    overflow <= (not in0(63) and not op1(63) and result(63)) or (in0(63) and op1(63) and not result(63));




end;
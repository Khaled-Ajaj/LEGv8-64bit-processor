library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ALUControl is
-- Functionality should match truth table shown in Figure 4.13 in the textbook.
-- Check table on page2 of Green Card.pdf on canvas. Pay attention to opcode of operations and type of operations.
-- If an operation doesn’t use ALU, you don’t need to check for its case in the ALU control implemenetation.
-- To ensure proper functionality, you must implement the "don’t-care" values in the funct field,
-- for example when ALUOp = ’00", Operation must be "0010" regardless of what Funct is.
port(
ALUOp : in STD_LOGIC_VECTOR(1 downto 0);
Opcode : in STD_LOGIC_VECTOR(10 downto 0);
Operation : out STD_LOGIC_VECTOR(3 downto 0)
);
end ALUControl;


architecture Behavioral of ALUControl is
begin

    Operation <= "0010" when ALUOp = "00" else -- B
    "0111" when (ALUOp(0) = '1' and Opcode(10 downto 3) = "10110100")  else -- CBZ
    "1111" when (ALUOp(0) = '1' and Opcode(10 downto 3) = "10110101")  else -- CBNZ
    "0010" when (Opcode = "10001011000" or Opcode(10 downto 1) = "1001000100") else -- ADD/ADDI
    "0110" when (Opcode = "11001011000" or Opcode(10 downto 1) = "1101000100") else -- SUB/SUBI
    "0000" when (Opcode = "10001010000" or Opcode(10 downto 1) = "1001001000") else -- AND/ANDI
    "0001" when (Opcode = "10101010000" or Opcode(10 downto 1) = "1011001000") else -- OR/ORI
    "1101" when (Opcode = "11010011011") else -- LSL
    "1110" when (Opcode = "11010011010") else -- LSR
    "UUUU";

    -- process (ALUOp, Opcode) is
    -- begin

    --     if ALUOp = "00" then
    --         Operation <= "0010";
        
    --     elsif ALUOp(0) = '1' then
    --         Operation <= "0111";

    --     elsif Opcode = "10001011000" then
    --         Operation <= "0010";
        
    --     elsif Opcode = "11001011000" then
    --         Operation <= "0110";
        
    --     elsif Opcode = "10001010000" then 
    --         Operation <= "0000";
        
    --     elsif Opcode = "10101010000" then
    --         Operation <= "0001";
        
    --     else
    --         Operation <= "UUUU";
        
    --     end if;

    -- end process;

    -- process(ALUOp, Opcode) is
    -- begin
 
    --     case ALUOp is
    --         when "00" =>
    --             Operation <= "0010";
    --         when "X1" =>
    --             Operation <= "0111";
    --         when others => 
    --             case Opcode is
    --                 when "10001011000" =>
    --                     Operation <= "0010";
                    
    --                 when "11001011000" =>
    --                     Operation <= "0110";
                    
    --                 when "10001010000" =>
    --                     Operation <= "0000";

    --                 when "10101010000" =>
    --                     Operation <= "0001";
	-- 	    when others =>
	-- 		Operation <= "UUUU";

    --             end case;
    --     end case;
 
    -- end process;





end;
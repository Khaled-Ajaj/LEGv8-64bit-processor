
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity CPUControl is
-- Functionality should match the truth table shown in Figure 4.22 of the textbook, inlcuding the
-- res ’X’ values.
-- The truth table in Figure 4.22 omits the unconditional branch instruction:
-- UBranch = ’1’
-- MemWrite = RegWrite = ’0’
-- all other ress = ’X’
port(Opcode : in STD_LOGIC_VECTOR(10 downto 0);
    Reg2Loc : out STD_LOGIC;
    CBranch : out STD_LOGIC; --conditional
    MemRead : out STD_LOGIC;
    MemtoReg : out STD_LOGIC;
    MemWrite : out STD_LOGIC;
    ALUSrc : out STD_LOGIC;
    RegWrite : out STD_LOGIC;
    UBranch : out STD_LOGIC; -- This is unconditional
    ALUOp : out STD_LOGIC_VECTOR(1 downto 0)
);
end CPUControl;




architecture behavioral of CPUControl is

signal res: std_logic_vector(9 downto 0);

begin

    
    -- case (Opcode) is 
    process (Opcode) is
    begin

        if Opcode(10) = '1' and Opcode(7 downto 4) = "0101" and Opcode(2 downto 0) = "000" then
            res <= "0001000010";
        
        elsif Opcode = "11111000010" then
            res <= "X111100000";
        
        elsif Opcode = "11111000000" then
            res <= "11X0010000";
        
        elsif Opcode(10 downto 4) = "1011010" then -- CBZ and CBNZ
            res <= "10X0001001";
        
        elsif Opcode(10 downto 5) = "000101" then
            res <= "XXX00XX1XX";
        
        elsif Opcode(10) = '1' and Opcode(7 downto 5) = "100" and Opcode(2 downto 1) = "00" then
            res <= "0101000010";

        elsif Opcode(10 downto 5) = "000101" then
            res <= "XXX0X0X1XX";
        
        elsif Opcode(10 downto 1) = "1101001101" then
            res <= "01010000XX";
        
        else
            res <= "0000000000";

        end if;





    end process;



    
    -- with Opcode select
    --     --when "1XX0101X000" =>
    --         res <= "0001000010" when "1--0101-000",
    --         "X111100000" when "11111000010",
    --         "11X0010000" when "11111000000",
    --         "10X0001001" when "10110100---",
    --         "XXX00XX1XX" when "000101-----",
    --         "0101000010" when "1--100--00-",
    --         "XXX0X0X1XX" when others;

    --         -- when "11111000010" =>
    --         --     res <= "X111100000";

    --         -- when "11111000000" => 
    --         --     res <= "11X0010000";

    --         -- when "10110100XXX" =>
    --         --     res <= "10X0001001";
            
    --         -- when others =>
    --         --     res <= "XXX0X0X1XX";







    Reg2Loc <= res(9);
    ALUSrc <= res(8);
    MemtoReg <= res(7);
    RegWrite <= res(6);
    MemRead <= res(5);
    MemWrite <= res(4);
    CBranch <= res(3);
    UBranch <= res(2);
    ALUOp <= res(1 downto 0);



end;
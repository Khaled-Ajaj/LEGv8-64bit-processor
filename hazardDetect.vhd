library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity hazardDetect is 
port(
    memRead: in std_logic;
    Rm, Rn, Rd: in std_logic_vector(4 downto 0);
    stall, IFIDWrite, PCWrite: out std_logic
     
);
end hazardDetect;


architecture behavioral of hazardDetect is
begin

    process(all)
    begin

        if (memRead = '1' and (Rd = Rn or Rd = Rm)) then
        
            IFIDWrite <= '0';
            PCWrite <= '0';
            stall <= '1';
        else

            IFIDWrite <= '1';
            PCWrite <= '1';
            stall <= '0';
            
        end if;


    end process;





end;
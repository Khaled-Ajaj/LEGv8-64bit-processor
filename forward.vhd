library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity forward is 
port(
    IDEXRm, IDEXRn: in std_logic_vector(4 downto 0);
    EXMEMRd: in std_logic_vector(4 downto 0);
    MEMWBRd: in std_logic_vector(4 downto 0);
    EXMEMRegWrite, MEMWBRegWrite: in std_logic;

    forwardA, forwardB: out std_logic_vector(1 downto 0)
);
end forward;


architecture behavioral of forward is
begin

    process (all) begin

        -- forwardA

        if (EXMEMRegWrite = '1') and (EXMEMRd /= "11111") and (EXMEMRd = IDEXRn)
        then

            forwardA <= "10";
        
        elsif (MEMWBRegWrite = '1') and (MEMWBRd /= "11111") and (MEMWBRd = IDEXRn) and
                not(EXMEMRegWrite = '1' and (EXMEMRd /= "11111") and (EXMEMRd = IDEXRn))
        then
            forwardA <= "01";
        
        else
            forwardA <= "00";
        
        end if;



        -- forwardB

        if (EXMEMRegWrite = '1') and (EXMEMRd /= "11111") and (EXMEMRd = IDEXRm)
        then

            forwardB <= "10";
        
        elsif (MEMWBRegWrite = '1') and (MEMWBRd /= "11111") and (MEMWBRd = IDEXRm) and
                not(EXMEMRegWrite = '1' and (EXMEMRd /= "11111") and (EXMEMRd = IDEXRm))
        then
            forwardB <= "01";
        
        else
            forwardB <= "00";
        
        end if;








    end process;







end;
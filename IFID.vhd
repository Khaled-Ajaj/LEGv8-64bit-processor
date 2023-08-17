library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity IFID is
port( clk: in std_logic;
     flush: in std_logic;
      write_enable: in std_logic;
      dataIn: in std_logic_vector(95 downto 0);
      dataOut: out std_logic_vector(95 downto 0)

);
end IFID;




architecture behavioral of IFID is
begin

    process(all) is
    begin
    
        if rising_edge(clk) and flush = '1' then
            dataOut <= 96d"0";

        elsif rising_edge(clk) and write_enable = '1' then
            dataOut <= dataIn;
        
        end if;


    end process;




end;



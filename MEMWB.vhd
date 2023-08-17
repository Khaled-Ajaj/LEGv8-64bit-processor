library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity MEMWB is
port( clk: in std_logic;
      write_enable: in std_logic;
      dataIn: in std_logic_vector(134 downto 0);
      dataOut: out std_logic_vector(134 downto 0)

);
end MEMWB;




architecture behavioral of MEMWB is
begin

    process(clk) is
    begin

        if rising_edge(clk) and write_enable = '1' then
            dataOut <= dataIn;
        
        end if;


    end process;




end;



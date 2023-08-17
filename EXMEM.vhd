library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity EXMEM is
port( clk: in std_logic;
      write_enable: in std_logic;
      dataIn: in std_logic_vector(203 downto 0);
      dataOut: out std_logic_vector(203 downto 0)

);
end EXMEM;




architecture behavioral of EXMEM is
begin

    process(clk) is
    begin

        if rising_edge(clk) and write_enable = '1' then
            dataOut <= dataIn;
        
        end if;


    end process;




end;



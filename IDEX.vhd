library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity IDEX is
port( clk: in std_logic;
      write_enable: in std_logic;
      dataIn: in std_logic_vector(290 downto 0);
      dataOut: out std_logic_vector(290 downto 0)

);
end IDEX;




architecture behavioral of IDEX is
begin

    process(clk) is
    begin

        if rising_edge(clk) and write_enable = '1' then
            dataOut <= dataIn;
        
        end if;


    end process;




end;



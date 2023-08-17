library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity cputest is
end;


architecture test of cputest is

component PipelinedCPU2 is
port(
     clk :in std_logic;
     rst :in std_logic;
     --Probe ports used for testing
     DEBUG_IF_FLUSH : out std_logic;
     DEBUG_REG_EQUAL : out std_logic;
     -- Forwarding control signals
     DEBUG_FORWARDA : out std_logic_vector(1 downto 0);
     DEBUG_FORWARDB : out std_logic_vector(1 downto 0);
     --The current address (AddressOut from the PC)
     DEBUG_PC : out std_logic_vector(63 downto 0);
     --Value of PC.write_enable
     DEBUG_PC_WRITE_ENABLE : out STD_LOGIC;
     --The current instruction (Instruction output of IMEM)
     DEBUG_INSTRUCTION : out std_logic_vector(31 downto 0);
     --DEBUG ports from other components
     DEBUG_TMP_REGS : out std_logic_vector(64*4 - 1 downto 0);
     DEBUG_SAVED_REGS : out std_logic_vector(64*4 - 1 downto 0);
     DEBUG_MEM_CONTENTS : out std_logic_vector(64*4 - 1 downto 0)
);
end component;

signal clk, rst, DEBUG_PC_WRITE_ENABLE: std_logic;
signal DEBUG_FORWARDA, DEBUG_FORWARDB: std_logic_vector(1 downto 0);
signal DEBUG_PC: std_logic_vector(63 downto 0);
signal DEBUG_INSTRUCTION: std_logic_vector(31 downto 0);
signal DEBUG_TMP_REGS, DEBUG_MEM_CONTENTS, DEBUG_SAVED_REGS: STD_LOGIC_VECTOR(64*4 - 1 downto 0);
signal DEBUG_IF_FLUSH, DEBUG_REG_EQUAL: std_logic;

begin

dut: PipelinedCPU2 port map (clk, rst, DEBUG_IF_FLUSH, DEBUG_REG_EQUAL, DEBUG_FORWARDA, DEBUG_FORWARDB, DEBUG_PC, DEBUG_PC_WRITE_ENABLE, DEBUG_INSTRUCTION, DEBUG_TMP_REGS, DEBUG_SAVED_REGS, DEBUG_MEM_CONTENTS);

process is
begin
    clk <= '1';
    rst <= '1';
    wait for 20 ns;

    rst <= '0';
    wait for 20 ns;

    clk <= '0';
    wait for 20 ns;

    clk <= '1';
    wait for 20 ns;

    for k in 0 to 50 loop

    if clk = '1' then
        clk <= '0';
    
    else
        clk <= '1';
    
    end if;
    wait for 20 ns;
    end loop;
    
    wait;
end process; 


end;
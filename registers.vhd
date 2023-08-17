library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity registers is
-- This component is described in the textbook, starting on section 4.3 
-- The indices of each of the registers can be found on the LEGv8 Green Card
-- Keep in mind that register 31 (XZR) has a constant value of 0 and cannot be overwritten
-- This should only write on the negative edge of Clock when RegWrite is asserted.
-- Reads should be purely combinatorial, i.e. they don't depend on Clock
-- HINT: Use the provided dmem.vhd as a starting point

port(RR1      : in  STD_LOGIC_VECTOR (4 downto 0); 
     RR2      : in  STD_LOGIC_VECTOR (4 downto 0); 
     WR       : in  STD_LOGIC_VECTOR (4 downto 0); 
     WD       : in  STD_LOGIC_VECTOR (63 downto 0);
     RegWrite : in  STD_LOGIC;
     Clock    : in  STD_LOGIC;
     RD1      : out STD_LOGIC_VECTOR (63 downto 0);
     RD2      : out STD_LOGIC_VECTOR (63 downto 0);
     --Probe ports used for testing.
     -- Notice the width of the port means that you are 
     --      reading only part of the register file. 
     -- This is only for debugging
     -- You are debugging a sebset of registers here
     -- Temp registers: $X9 & $X10 & X11 & X12 
     -- 4 refers to number of registers you are debugging
     DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     -- Saved Registers X19 & $X20 & X21 & X22 
     DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
);
end registers;


architecture behavioral of registers is
type regArray is array (0 to 31) of STD_LOGIC_VECTOR(63 downto 0); 
signal regs: regArray;
 
begin
   process(all) -- Run when any of these inputs change
   variable addr, addr1, addr2:integer;
   variable first:boolean := true; -- Used for initialization
   begin
      -- This part of the process initializes the memory and is only here for simulation purposes
      -- It does not correspond with actual hardware!
      if(first) then
         
         for k in 0 to 31 loop

            regs(k) <= (others => '0');

         end loop;

         regs(9)<= 64X"1";
         regs(10) <= 64X"2";
         regs(11)<= 64X"4";
         regs(12) <= 64X"8";
         regs(13)<= 64X"0";
         regs(14)<= 64X"0";
         regs(15)<= 64X"0";

         regs(19) <= 64X"1";
         regs(20) <= 64X"2";
         regs(21) <= 64X"8BADF00D";
         regs(22) <= 64X"8BADF00D";
         regs(23) <= 64X"0";
         regs(24) <= 64X"0";
         regs(25) <= 64X"0";
         regs(26) <= 64X"0";
         regs(27) <= 64X"0";

	 -- Follow the pattern and write the rest of the code; initialize memory cells with 0 for 1KB
         first := false; -- Don't initialize the next time this process runs
      end if;

      -- The 'proper' HDL starts here!
      if falling_edge(Clock) and RegWrite='1' and (WR /= "11111") then 
         -- Write on the rising edge of the clock
         regs(to_integer(unsigned(WR))) <= WD;
      end if;

      RD1 <= regs(to_integer(unsigned(RR1)));
      RD2 <= regs(to_integer(unsigned(RR2)));

      DEBUG_TMP_REGS <= regs(9) & regs(10) & regs(11) & regs(12);
      DEBUG_SAVED_REGS <= regs(19) & regs(20) & regs(21) & regs(22);
         
   end process;
   
   
end behavioral;


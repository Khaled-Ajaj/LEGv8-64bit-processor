library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity PipelinedCPU2 is
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
end PipelinedCPU2;


architecture behavioral of PipelinedCPU2 is


component PC is
port ( 
	clk: in std_logic;
	write_enable: in std_logic;
    rst: in std_logic;
	AddressIn: in std_logic_vector(63 downto 0);
    AddressOut: out std_logic_vector(63 downto 0)
	);

end component;

component ADD is
-- Adds two signed 64-bit inputs
-- output = in1 + in2
port(
    in0 : in STD_LOGIC_VECTOR(63 downto 0);
    in1 : in STD_LOGIC_VECTOR(63 downto 0);
    output : out STD_LOGIC_VECTOR(63 downto 0)
);
end component;


component IMEM is
-- The instruction memory is a byte addressable, little-endian, read-only memory
-- Reads occur continuously
generic(NUM_BYTES : integer := 64);
-- NUM_BYTES is the number of bytes in the memory (small to save computation resources)
port(
     Address  : in  STD_LOGIC_VECTOR(63 downto 0); -- Address to read from
     ReadData : out STD_LOGIC_VECTOR(31 downto 0)
);
end component;


component SignExtend is
port ( 
	x: in std_logic_vector(31 downto 0);
    y: out std_logic_vector(63 downto 0)
	);

end component;


component ShiftLeft2 is
port ( 
	x: in std_logic_vector(63 downto 0);
   	y: out std_logic_vector(63 downto 0)
	);

end component;

component registers is
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
end component;



component CPUControl is
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
end component;

component ALUControl is
port(
ALUOp : in STD_LOGIC_VECTOR(1 downto 0);
Opcode : in STD_LOGIC_VECTOR(10 downto 0);
Operation : out STD_LOGIC_VECTOR(3 downto 0)
);
end component;


component ALU is
port(
    in0 : in STD_LOGIC_VECTOR(63 downto 0);
    in1 : in STD_LOGIC_VECTOR(63 downto 0);
    operation : in STD_LOGIC_VECTOR(3 downto 0);
    result : buffer STD_LOGIC_VECTOR(63 downto 0);
    zero : buffer STD_LOGIC;
    overflow : buffer STD_LOGIC
);
end component;


component DMEM is
-- The data memory is a byte addressble, little-endian, read/write memory with a single address port
-- It may not read and write at the same time
generic(NUM_BYTES : integer := 144);
-- NUM_BYTES is the number of bytes in the memory (small to save computation resources)
port(
     WriteData          : in  STD_LOGIC_VECTOR(63 downto 0); -- Input data
     Address            : in  STD_LOGIC_VECTOR(63 downto 0); -- Read/Write address
     MemRead            : in  STD_LOGIC; -- Indicates a read operation
     MemWrite           : in  STD_LOGIC; -- Indicates a write operation
     Clock              : in  STD_LOGIC; -- Writes are triggered by a rising edge
     ReadData           : out STD_LOGIC_VECTOR(63 downto 0); -- Output data
     --Probe ports used for testing
     -- Four 64-bit words: DMEM(0) & DMEM(4) & DMEM(8) & DMEM(12)
     DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
);
end component;


component IFID is
port( clk: in std_logic;
     flush: in std_logic;
      write_enable: in std_logic;
      dataIn: in std_logic_vector(95 downto 0);
      dataOut: out std_logic_vector(95 downto 0)

);
end component;

component IDEX is
port( clk: in std_logic;
      write_enable: in std_logic;
      dataIn: in std_logic_vector(290 downto 0);
      dataOut: out std_logic_vector(290 downto 0)

);
end component;


component EXMEM is
port( clk: in std_logic;
      write_enable: in std_logic;
      dataIn: in std_logic_vector(203 downto 0);
      dataOut: out std_logic_vector(203 downto 0)

);
end component;

component MEMWB is
port( clk: in std_logic;
      write_enable: in std_logic;
      dataIn: in std_logic_vector(134 downto 0);
      dataOut: out std_logic_vector(134 downto 0)

);
end component;

component hazardDetect is 
port(
    memRead: in std_logic;
    Rm, Rn, Rd: in std_logic_vector(4 downto 0);
    stall, IFIDWrite, PCWrite: out std_logic
     
);
end component;


component forward is 
port(
    IDEXRm, IDEXRn: in std_logic_vector(4 downto 0);
    EXMEMRd: in std_logic_vector(4 downto 0);
    MEMWBRd: in std_logic_vector(4 downto 0);
    EXMEMRegWrite, MEMWBRegWrite: in std_logic;

    forwardA, forwardB: out std_logic_vector(1 downto 0)
);
end component;



signal reg2loc, cbranch, memRead, memtoReg, memWrite, ALUSrc, RegWrite, UBranch: std_logic;
signal ALUOp: std_logic_vector(1 downto 0);
signal currOp: std_logic_vector(3 downto 0);
signal in0, in1, aluRes: std_logic_vector(63 downto 0);
signal zero, overflow: std_logic;
signal pcWE, pcSrc: std_logic;
signal pcIn, pcOut, pcPlus4, extended, branchOffset, branchAddress: std_logic_vector(63 downto 0);
signal regWD, regRD1, regRD2: std_logic_vector(63 downto 0);
signal RReg1, RReg2, WReg: std_logic_vector(4 downto 0);
signal four: std_logic_vector(63 downto 0) := (63 downto 3 => '0', 2 downto 0 => "100");
signal currInstruction: std_logic_vector(31 downto 0);
signal memRD: std_logic_vector(63 downto 0);
signal IFIDin, IFIDout: std_logic_vector(95 downto 0);
signal IDEXin, IDEXout: std_logic_vector(290 downto 0);
signal EXMEMin, EXMEMout: std_logic_vector(203 downto 0);
signal MEMWBin, MEMWBout: std_logic_vector(134 downto 0);
signal IFIDwrite, IDEXwrite, EXMEMwrite, MEMWBwrite: std_logic;
signal stall: std_logic;
signal IFID_flush: std_logic;
signal forwardA, forwardB: std_logic_vector(1 downto 0);
signal alu_intermediate: std_logic_vector(63 downto 0);
signal regIsZero: std_logic;

begin

     -- IF stage

     --pcWE <= '1';
     pcIn <= branchAddress when pcSrc = '1' else pcPlus4;


     progCounter: PC port map(clk, pcWE, rst, pcIn, pcOut);

     plusFour: ADD port map (pcOut, four, pcPlus4);

     instMem: IMEM port map(pcOut, currInstruction);

     IFIDin <= pcOut & currInstruction;

     IFIDReg: IFID port map(clk, IFID_flush, IFIDwrite, IFIDin, IFIDout);

     


     -- ID stage

     RReg1 <= IFIDout(9 downto 5); -- Rn
     RReg2 <= IFIDout(20 downto 16) when reg2loc = '0' else IFIDout(4 downto 0); -- Rm

     extend: SignExtend port map(IFIDout(31 downto 0), extended);

     regfile: registers port map (RReg1, RReg2, WReg, regWD, MEMWBout(134), clk, regRD1, regRD2, DEBUG_TMP_REGS, DEBUG_SAVED_REGS);

     cpuCtrl: CPUControl port map (IFIDout(31 downto 21), reg2loc, cbranch, memRead, memtoReg, memWrite, ALUSrc, RegWrite, UBranch, ALUOp);

     IDEXin <= RReg2 & RReg1 & "000000000" & IFIDout(95 downto 32) & regRD1 & regRD2 & extended & IFIDout(31 downto 21) & IFIDout(4 downto 0) when stall = '1' else RReg2 & RReg1 & RegWrite & memtoReg & memWrite & memRead & UBranch & cbranch & ALUSrc & ALUOp & IFIDout(95 downto 32) & regRD1 & regRD2 & extended & IFIDout(31 downto 21) & IFIDout(4 downto 0);

     IDEXReg: IDEX port map(clk, IDEXwrite, IDEXin, IDEXout);

     shift: ShiftLeft2 port map (extended, branchOffset);

     branchAdder: ADD port map (IFIDout(95 downto 32), branchOffset, branchAddress);

    regIsZero <= '1' when regRD2 = 64d"0" else '0';

    pcSrc <= (regIsZero and cbranch) or UBranch; -- zero and cbranch OR ubranch


     -- EX stage
     
     aluCtrl: ALUControl port map (IDEXout(273 downto 272), IDEXout(15 downto 5), currOp);

     --ALUSrc <= IDEXout(274);

     in0 <= EXMEMout(132 downto 69) when forwardA = "10" else regWD when forwardA = "01" else IDEXout(207 downto 144);
     --in1 <= EXMEMout(132 downto 69) when forwardB = "10" else regWD when forwardB = "01" else
     --       IDEXout(143 downto 80) when IDEXout(274) = '0' else IDEXout(79 downto 16);
	alu_intermediate <= EXMEMout(132 downto 69) when forwardB = "10" else regWD when forwardB = "01" else IDEXout(143 downto 80);
	in1 <= alu_intermediate when IDEXout(274) = '0' else IDEXout(79 downto 16);
     ALU1: ALU port map(in0, in1, currOp, aluRes, zero, overflow);

     EXMEMin <= IDEXout(280 downto 275) & branchAddress & zero & aluRes & IDEXout(143 downto 80) & IDEXout(4 downto 0);

     EXMEMReg: EXMEM port map(clk, EXMEMwrite, EXMEMin, EXMEMout);


     -- MEM stage
     

     dataMem: DMEM port map (EXMEMout(68 downto 5), EXMEMout(132 downto 69), EXMEMout(200), EXMEMout(201), clk, memRD, DEBUG_MEM_CONTENTS);

     MEMWBin <= EXMEMout(203 downto 202) & memRD & EXMEMout(132 downto 69) & EXMEMout(4 downto 0);

     MEMWBReg: MEMWB port map(clk, MEMWBwrite, MEMWBin, MEMWBout);


     -- WB stage
     
     WReg <= MEMWBout(4 downto 0);

     regWD <= MEMWBout(132 downto 69) when MEMWBout(133) = '1' else MEMWBout(68 downto 5);


     -- hazard detection

     hazardDetector: hazardDetect port map(IDEXout(277), RReg1, RReg2, IDEXout(4 downto 0), stall, IFIDwrite, PCWE);
     IDEXwrite <= '1';
     EXMEMwrite <= '1';
     MEMWBwrite <= '1';
    

     -- forwarding
     forwardUnit: forward port map(IDEXout(290 downto 286), IDEXout(285 downto 281), EXMEMout(4 downto 0), MEMWBout(4 downto 0), EXMEMout(203), MEMWBout(134), forwardA, forwardB);

     -- flushing
     -- always predict not taken, flush when we have to branch
     IFID_flush <= '1' when (pcSrc = '1' and pcWE ='1') else '0';



     -- Debug signals
     DEBUG_PC <= pcOut;
     DEBUG_INSTRUCTION <= currInstruction;
     DEBUG_PC_WRITE_ENABLE <= pcWE;
     DEBUG_FORWARDA <= forwardA;
     DEBUG_FORWARDB <= forwardB;
     DEBUG_IF_FLUSH <= IFID_flush;
     DEBUG_REG_EQUAL <=  regIsZero;
     









     








end;


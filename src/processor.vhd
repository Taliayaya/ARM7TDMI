library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PROCESSOR is 
    port (
        Clk : in std_logic;
        Reset: in std_logic;
        Afficheur: out STD_LOGIC_VECTOR(31 downto 0)
    );
end entity;

architecture PRC of PROCESSOR is 
    signal Instruction, busB, CPSR, CPSR_Out: STD_LOGIC_VECTOR(31 downto 0);
    signal Imm24: STD_LOGIC_VECTOR(23 downto 0);
    signal Imm8: STD_LOGIC_VECTOR(7 downto 0);
    signal RD, RN, RM, RMD : STD_LOGIC_VECTOR(3 downto 0);
    signal MemWr, RegWr, MemToReg : STD_LOGIC;
    signal RegSel,RegAff, PSREn, ALUSrc, nPCsel: std_logic;
    signal ALUCtr: STD_LOGIC_VECTOR(1 downto 0);
begin

Instruction_Handler_Unit: entity work.instruction_handler_unit
 port map(
    offset => Imm24,
    nPCsel => nPCsel,
    Clk => Clk,
    Reset => Reset,
    Instruction => Instruction
);

MUX2x1: entity work.MUX2x1
 generic map(
    N => 4
)
 port map(
    A => RM,
    B => RD,
    COM => RegSel,
    S => RMD
);

Reg_PSR: entity work.ONE_REGISTER
    port map (
        Clk => Clk,
        Rst => Reset,
        DataIN => CPSR,
        WE => PSREn,
        DataOut => CPSR_Out
    );

Treatment_Unit: entity work.TREATMENT_UNIT
port map (
    Clk => Clk,
    RESET => Reset,
    CPSR => CPSR,
    RA => RN,
    RB => RMD,
    RW => RD,
    ALUsrc => ALUSrc,
    ALUCtr => ALUCtr,
    MemWr => MemWr,
    RegWr => RegWr,
    MemToReg => MemToReg ,
    ImmediateRaw => Imm8 ,
    busB => busB 
);



Decoder: entity work.INSTRUCTION_DECODER
 port map(
    Instruction => Instruction,
    CPSR => CPSR_Out,
    nPCsel => nPCsel,
    PSREn => PSREn,
    RegWr => RegWr,
    MemWr => MemWr,
    WrSrc => MemToReg,
    RegSel => RegSel,
    RegAff => RegAff,
    ALUSrc => ALUSrc,
    ALUCtr => ALUCtr,
    RD => RD,
    RN => RN,
    RM => RM,
    Imm8 => Imm8,
    Imm24 => Imm24
);

Reg_Aff: entity work.ONE_REGISTER
   port map (
        Clk => Clk,
        Rst => Reset,
        DataIN => busB ,
        WE => RegAff,
        DataOut => Afficheur
);

end architecture;

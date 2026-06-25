library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PROCESSOR is 
    port (
        Clk : in std_logic;
        Reset: in std_logic;
        IRQ0 : in std_logic;
        IRQ1 : in std_logic;
        Afficheur: out STD_LOGIC_VECTOR(31 downto 0)
    );
end entity;

architecture PRC of PROCESSOR is 
    signal Instruction, busB, CPSR, CPSR_Out    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Imm24                                : STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
    signal Imm8                                 : STD_LOGIC_VECTOR(7 downto 0)  := (others => '0');
    signal RD, RN, RM, RMD                      : STD_LOGIC_VECTOR(3 downto 0)  := (others => '0');
    signal MemWr, RegWr, MemToReg               : STD_LOGIC                     := '0';
    signal RegSel,RegAff, PSREn, ALUSrc, nPCsel : std_logic                     := '0';
    signal ALUCtr                               : STD_LOGIC_VECTOR(1 downto 0)  := (others => '0');
    signal IRQ, IRQ_END, IRQ_SERV               : STD_LOGIC                     := '0';
    signal  VICPC                               : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin

Instruction_Handler_Unit: entity work.instruction_handler_unit
 port map(
    offset => Imm24,
    nPCsel => nPCsel,
    Clk => Clk,
    Reset => Reset,
    IRQ => IRQ,
    IRQ_END => IRQ_END,
    VICPC => VICPC,
    IRQ_SERV => IRQ_SERV,
    Instruction => Instruction
);

VIC: entity work.VIC 
port map (
    CLK => Clk,
    RESET => Reset,
    IRQ_SERV => IRQ_SERV,
    IRQ0 => IRQ0,
    IRQ1 => IRQ1,
    IRQ => IRQ,
    VICPC => VICPC  
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
    Imm24 => Imm24,
    IRQ_END => IRQ_END -- TODO
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

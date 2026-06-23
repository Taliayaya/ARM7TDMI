library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity INSTRUCTION_DECODER_TB is 
end entity;

architecture BENCH of INSTRUCTION_DECODER_TB is
    signal Instruction     : std_logic_vector(31 downto 0);
    signal CPSR            : std_logic_vector(31 downto 0);
    signal nPCsel          : std_logic;
    signal PSREn           : std_logic;
    signal RegWr           : std_logic;
    signal MemWr           : std_logic;
    signal WrSrc           : std_logic;
    signal IRQ_END         : std_logic;
    signal RegSel          : std_logic;
    signal RegAff          : std_logic;
    signal ALUSrc          : std_logic;
    signal ALUCtr          : std_logic_vector(1 downto 0);
    signal RD, RN, RM      : std_logic_vector(3 downto 0);
    signal Imm8            : std_logic_vector(7 downto 0);
    signal Imm24           : std_logic_vector(23 downto 0);

    alias N is CPSR(31);
    constant ALU_ADD  : std_logic_vector(1 downto 0) := "00";  -- Y = A + B
    constant ALU_MOVB : std_logic_vector(1 downto 0) := "01";  -- Y = B
    constant ALU_SUB  : std_logic_vector(1 downto 0) := "10";  -- Y = A - B
    constant ALU_MOVA : std_logic_vector(1 downto 0) := "11";  -- Y = A
begin 
    INSTRUCTION_DECODER_inst: entity work.INSTRUCTION_DECODER
    port map(
        Instruction     =>  Instruction     ,
        CPSR            =>  CPSR            ,
        nPCsel          =>  nPCsel          ,
        PSREn           =>  PSREn           ,
        RegWr           =>  RegWr           ,
        MemWr           =>  MemWr           ,
        WrSrc           =>  WrSrc           ,
        IRQ_END         =>  IRQ_END         ,
        RegSel          =>  RegSel          ,
        RegAff          =>  RegAff          ,
        ALUSrc          =>  ALUSrc          ,
        ALUCtr          =>  ALUCtr          ,
        RD              =>  RD              ,
        RN              =>  RN              ,
        RM              =>  RM              ,
        Imm8            =>  Imm8            ,
        Imm24           =>  Imm24           
    );

    process
    type enum_instruction is (MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT, BX, ERROR);
    alias instr_courante is <<signal .instruction_decoder_tb.INSTRUCTION_DECODER_inst.instr_courante : enum_instruction >>;
    begin
        Instruction <= (others => '0');
        CPSR        <= (others => '0');
        wait for 1 ns;

        Instruction <= x"E3A01010"; -- MOV R1,#0x10 -- R1 = 0x10
        wait for 1 ns;
        assert instr_courante = MOV report "R1 = 0x10 is a MOV operation";
        assert RD = x"1"         report "R1 = 0x10 with RD = 1" severity error;
        assert RegWr = '1'       report "R1 = 0x10 with reg write on" severity error;
        assert ALUSrc = '1'      report "R1 = 0x10 with immediate enabled" severity error;
        assert ALUCtr = ALU_MOVB report "R1 = 0x10 we ignore A and keep B the imm" severity error;
        assert Imm8 = x"10"      report "R1 = 0x10 with immediate 0x10" severity error;
        -- todo: we should check the others are 0/Z

        wait for 1 ns;
        Instruction <= x"E3A02000"; -- MOV R2,#0x00 -- R2 = 0
        wait for 1 ns;
        assert instr_courante = MOV report "R2 = 0 is a MOV operation";
        assert RD = x"2"         report "R2 = 0 with RD = 2" severity error;
        assert RegWr = '1'       report "R2 = 0 with reg write on" severity error;
        assert ALUSrc = '1'      report "R2 = 0 with immediate enabled" severity error;
        assert ALUCtr = ALU_MOVB report "R2 = 0 we ignore A and keep B the imm" severity error;
        assert Imm8 = x"00"      report "R2 = 0 with immediate 0x0" severity error;
        -- todo: we should check the others are 0/Z

        wait for 1 ns;
        Instruction <= x"E4110000"; -- LDR R0,0(R1) -- R0 = DATAMEM[R1]
        wait for 1 ns;
        assert instr_courante = LDR report "R0 = DATAMEM[R1] is a LDR operation";
        assert RD = x"0"         report "R0 = DATAMEM[R1] with RD = 0" severity error;
        assert RN = x"1"         report "R0 = DATAMEM[R1] with RN = 1" severity error;
        assert RegWr = '1'       report "R0 = DATAMEM[R1] with reg write on" severity error;
        assert WrSrc = '1'       report "R0 = DATAMEM[R1] redirect output from ALU to Memory" severity error;
        assert ALUCtr = ALU_MOVA report "R0 = DATAMEM[R1] we ignore B and keep A the addr" severity error;
        -- todo: we should check the others are 0/Z

        wait for 1 ns;
        Instruction <= x"E0822000"; -- ADD R2,R2,R0 -- R2 = R2 + R0
        wait for 1 ns;
        assert instr_courante = ADDr report "R2 = R2 + R0 is an ADDr operation";
        assert RD = x"2"         report "R2 = R2 + R0 with RD = 2" severity error;
        assert RN = x"2"         report "R2 = R2 + R0 with RN = 2" severity error;
        assert RM = x"0"         report "R2 = R2 + R0 with RM = 0" severity error;
        assert RegWr = '1'       report "R2 = R2 + R0 with reg write on" severity error;
        assert ALUCtr = ALU_ADD  report "R2 = R2 + R0 is an addition" severity error;
        -- todo: we should check the others are 0/Z

        wait for 1 ns;
        Instruction <= x"E2811001"; -- ADD R1,R1,#1 -- R1 = R1 + 1
        wait for 1 ns;
        assert instr_courante = ADDi report "R1 = R1 + 1 is an ADDi operation";
        assert RD = x"1"         report "R1 = R1 + 1 with RD = 1" severity error;
        assert RN = x"1"         report "R1 = R1 + 1 with RN = 1" severity error;
        assert Imm8 = x"01"      report "R1 = R1 + 1 with imm 1" severity error;
        assert ALUSrc = '1'      report "R1 = R1 + 1 with immediate enabled" severity error;
        assert RegWr = '1'       report "R1 = R1 + 1 with reg write on" severity error;
        assert ALUCtr = ALU_ADD  report "R1 = R1 + 1 is an addition" severity error;
        -- todo: we should check the others are 0/Z

        wait for 1 ns;
        Instruction <= x"E351001A"; -- CMP R1,0x1A -- Flag = R1-0x1A,si R1 <= 0x1A
        wait for 1 ns;
        assert instr_courante = CMP report "Flag = R1-0x1A is a CMP operation";
        assert RN = x"1"         report "Flag = R1-0x1A with RN = 1" severity error;
        assert Imm8 = x"1A"      report "Flag = R1-0x1A with imm 0x1A" severity error;
        assert ALUSrc = '1'      report "Flag = R1-0x1A with immediate enabled" severity error;
        assert ALUCtr = ALU_SUB  report "Flag = R1-0x1A is a subtraction" severity error;
        assert PSREn = '1'       report "Flag = R1-0x1A updates flags N/C" severity error;
        -- todo: we should check the others are 0/Z

        wait for 1 ns;
        Instruction <= x"BAFFFFFB"; -- BLT loop -- PC =PC+1+(-5) si N = 1
        N <= '1';
        wait for 1 ns;
        N <= '0';
        assert instr_courante = BLT report "PC =PC+1+(-5) si N = 1 is a BLT operation";
        assert Imm24 = x"FFFFFB" report "PC =PC+1+(-5) si N = 1 with imm -5" severity error;
        -- todo: we should check the others are 0/Z

        wait for 1 ns;
        Instruction <= x"E4012000"; -- STR R2,0(R1) -- DATAMEM[R1] = R2
        wait for 1 ns;
        assert instr_courante = STR report "DATAMEM[R1] = R2 is a BLT operation";
        assert RD = x"2"         report "DATAMEM[R1] = R2 with RD = 2" severity error;
        assert RN = x"1"         report "DATAMEM[R1] = R2 with RN = 1" severity error;
        assert RegSel = '1'      report "DATAMEM[R1] = R2 RD is used as an input for mem data" severity error;
        assert MemWr = '1'       report "DATAMEM[R1] = R2 is writing RD data in memory at addr RN" severity error;
        -- todo: we should check the others are 0/Z

        wait for 1 ns;
        Instruction <= x"EAFFFFF7";  -- BAL main -- PC=PC+1+(-9)
        N <= '1';
        wait for 1 ns;
        N <= '0';
        assert instr_courante = BAL report "PC =PC+1+(-9) is a BLT operation";
        assert Imm24 = x"FFFFF7" report "PC =PC+1+(-9) with imm -9" severity error;
        -- todo: we should check the others are 0/Z

        Instruction <= x"EB000000";
        wait for 1 ns;
        assert instr_courante = BX report "BX end interrupt instruction";
        assert IRQ_END = '1' report "BX end interrupt instruction";

        report "No error detected";
        wait;

    end process;
    
    

end architecture;
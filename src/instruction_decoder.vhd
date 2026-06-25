library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity INSTRUCTION_DECODER is
    port(
        Instruction     : in std_logic_vector(31 downto 0);
        CPSR            : in std_logic_vector(31 downto 0);
        nPCsel          : out std_logic;
        PSREn           : out std_logic;
        RegWr           : out std_logic;
        MemWr           : out std_logic;
        WrSrc           : out std_logic;
        IRQ_END         : out std_logic := '0';
        RegSel          : out std_logic;
        RegAff          : out std_logic;
        ALUSrc          : out std_logic;
        ALUCtr          : out std_logic_vector(1 downto 0);
        RD, RN, RM      : out std_logic_vector(3 downto 0);
        Imm8            : out std_logic_vector(7 downto 0);
        Imm24           : out std_logic_vector(23 downto 0)
    );
end entity;

architecture RTL of INSTRUCTION_DECODER is
    type enum_instruction is (MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT, BX, ERROR);
    signal instr_courante: enum_instruction;

    constant ALU_ADD  : std_logic_vector(1 downto 0) := "00";  -- Y = A + B
    constant ALU_MOVB : std_logic_vector(1 downto 0) := "01";  -- Y = B
    constant ALU_SUB  : std_logic_vector(1 downto 0) := "10";  -- Y = A - B
    constant ALU_MOVA : std_logic_vector(1 downto 0) := "11";  -- Y = A

    constant COND_ALWAYS : std_logic_vector(31 downto 28) := "1110"; -- 0xE
    constant COND_LESST  : std_logic_vector(31 downto 28) := "1011";
    alias N is CPSR(31);
    alias Z is CPSR(30);

    alias OpCodeRange is Instruction(24 downto 21);
    alias OpCodeType is Instruction(27 downto 26);
    alias Condition is Instruction(31 downto 28);
    alias LiteralBit is Instruction(25);
-- 
    alias inRegDest is Instruction(15 downto 12);
    alias inRegSrcN is Instruction(19 downto 16);
    alias inRegSrcM is Instruction(3 downto 0);
begin
    process(Instruction)
    begin
        if OpCodeType = "01" then
            if Instruction(20) = '1' then
                instr_courante <= LDR;
            else
                instr_courante <= STR;
            end if;
        elsif OpCodeType = "00" then
            case OpCodeRange is
                when "1101" => instr_courante <= MOV;
                when "0100" => 
                    if LiteralBit = '0' then
                        instr_courante <= ADDr;
                    else
                        instr_courante <= ADDi;
                    end if;
                when "1010" => instr_courante <= CMP;
                when others => instr_courante <= ERROR;
            end case;
        elsif Instruction(27 downto 24) = "1010" then
            case Condition is
                when COND_ALWAYS => instr_courante <= BAL;
                when COND_LESST => instr_courante <= BLT;
                when others => instr_courante <= ERROR;
            end case;
        elsif Instruction(27 downto 24) = "1011" then
            instr_courante <= BX;
        end if;

    end process;

    -- good luck
    process(Instruction, instr_courante, CPSR)
    begin
        IRQ_END <= '0';
        nPCsel <= '0';
        PSREn  <= '0';
        RegWr  <= '0';
        MemWr  <= '0';
        WrSrc  <= '0';
        RegSel <= '0';
        RegAff <= '0';
        RN     <= "0000";
        RD     <= "0000";
        RM     <= "0000"; -- default value for unused RM
        ALUCtr <= "00";   -- default value for unused ALU
        ALUSrc <= '0';
        Imm8   <= (others => '0');
        Imm24  <= (others => '0');
        case instr_courante is
            when MOV => -- Reg = imm
                RegWr <= '1';
                RD <= inRegDest;
                ALUSrc <= '1';
                Imm8 <= Instruction(7 downto 0);
                ALUCtr <= ALU_MOVB;
            when ADDr =>
                -- if RD = RM should we just not set RM and use RegSel?
                RegWr <= '1';
                RD <= inRegDest;
                RN <= inRegSrcN;
                RM <= inRegSrcM;
                ALUCtr <= ALU_ADD;
            when ADDi =>
                RegWr <= '1';
                RD <= inRegDest;
                RN <= inRegSrcN;
                Imm8 <= Instruction(7 downto 0);
                AluSrc <= '1';
                ALUCtr <= ALU_ADD;
            when CMP =>
                -- only with immediates so far
                ALUCtr <= ALU_SUB;
                PSREn <= '1';
                RD <= inRegDest;
                RN <= inRegSrcN;
                if LiteralBit = '1' then
                    Imm8 <= Instruction(7 downto 0);
                    ALUSrc <= '1';
                else
                    RM <= inRegSrcM;
                end if;
            when LDR => -- RD = DATAMEM(RN)
                -- TODO
                ALUCtr <= ALU_MOVA;
                RD <= inRegDest;
                RN <= inRegSrcN;
                RegWr <= '1';
                WrSrc <= '1';
            when STR => -- DATAMEM(RD) = RN
                ALUCtr <= ALU_MOVA;
                RD <= inRegDest;
                RN <= inRegSrcN;
                MemWr <= '1';
                RegSel <= '1'; -- RD is used as if it was RM for data
                RegAff <= '1';  
                -- offset not yet handled
                -- PUBW not yet handled
            when BAL =>
                nPCsel <= '1';
                Imm24 <= Instruction(23 downto 0);
            when BLT =>
                if N = '1' then
                    nPCsel <= '1';
                    Imm24 <= Instruction(23 downto 0);
                end if;
            when BX =>
                IRQ_END <= '1';
            when others =>
                -- TODO
        end case;
    end process;
end architecture;
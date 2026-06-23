library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TREATMENT_UNIT is
    port (
        CLK, RESET  : in std_logic;
        RA, RB, RW : in std_logic_vector(3 downto 0);
        ALUsrc : in std_logic;
        ALUctr : in std_logic_vector(1 downto 0);
        MemWr, RegWr  : in std_logic;
        MemToReg  : in std_logic;
        ImmediateRaw : in std_logic_vector(7 downto 0);
        busB : out std_logic_vector(31 downto 0);
        CPSR: out std_logic_vector(31 downto 0)
    );
end entity;

architecture RTL of TREATMENT_UNIT is

constant IMMsize : integer := 8;

signal busA, busW, busb_int, immediat, ALUout, DataOut, MuxALUout : std_logic_vector(31 downto 0);
begin
Register_Bench_inst: entity work.Register_Bench
 port map(
    Clk => CLK,
    Reset => RESET,
    W => busW,
    RA => RA,
    RB => RB,
    RW => RW,
    WE => RegWr,
    A => busA,
    B => busB_int
);

MUX2x1_ALU_inst: entity work.MUX2x1
 generic map(
    N => 32
)
 port map(
    A => busB_int,
    B => immediat,
    COM => ALUsrc,
    S => MuxALUout
);

MUX2x1_MEM_inst: entity work.MUX2x1
 generic map(
    N => 32
)
 port map(
    A => ALUout,
    B => DataOut,
    COM => MemToReg,
    S => busW
);

ALU2_inst: entity work.ALU2
 port map(
    op => ALUctr,
    busA => busA,
    busB => MuxALUout,
    busW => ALUout,
    flagN => CPSR(31),
    flagZ => CPSR(30)
); 

SIGN_EXTENDER_inst: entity work.SIGN_EXTENDER
 generic map(
    N => IMMsize
)
 port map(
    E => ImmediateRaw,
    S => immediat
);

MEMORY_inst: entity work.MEMORY
 generic map(
    WordSize => 32,
    AddrSize => 6
)
 port map(
    CLK => CLK,
    RESET => RESET,
    DataIn => busB_int,
    DataOut => DataOut,
    Addr => ALUout(5 downto 0), -- the result == the address
    WrEn => MemWr
);

busB <= busb_int;
end architecture;
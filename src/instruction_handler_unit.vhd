library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity instruction_handler_unit is
    port(
        offset: in std_logic_vector(23 downto 0);   
        nPCsel: in std_logic;
        Clk : in std_logic;
        Reset: in std_logic;
        Instruction: out std_logic_vector(31 downto 0)
    );
end entity;

architecture IHU of instruction_handler_unit is 
    signal PC_in : std_logic_vector(31 downto 0);
    signal PC_out : std_logic_vector(31 downto 0);
    signal S : std_logic_vector(31 downto 0);

    signal A: std_logic_vector(31 downto 0);
    signal B: std_logic_vector(31 downto 0);
begin

    A <= STD_LOGIC_VECTOR(UNSIGNED(PC_out) + 1);
    B <= STD_LOGIC_VECTOR(UNSIGNED(PC_out) + 1 + UNSIGNED(S));

    PC_EXtender: entity work.SIGN_EXTENDER
    generic map (
        N => 24
    )
    port map (
        E => offset,
        S => S
    );

    Reg_PC: entity work.ONE_REGISTER
    port map (
        Clk => Clk,
        Rst => Reset,
        DataIN =>  PC_in,
        WE => '1',
        DataOut =>  PC_out 
    );

    MUX: entity work.MUX2x1
    generic map(
        N => 32
    )
    port map (
        A => A, --when nPCsel = 0
        B => B, -- when nPCsel = 1
        COM => nPCsel, 
        S => PC_in
    );

    Instruction_Memory: entity work.INSTRUCTION_MEMORY
    port map (
        PC => PC_out,
        Instruction => Instruction
    );



end architecture;
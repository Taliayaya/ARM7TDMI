library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity instruction_handler_unit is
    port(
        offset  : in std_logic_vector(23 downto 0);   
        nPCsel  : in std_logic;
        Clk     : in std_logic;
        Reset   : in std_logic;
        IRQ     : in std_logic;
        IRQ_END : in std_logic;
        VICPC   : in std_logic_vector(31 downto 0);
        Instruction: out std_logic_vector(31 downto 0);
        IRQ_SERV : out std_logic
    );
end entity;

architecture IHU of instruction_handler_unit is 
    signal PC_in : std_logic_vector(31 downto 0) := (others => '0');
    signal PC_out, LR_out : std_logic_vector(31 downto 0);
    signal LR_WE : std_logic := '0';
    signal S : std_logic_vector(31 downto 0);

    signal irq_active : std_logic := '0';
    signal A: std_logic_vector(31 downto 0);
    signal B: std_logic_vector(31 downto 0);
    signal A_saved : std_logic_vector(31 downto 0);

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

    -- Save the PC register during interrupt (Link Register)
    Reg_LR: entity work.ONE_REGISTER
    port map (
        Clk => Clk,
        Rst => Reset,
        DataIN =>  A_saved, -- we save PC + 1 instead of PC_out?
        WE => LR_WE,
        DataOut =>  LR_out 
    );

    -- MUX: entity work.MUX2x1
    -- generic map(
    --     N => 32
    -- )
    -- port map (
    --     A => A, --when nPCsel = 0
    --     B => B, -- when nPCsel = 1
    --     COM => nPCsel, 
    --     S => PC_in
    -- );

    Instruction_Memory: entity work.INSTRUCTION_MEMORY
    port map (
        PC => PC_out,
        Instruction => Instruction
    );

    -- IRQ handling
    process (Clk, Reset) begin
        if Reset = '1' then
            irq_active  <= '0';
            LR_WE       <= '0';
            IRQ_SERV    <= '0';
        elsif rising_edge(Clk) then
            LR_WE <= '0';
            IRQ_SERV <= '0';
            A_saved     <= (others => '0');
            if IRQ = '1' and irq_active = '0' then
                irq_active <= '1';
                LR_WE <= '1';
                if nPCsel = '0' then
                    A_saved <= A;
                else 
                    A_saved <= B;
                end if;
                IRQ_SERV <= '1';
            elsif IRQ_END = '1' then 
                irq_active <= '0';
            end if;
        end if;
    end process;

    -- MUX2x1 2.0
    process (IRQ, IRQ_END, irq_active, VICPC, LR_out, A, B, nPCsel) begin
        if IRQ_END = '1' then
            PC_in <= LR_out;
        elsif IRQ = '1' and irq_active = '0' then
            PC_in <= VICPC;
        else -- normal behaviour (before with the Mux2)
            if nPCsel = '0' then
                PC_in <= A;
            else
                PC_in <= B;
            end if;
        end if;
    end process;

end architecture;
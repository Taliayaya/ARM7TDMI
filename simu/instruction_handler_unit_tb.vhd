library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity INSTRUCTION_HANDLER_UNIT_TB is 
end entity;

architecture BENCH of INSTRUCTION_HANDLER_UNIT_TB is
    signal offset: STD_LOGIC_VECTOR(23 downto 0);
    signal nPCsel: STD_LOGIC;
    signal Clk: STD_LOGIC;
    signal Reset: STD_LOGIC;
    signal Instruction: STD_LOGIC_VECTOR(31 downto 0);
    signal VICPC: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal IRQ, IRQ_END, IRQ_SERV: STD_LOGIC := '0';
begin 

    process
    begin
        while now <= 300 NS loop
            Clk <= '0';
            wait for 5 NS;
            Clk <= '1';
            wait for 5 NS;
        end loop;
        wait;
    end process;
    
    IHU: entity work.INSTRUCTION_HANDLER_UNIT
    port map (
        Clk         => Clk,
        Reset       => Reset,
        offset      => offset,
        nPCsel      => nPCsel,
        IRQ         => IRQ,
        IRQ_END     => IRQ_END,
        VICPC       => VICPC,
        Instruction => Instruction,
        IRQ_SERV    => IRQ_SERV
    );

    process
    begin
        
        Reset <= '1';
        nPCsel <= '0';


        wait for 10 ns;
        Reset <= '0';

        offset <= STD_LOGIC_VECTOR(TO_UNSIGNED(0, 24));
        assert Instruction = x"E3A01010" report "offset 0" SEVERITY ERROR;
        wait for 10 ns;

        offset <= STD_LOGIC_VECTOR(TO_UNSIGNED(1, 24));
        assert Instruction = x"E3A02000" report "offset 1" SEVERITY ERROR;
        wait for 10 ns;

        offset <= STD_LOGIC_VECTOR(TO_UNSIGNED(2, 24));
        assert Instruction =x"E4110000" report "offset 2" SEVERITY ERROR;
        wait for 10 ns;
        
        offset <= STD_LOGIC_VECTOR(TO_UNSIGNED(3, 24));
        assert Instruction = x"E0822000" report "offset 3" SEVERITY ERROR;
        wait for 10 ns;

        offset <= STD_LOGIC_VECTOR(TO_UNSIGNED(4, 24));
        assert Instruction = x"E2811001" report "offset 4" SEVERITY ERROR;
        wait for 10 ns;

        offset <= STD_LOGIC_VECTOR(TO_UNSIGNED(5, 24));
        assert Instruction = x"E351001A" report "offset 5" SEVERITY ERROR;
        wait for 10 ns;

        offset <= STD_LOGIC_VECTOR(TO_UNSIGNED(6, 24));
        assert Instruction = x"BAFFFFFB" report "offset 6" SEVERITY ERROR;
        wait for 10 ns;

        offset <= STD_LOGIC_VECTOR(TO_UNSIGNED(7, 24));
        assert Instruction = x"E4012000" report "offset 7" SEVERITY ERROR;
        wait for 10 ns;

        offset <= STD_LOGIC_VECTOR(TO_UNSIGNED(8, 24));
        assert Instruction = x"EAFFFFF7" report "offset 8" SEVERITY ERROR;
        wait for 10 ns;

        Reset <= '1'; 
        wait for 10 ns;
        Reset <= '0';
        nPCsel <= '0';
        wait for 80 ns; -- PC = 8

        -- Go to index 0
        nPCsel <= '1';
        offset <= x"FFFFF7";  -- -9  PC = 8+1+(-9) = 0
        wait for 10 ns;
        assert Instruction = x"E3A01010" report "nPCsel  failed" SEVERITY ERROR;

        report "No error detected";

        wait;

    end process;
    
    

end architecture;
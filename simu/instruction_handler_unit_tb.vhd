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
        Clk => Clk,
        Reset => Reset,
        offset => offset,
        nPCsel => nPCsel,
        Instruction => Instruction
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

        nPCsel <= '1';

        offset <= STD_LOGIC_VECTOR(TO_UNSIGNED(0, 24));
        assert Instruction = x"E3A01010" report "nPCsel offset 0" SEVERITY ERROR;
        wait for 10 ns;

        offset <= STD_LOGIC_VECTOR(TO_UNSIGNED(1, 24));
        assert Instruction = x"E3A02000" report "nPCsel offset 1" SEVERITY ERROR;
        wait for 10 ns;

        offset <= STD_LOGIC_VECTOR(TO_UNSIGNED(2, 24));
        assert Instruction =x"E4110000" report "nPCsel offset 2" SEVERITY ERROR;
        wait for 10 ns;
        
        offset <= STD_LOGIC_VECTOR(TO_UNSIGNED(3, 24));
        assert Instruction = x"E0822000" report "nPCsel offset 3" SEVERITY ERROR;
        wait for 10 ns;

        offset <= STD_LOGIC_VECTOR(TO_UNSIGNED(4, 24));
        assert Instruction = x"E2811001" report "nPCsel offset 4" SEVERITY ERROR;
        wait for 10 ns;

        offset <= STD_LOGIC_VECTOR(TO_UNSIGNED(5, 24));
        assert Instruction = x"E351001A" report "nPCsel offset 5" SEVERITY ERROR;
        wait for 10 ns;

        offset <= STD_LOGIC_VECTOR(TO_UNSIGNED(6, 24));
        assert Instruction = x"BAFFFFFB" report "nPCsel offset 6" SEVERITY ERROR;
        wait for 10 ns;

        offset <= STD_LOGIC_VECTOR(TO_UNSIGNED(7, 24));
        assert Instruction = x"E4012000" report "nPCsel offset 7" SEVERITY ERROR;
        wait for 10 ns;

        offset <= STD_LOGIC_VECTOR(TO_UNSIGNED(8, 24));
        assert Instruction = x"EAFFFFF7" report "nPCsel offset 8" SEVERITY ERROR;
        wait for 10 ns;

        report "No error detected";

        wait;

    end process;
    
    

end architecture;
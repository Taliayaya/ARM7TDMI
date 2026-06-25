library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VIC_PROCESSOR_TB is 
end entity;

architecture BENCH of VIC_PROCESSOR_TB is
    signal Clk: STD_LOGIC;
    signal Reset: STD_LOGIC;
    signal Afficheur: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal IRQ0, IRQ1 : std_logic := '0';

    constant CLK_PERIOD : time := 20 ns;
begin

    process
    begin
        while now <= CLK_PERIOD * 500 loop
            Clk <= '0';
            wait for CLK_PERIOD/2;
            Clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    UUT: entity work.PROCESSOR
    port map (
        Clk        => Clk,
        Reset      => Reset,
        IRQ0       => IRQ0,
        IRQ1       => IRQ1,
        Afficheur  => Afficheur
    );

    process
    alias IRQ_SERV is <<signal .vic_processor_tb.UUT.Instruction_Handler_Unit.IRQ_SERV : std_logic >>;
    alias IRQ_END is <<signal .vic_processor_tb.UUT.Instruction_Handler_Unit.IRQ_END : std_logic >>;
    begin
        Reset <= '1';
        IRQ0  <= '0';
        IRQ1  <= '0';
        wait for CLK_PERIOD * 2;
        Reset <= '0';


        wait for CLK_PERIOD * 100;  
        assert  Afficheur = x"00000037" report "Premi�re �tape NOT OK" severity error;
        wait for 10 ns;

        IRQ0 <= '1';
        wait for CLK_PERIOD * 2;   
        IRQ0 <= '0';
        wait for 10 ps;
        -- ce test est incohérent car ça dépend de à quel moment l'interruption à lieu
        -- Lors de IRQ0 on va voir dans l'afficheur: (dans l'ordre)
        -- la valeur de R1 (à quel moment de la loop on est) (0x19)
        -- la valeur de R3 (unused)                          (0x00)
        -- la nouvelle valeur de Mem[0x10]                   (0x02)
        -- assert  Afficheur = x"00000019" report "Premier interrupt NOT OK" severity error;

        wait until IRQ_END = '1';

        wait for CLK_PERIOD * 100; -- 100 clock cycle
        assert  Afficheur = x"00000038" report "IRQ0 augmente la somme de 1 de 0x37 à 0x38 NOT OK" severity error;

        report "Done" severity note;

        IRQ1 <= '1';
        wait for CLK_PERIOD * 2;
        IRQ1 <= '0';

        wait until IRQ_END = '1';
        wait for CLK_PERIOD * 100; -- 100 clock cycle

        -- IRQ1 augmente de +2 (donc de 0x38 à 0x3A)
        assert  Afficheur = x"0000003A" report "IRQ1 augmente la somme de +2 de 0x38 à 0x3A NOT OK" severity error;

        IRQ0 <= '1';
        IRQ1 <= '1';
        wait for CLK_PERIOD * 4;
        IRQ0 <= '0';
        IRQ1 <= '0';

        -- IRQ0 et IRQ1: on devrait donc avoir 0x3B puis 0x3D et un affichage de 0x3D seulement
        wait until IRQ_END = '1';
        wait until IRQ_END = '1';

        wait for CLK_PERIOD * 100;
        assert  Afficheur = x"0000003D" report "IRQ0, IRQ1 augmente la somme de +3 de 0x3A à 0x3D NOT OK" severity error;
        
        -- wait for CLK_PERIOD * 30;
        report "Done" severity note;

        wait;
    end process;

end architecture;
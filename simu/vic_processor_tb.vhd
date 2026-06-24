library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VIC_PROCESSOR_TB is 
end entity;

architecture BENCH of VIC_PROCESSOR_TB is
    signal Clk: STD_LOGIC;
    signal Reset: STD_LOGIC;
    signal Afficheur: STD_LOGIC_VECTOR(31 downto 0);
    signal IRQ0, IRQ1 : std_logic := '0';

    constant CLK_PERIOD : time := 20 ns;
begin

    process
    begin
        while now <= 5000 NS loop
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
    begin
        Reset <= '1';
        IRQ0  <= '0';
        IRQ1  <= '0';
        wait for CLK_PERIOD * 2;
        Reset <= '0';


        wait for CLK_PERIOD * 100;  
        assert  Afficheur = x"00000037" report "Première étape NOT OK" severity error;
        wait for 10 ns;

        IRQ0 <= '1';
        wait for CLK_PERIOD * 2;   
        IRQ0 <= '0';
        wait for 10 ps;
        assert  Afficheur = x"00000019" report "Premier interrupt NOT OK" severity error;


        wait for CLK_PERIOD * 5;
        assert  Afficheur = x"00000000" report "Première étape interrupt NOT OK" severity error;
        wait for CLK_PERIOD * 5;
        assert  Afficheur = x"00000002" report "Deuxieme interrupt NOT OK" severity error;

        IRQ1 <= '1';
        wait for CLK_PERIOD * 5;
        IRQ1 <= '0';
        assert  Afficheur = x"00000000" report "Troisieme étape interrupt NOT OK" severity error;
        wait for CLK_PERIOD * 6;
        assert  Afficheur = x"00000004" report "Qutrieme étape NOT OK" severity error;


        wait for CLK_PERIOD * 20;
        assert  Afficheur = x"00000037" report "Derniere étape NOT OK" severity error;

        IRQ1 <= '1';
        IRQ0 <= '1';

        wait for CLK_PERIOD * 2;

        IRQ0 <= '0';
        IRQ1 <= '0';
        
        wait for CLK_PERIOD * 30;

        wait;
    end process;

end architecture;
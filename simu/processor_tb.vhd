library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PROCESSOR_TB is 
end entity;

architecture BENCH of PROCESSOR_TB is
    signal Clk: STD_LOGIC;
    signal Reset: STD_LOGIC;
    signal Afficheur: STD_LOGIC_VECTOR(31 downto 0);
begin 

    process
    begin
        while now <= 10000 NS loop
            Clk <= '0';
            wait for 5 NS;
            Clk <= '1';
            wait for 5 NS;
        end loop;
        wait;
    end process;
    
    PCU: entity work.PROCESSOR
    port map (
        Clk => Clk,
        Reset => Reset,
        Afficheur => Afficheur
    );

    process
    begin
        
        Reset <= '1';
        wait for 10 ns;

        Reset <= '0';
        wait for 10 ns;

        report "No error detected";

        wait;

    end process;

end architecture;
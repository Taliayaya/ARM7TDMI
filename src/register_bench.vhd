library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;




entity Register_Bench is
    port (Clk: in STD_LOGIC;
         Reset: in STD_LOGIC;
         W: in STD_LOGIC_VECTOR(31 downto 0);
         RA: in STD_LOGIC_VECTOR(4 downto 0);
         RB: in STD_LOGIC_VECTOR(4 downto 0);
         RW: in STD_LOGIC_VECTOR(4 downto 0);
         WE: in STD_LOGIC;
         A: out STD_LOGIC_VECTOR(31 downto 0);
         B: out STD_LOGIC_VECTOR(31 downto 0)   
    );
end entity Register_Bench;

architecture Behaviour of Register_Bench is
    -- Declaration Type Tableau Memoire
    type table is array(15 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
    -- Fonction d'Initialisation du Banc de Registres
    function init_bench return table is
        variable result : table;
        begin
            for i in 14 downto 0 loop
                result(i) := (others=>'0');
            end loop;
            result(15):=X"00000030";
            return result;
    end init_bench;
    
    -- Déclaration et Initialisation du Banc de Registres 16x32 bits
    signal Bench: table:=init_bench;
begin process (Clk, Reset)
begin
    if Reset = '1' then
        Bench <= init_bench;
    elsif rising_edge(Clk) then
        A <= Bench(TO_INTEGER(UNSIGNED(RA)));
        B <= Bench(TO_INTEGER(UNSIGNED(RB)));
        if WE = '1' then
            Bench(TO_INTEGER(UNSIGNED(RW))) <= W;
        end if;

    end if;
end process;
end architecture;

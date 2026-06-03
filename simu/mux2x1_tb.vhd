library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MUX2x1_TB is

end MUX2x1_TB ;


architecture BENCH of MUX2x1_TB is
    constant N : integer := 32;
	signal busA, busB, busW : std_logic_vector(N - 1 downto 0);
	signal COM : std_logic;
	
begin
	process
	begin
		busA <= x"0000_3333" ;
		busB <= x"0000_8686";
        COM  <= '0';
        wait for 1 ns;

        assert busW = busA report "Mux selects A" severity error;

        COM <= '1';
        wait for 1 ns;

        assert busW = busB report "Mux selects B" severity error;

		report "End of test. Verify that no error was reported.";
		wait;
		
	end process;
    MUX2x1_inst: entity work.MUX2x1
     port map(
        A => busA,
        B => busB,
        S => busW,
        COM => COM
    );
end bench;
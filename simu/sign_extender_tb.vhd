library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity SIGN_EXTENDER_TB is

end SIGN_EXTENDER_TB ;


architecture BENCH of SIGN_EXTENDER_TB is
    constant N1 : integer := 8;
    constant N2 : integer := 16;
	signal E1: std_logic_vector(N1 - 1 downto 0);
	signal E2: std_logic_vector(N2 - 1 downto 0);
    signal S1, S2 : std_logic_vector(31 downto 0);
	
begin
	process
	begin
		E1 <= x"86";
		E2 <= x"8686";
        assert signed(S1) = x"86"  report "sign should remains correct" severity error;
        assert signed(S2) = x"8686"  report "sign should remains correct" severity error;

        wait for 1 ns;
		E1 <= std_logic_vector(- signed(E1));
		E2 <= std_logic_vector(- signed(E2));
        assert signed(S1) = -x"86"  report "sign should remains correct" severity error;
        assert signed(S2) = -x"8686"  report "sign should remains correct" severity error;

		report "End of test. Verify that no error was reported.";
		wait;
		
	end process;
    SIGN_EXTENDER_inst1: entity work.SIGN_EXTENDER
    generic map (
        N => N1
    )
     port map(
        E => E1,
        S => S1
    );
    SIGN_EXTENDER_inst2: entity work.SIGN_EXTENDER
    generic map (
        N => N2
    )
     port map(
        E => E2,
        S => S2
    );
end bench;
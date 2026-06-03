library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ALU2_TB is

end ALU2_TB ;


architecture BENCH of ALU2_TB is
    constant ADD  : std_logic_vector(1 downto 0) := "00";  -- Y = A + B
    constant MOVB : std_logic_vector(1 downto 0) := "01";  -- Y = B
    constant SUB  : std_logic_vector(1 downto 0) := "10";  -- Y = A - B
    constant MOVA : std_logic_vector(1 downto 0) := "11";  -- Y = A


	signal busA, busB, busW : std_logic_vector(31 downto 0);
	signal op : std_logic_vector(1 downto 0);
	signal flagN, flagZ : std_logic;
	
begin
	process
	begin
		busA <= x"0000_0001" ;
		busB <= x"0000_0001";
        op <= ADD;
        wait for 1 ns;

        assert busW = x"0000_0002" report "1 + 1 = 2" severity error;
        assert flagN = '0'         report "2 is positive" severity error;
        assert flagZ = '0'         report "2 is positive" severity error;

        busA <= x"FFFF_FFFF" ;
		busB <= x"0000_0001";
        op <= ADD;
        wait for 1 ns;

        assert busW = x"0000_0000" report "-1 + 1 = 0" severity error;
        assert flagN = '0'         report "0 is not positive" severity error;
        assert flagZ = '1'         report "0 is zero" severity error;


        busA <= x"0000_0001" ;
		busB <= x"0000_0001";
        op <= SUB;
        wait for 1 ns;

        assert busW = x"0000_0000" report "1 - 1 = 0" severity error;
        assert flagN = '0'         report "0 is zero" severity error;
        assert flagZ = '1'         report "0 is zero" severity error;

		busa <= x"0000_0001" ;
		busb <= x"0000_0002";
        op <= SUB;
        wait for 1 ns;

        assert signed(busW) = -1 report "1 - 2 = -1" severity error;
        assert flagN = '1'       report "-1 is negative" severity error;
        assert flagZ = '0'       report "-1 is non zero" severity error;

        busA <= x"0000_8686" ;
		busB <= x"0000_0001";
        op <= MOVA;
        wait for 1 ns;

        assert busW = x"0000_8686" report "Y = A" severity error;
        assert flagN = '0'         report "A is positive" severity error;
        assert flagZ = '0'         report "A is  non zero" severity error;

        busA <= x"0000_0001" ;
		busB <= x"8686_0000";
        op <= MOVB;
        wait for 1 ns;

        assert busW = x"8686_0000" report "Y = B" severity error;
        assert flagN = '1'         report "B is negative" severity error;
        assert flagZ = '0'         report "B is  non zero" severity error;


		report "End of test. Verify that no error was reported.";
		wait;
		
	end process;
    ALU2_inst: entity work.ALU2
     port map(
        op => op,
        busA => busA,
        busB => busB,
        busW => busW,
        flagN => flagN,
        flagZ => flagZ
    );
end bench;
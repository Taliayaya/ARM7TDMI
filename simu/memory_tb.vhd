library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MEMORY_TB is

end MEMORY_TB ;


architecture BENCH of MEMORY_TB is
    constant DataSize : integer := 32;
	signal DataIn, DataOut : std_logic_vector(DataSize - 1 downto 0);
    signal Addr : std_logic_vector(5 downto 0) := (others => '0');
	signal CLK, RESET, WrEn : std_logic := '0';
	
begin
    process
    begin
        while now <= 3000 NS loop
        CLK <= '0';
        wait for 5 NS;
        CLK <= '1';
        wait for 5 NS;
        end loop;
        wait;
    end process;

	process
	begin
    --  Write into all the Ram contents by driving the data bus

        for i in 0 to 63 loop
            Addr <= Std_logic_vector(To_unsigned(I, 6));
            DataIn <= std_logic_vector(to_unsigned(I, 32));
            wait for 10 NS;
            WrEn <= '1';
            wait for 10 NS;
            WrEn <= '0';
            wait for 10 NS;
        end loop;

    --  Verify data integrity

        for i in 0 to 63 loop
            Addr <= Std_logic_vector(To_unsigned(I, 6));
            wait for 10 NS;
            assert to_integer(unsigned(DataOut)) = i report "Invalid data" severity note;
        end loop;

		report "End of test. Verify that no error was reported.";
		wait;
		
	end process;
    MEMORY_inst: entity work.MEMORY
     port map(
        CLK => CLK,
        RESET => RESET,
        DataIn => DataIn,
        DataOut => DataOut,
        Addr => Addr,
        WrEn => WrEn
    );
end bench;
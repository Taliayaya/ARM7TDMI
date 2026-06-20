library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VIC_TB is
end entity;

architecture RTL of VIC_TB is

    signal CLK, RESET : std_logic;
    signal IRQ_SERV, IRQ0, IRQ1, IRQ : std_logic;
    signal VICPC : std_logic_vector(31 downto 0);
begin
    VIC_inst: entity work.VIC
        port map (
            CLK => CLK,
            RESET => RESET,
            IRQ_SERV => IRQ_SERV,
            IRQ0 => IRQ0,
            IRQ1 => IRQ1,
            IRQ => IRQ,
            VICPC => VICPC
        );
process begin
    while now <= 250 NS loop
        CLK <= '0';
        wait for 5 NS;
        CLK <= '1';
        wait for 5 NS;
    end loop;
    wait;
end process;
process begin
    RESET    <= '1';
    IRQ0     <= '0';
    IRQ1     <= '0';
    IRQ_SERV <= '0';
    wait for 1 ns;
    RESET <= '0';

    -- ============= BASIC INTERRUPTS 
    -- interrupt 0 received!
    IRQ0 <= '1';
    wait for 10 ns;
    IRQ0 <= '0';
    assert IRQ = '1' report "An IRQ should be detected" severity ERROR;
    assert VICPC = x"00000009" report "IRQ0 PC is 0x9" severity ERROR;
    -- handle interrupt
    IRQ_SERV <= '1';
    wait for 10 ns;
    IRQ_SERV <= '0';
    assert IRQ = '0' report "No IRQ should be up" severity ERROR;
    assert VICPC = x"00000000" report "PC should be reset" severity ERROR;

    -- interrupt 1 received!
    IRQ1 <= '1';
    wait for 10 ns;
    IRQ1 <= '0';
    assert IRQ = '1' report "An IRQ should be detected" severity ERROR;
    assert VICPC = x"00000015" report "IRQ1 PC is 0x15" severity ERROR;
    -- handle interrupt
    IRQ_SERV <= '1';
    wait for 10 ns;
    IRQ_SERV <= '0';
    assert IRQ = '0' report "No IRQ should be up" severity ERROR;
    assert VICPC = x"00000000" report "PC should be reset" severity ERROR;

    -- ============= INTERRUPTS 2: Ensure executed only once
    -- interrupt 0 received!
    IRQ0 <= '1';
    wait for 10 ns;
    -- IRQ0 <= '0'; -- IRQ0 is not reset to 0
    assert IRQ = '1' report "An IRQ should be detected" severity ERROR;
    assert VICPC = x"00000009" report "IRQ0 PC is 0x9" severity ERROR;
    -- handle interrupt
    IRQ_SERV <= '1';
    wait for 10 ns;
    IRQ_SERV <= '0';
    wait for 10 ns; -- even if IRQ0 is up, it didnt go down so its still the same signal
    assert IRQ = '0' report "No IRQ should be up" severity ERROR;
    assert VICPC = x"00000000" report "PC should be reset" severity ERROR;
    IRQ0 <= '0';

    -- interrupt 1 received!
    IRQ1 <= '1';
    wait for 10 ns;
    -- IRQ1 <= '0'; -- IRQ1 is not reset to 0
    assert IRQ = '1' report "An IRQ should be detected" severity ERROR;
    assert VICPC = x"00000015" report "IRQ1 PC is 0x15" severity ERROR;
    -- handle interrupt
    IRQ_SERV <= '1';
    wait for 10 ns;
    IRQ_SERV <= '0';
    wait for 10 ns; -- even if IRQ1 is up, it didnt go down so its still the same signal
    assert IRQ = '0' report "No IRQ should be up" severity ERROR;
    assert VICPC = x"00000000" report "PC should be reset" severity ERROR;
    IRQ1 <= '0';

    -- ============= INTERRUPTS 3: Ensure priority
    -- interrupt 0 received!
    IRQ0 <= '1';
    wait for 10 ns;
    IRQ0 <= '0';
    assert IRQ = '1' report "An IRQ should be detected" severity ERROR;
    assert VICPC = x"00000009" report "IRQ0 PC is 0x9" severity ERROR;

    -- interrupt 1 received!
    IRQ1 <= '1';
    wait for 10 ns;
    IRQ1 <= '0';
    assert IRQ = '1' report "An IRQ should be detected" severity ERROR;
    assert VICPC = x"00000009" report "IRQ0 has priority" severity ERROR;

    -- handle interrupt
    IRQ_SERV <= '1';
    wait for 10 ns;
    IRQ_SERV <= '0';
    assert IRQ = '1' report "IRQ1 wasn't handled yet" severity ERROR;
    assert VICPC = x"00000015" report "IRQ1 wasn't handled yet" severity ERROR;

    -- handle interrupt
    IRQ_SERV <= '1';
    wait for 10 ns;
    IRQ_SERV <= '0';
    assert IRQ = '0' report "No IRQ should be up" severity ERROR;
    assert VICPC = x"00000000" report "PC should be reset" severity ERROR;

    -- now in reverse order
    
    -- interrupt 1 received!
    IRQ1 <= '1';
    wait for 10 ns;
    IRQ1 <= '0';
    assert IRQ = '1' report "An IRQ should be detected" severity ERROR;
    assert VICPC = x"00000015" report "IRQ1 PC is 0x15" severity ERROR;

    -- interrupt 0 received!
    IRQ0 <= '1';
    wait for 10 ns;
    IRQ0 <= '0';
    assert IRQ = '1' report "An IRQ should be detected" severity ERROR;
    assert VICPC = x"00000009" report "IRQ0 PC is now 0x9" severity ERROR;

    -- handle interrupt
    IRQ_SERV <= '1';
    wait for 10 ns;
    IRQ_SERV <= '0';
    assert IRQ = '1' report "IRQ1 wasn't handled yet" severity ERROR;
    assert VICPC = x"00000015" report "IRQ1 wasn't handled yet" severity ERROR;

    -- handle interrupt
    IRQ_SERV <= '1';
    wait for 10 ns;
    IRQ_SERV <= '0';
    assert IRQ = '0' report "No IRQ should be up" severity ERROR;
    assert VICPC = x"00000000" report "PC should be reset" severity ERROR;

    -- ============= does IRQ_SERV deactive both if stay up? currently yes
    -- interrupt 1 received!
    IRQ1 <= '1';
    wait for 10 ns;
    IRQ1 <= '0';
    assert IRQ = '1' report "An IRQ should be detected" severity ERROR;
    assert VICPC = x"00000015" report "IRQ1 PC is 0x15" severity ERROR;

    -- interrupt 0 received!
    IRQ0 <= '1';
    wait for 10 ns;
    IRQ0 <= '0';
    assert IRQ = '1' report "An IRQ should be detected" severity ERROR;
    assert VICPC = x"00000009" report "IRQ0 PC is now 0x9" severity ERROR;

    -- handle interrupt
    IRQ_SERV <= '1';
    wait for 50 ns; -- if IRQ_SERV is up for a long time, it will deactivate both IRQ, Do we want that or not?
    IRQ_SERV <= '0';
    assert IRQ = '0' report "IRQ1 remains" severity ERROR;
    assert VICPC = x"00000000" report "IRQ1 remains" severity ERROR;

    report "End of test. Verify that no error was reported.";
    wait;
end process;
end architecture;
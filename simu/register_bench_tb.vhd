library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Register_Bench_tb is
end entity;


architecture Bench of Register_Bench_tb is
    signal Clk: STD_LOGIC;
    signal Reset: STD_LOGIC;
    signal W:  STD_LOGIC_VECTOR(31 downto 0);
    signal RA: STD_LOGIC_VECTOR(3 downto 0);
    signal RB: STD_LOGIC_VECTOR(3 downto 0);
    signal RW: STD_LOGIC_VECTOR(3 downto 0);
    signal WE: STD_LOGIC;
    signal A: STD_LOGIC_VECTOR(31 downto 0);
    signal B: STD_LOGIC_VECTOR(31 downto 0);

    signal op: std_logic_vector(1 downto 0);
    signal flagN, flagZ : std_logic;
     
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

    process 
    begin

        RA <= "0000";
        RB <= "0000";
        RW <= "0000";

        WE <= '0';
        OP <= "00";

        Reset <= '1';
        wait for 10 ns;

        
       Reset <= '0';
       WE <= '1';

-- R(1) = R(15) 
        OP <= "01";
        RW <= "0001";
        RA <= "0000";
        RB <= "1111";
        wait for 100 ns;
        WE <= '0';


        RA <= "0001";
        wait for 10 ns;

        assert A = X"00000030" report "R(1) = R(15) should save value" severity error;
        wait for 10 ns;


-- R(1) = R(1) + R(15)
        WE <= '1';
        OP <= "00";
        RW <= "0001";
        RA <= "0001";
        RB <= "1111";

        wait for 10 ns;
        WE <= '0';
        assert A = X"00000060" report "R(1) = R(1) + R(15) should save value" severity error;
        wait for 10 ns;


-- R(2) = R(1) + R(15)

        WE <= '1';
        RW <= "0010";
        RA <= "0001";
        RB <= "1111";

        wait for 10 ns;
        WE <= '0';
        RA <= "0010";
        wait for 3 ns;
        assert A = X"00000090" report "R(2) = R(1) + R(15) should save value" severity error;


        wait for 10 ns;

-- R(3) = R(1) – R(15)

        WE <= '1';
        OP <= "10";
        RW <= "0011";
        RA <= "0001";
        RB <= "1111";

        wait for 10 ns;
        WE <= '0';

        RA <= "0011";
        wait for 10 ns;
        assert A = X"00000030" report "R(3) = R(1) - R(15) should save value" severity error;

        wait for 10 ns;


-- R(5) = R(7) – R(15)
        
        WE <= '1';
        RW <= "0101";
        RA <= "0111";
        RB <= "1111";

        wait for 10 ns;
        WE <= '0';

        RA <= "0101";
        wait for 2 ns;
        assert A =  X"FFFFFFD0" report "R(5) = R(7) - R(15) should save value" severity error;

        wait for 10 ns;


        report "End of test. Verify that no error was reported.";
        wait;
    
    end process;

   Registers : entity work.Register_Bench 
        port map(
            Clk => Clk, 
            Reset => Reset,
            W => W,
            RA => RA,
            RB => RB,
            RW => RW,
            WE => WE,
            A => A,
            B => B  
        );
    ALU : entity work.ALU2
        port map(
        op   => op,
        busA => A, 
        busB => B,  
        busW => W,
        flagN => flagN, 
        flagZ => flagZ 
    ); 
end bench;
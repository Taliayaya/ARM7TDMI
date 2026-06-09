library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity TREATMENT_UNIT_TB is

end TREATMENT_UNIT_TB ;


architecture BENCH of TREATMENT_UNIT_TB is
    signal CLK, RESET   : std_logic;
    signal RA, RB, RW   : std_logic_vector(3 downto 0);
    signal ALUsrc       : std_logic;
    signal ALUctr       : std_logic_vector(1 downto 0);
    signal MemWr, RegWr : std_logic;
    signal MemToReg     : std_logic;
    signal busW         :  std_logic_vector(31 downto 0);
    signal immediate    :  std_logic_vector(7 downto 0);

    constant ADD  : std_logic_vector(1 downto 0) := "00";  -- Y = A + B
    constant MOVB : std_logic_vector(1 downto 0) := "01";  -- Y = B
    constant SUB  : std_logic_vector(1 downto 0) := "10";  -- Y = A - B
    constant MOVA : std_logic_vector(1 downto 0) := "11";  -- Y = A
begin
    TREATMENT_UNIT_inst: entity work.TREATMENT_UNIT
     port map(
        CLK => CLK,
        RESET => RESET,
        RA => RA,
        RB => RB,
        RW => RW,
        ALUsrc => ALUsrc,
        ALUctr => ALUctr,
        MemWr => MemWr,
        RegWr => RegWr,
        MemToReg => MemToReg,
        busW => busW,
        ImmediateRaw => immediate
    );
    process
    begin
        while now <= 200 NS loop
            Clk <= '0';
            wait for 5 NS;
            Clk <= '1';
            wait for 5 NS;
        end loop;
        wait;
    end process;

	process
	type table is array(15 downto 0) of std_logic_vector(31 downto 0);
    alias bench is <<signal .treatment_unit_tb.TREATMENT_UNIT_inst.Register_Bench_inst.Bench : table >>;
    type MEM_TABLE is array (0 to 63) of std_logic_vector(31 downto 0);
    alias memory is <<signal .treatment_unit_tb.TREATMENT_UNIT_inst.MEMORY_inst.table : MEM_TABLE>>; 
	begin
        -- INIT --
        RA <= "0000";
        RB <= "0000";
        RW <= "0000";
        MemToReg <= '0';
        MemWr <= '0';
        RegWr <= '0';
        ALUctr <= "00";
        ALUsrc <= '0';
        Immediate <= (others => '0');

        RESET <= '1';
        wait for 1 ns;
        RESET <= '0';
        wait for 1 ns;
        -- ADD 2 REGISTERS -- 0x8 + 0x5 = 0xd
        bench(2) <= force x"00000008"; -- pre filling the registers value
        bench(6) <= force x"00000005";
        wait for 1 ns;
        
        ALUctr <= ADD;
        RA <= x"2";
        RB <= x"6";
        RW <= "0001";
        RegWr <= '1';
        wait for 10 ns;
        RegWr <= '0';
        -- assert <<signal TREATMENT_UNIT_inst.busW : std_logic_vector(31 downto 0)>> = x"0000000D"
        --     report "Erreur : 8 + 5 = 13 (0xd) !" 
        --     severity error;
        assert busW = x"0000000D"
            report "Erreur : 8 + 5 = 13 (0xd) !" 
            severity error;

        wait for 10 ns;
        -- ADD 1 REGISTER AND IMMEDIATE -- 0x8 + 0x11 = 0x19

        RW <= "0010";
        immediate <= x"11";
        ALUctr <= ADD;
        ALUsrc <= '1';
        RegWr <= '1';
        wait for 10 ns;
        RegWr <= '0';
        ALUsrc <= '0';
        assert busW = x"00000019"
            report "Erreur : 8 + 17 = 25 (0x19) !" 
            severity error;

        wait for 10 ns;
        -- SUB 2 REGISTERS -- 0x8 - 0x5 = 0x3
        ALUctr <= SUB;
        RW <= "0011";
        RegWr <= '1';
        RA <= x"2";
        RB <= x"6";
        wait for 10 ns;
        RegWr <= '0';
        assert busW = x"00000003"
            report "Erreur : 8 - 5 = 3 (0x3) !" 
            severity error;

        wait for 10 ns;

        -- SUB 1 REGISTER AND IMMEDIATE -- 0x8 - 0x7 = 0x1
        RW <= "0100";
        immediate <= x"07";
        ALUctr <= SUB;
        ALUsrc <= '1';
        RegWr <= '1';
        wait for 10 ns;
        RegWr <= '0';
        ALUsrc <= '0';
        assert busW = x"00000001"
            report "Erreur : 8 + 7 = 1 (0x1) !" 
            severity error;

        wait for 10 ns;

        -- COPY 1 REGISTER B -- Y(5) = B(6) = 0x5 -- 
        RW <= "0101";
        RA <= x"2";
        RB <= x"6";
        ALUctr <= MOVB;
        RegWr <= '1';
        wait for 10 ns;
        RegWr <= '0';
        assert busW = x"00000005"
            report "Erreur : Y = B = 5 (0x5) !" 
            severity error;
        assert bench(5) = x"00000005"
            report "Erreur : Y = B = 5 (0x5) !" 
            severity error;

        wait for 10 ns;

        -- COPY 1 REGISTER A -- Y(5) = A(2) = 0x8 -- 
        RW <= "0101";
        RA <= x"2";
        RB <= x"6"; -- unused
        ALUctr <= MOVA;
        RegWr <= '1';
        wait for 10 ns;
        RegWr <= '0';
        assert busW = x"00000008"
            report "Erreur : Y = A = 8 (0x8) !" 
            severity error;
        assert bench(5) = x"00000008"
            report "Erreur : Y = A = 8 (0x8) !" 
            severity error;

        wait for 10 ns;

        -- COPY Immediate to Register -- Y(5) = 0x86 -- 
        RW <= "0101";
        Immediate <= x"86";
        RA <= x"2"; -- unused
        RB <= x"6"; -- unused
        ALUctr <= MOVB;
        RegWr <= '1';
        Alusrc <= '1';
        wait for 10 ns;
        RegWr <= '0';
        Alusrc <= '0';
        assert busW = x"FFFFFF86" -- its getting sign extended to 32 bits!!
            report "Erreur : Y = 0xFFFFFF86 !" 
            severity error;
        assert bench(5) = x"FFFFFF86"
            report "Erreur : Y = 0xFFFFFFFF86 !" 
            severity error;

        wait for 10 ns;

        -- COPY 1 REGISTER A to memory -- M(RA) = RB -- M(8) = 0x5
        RW <= "0101"; -- unused
        RA <= x"2"; -- value is address to write in memory
        RB <= x"6"; -- value is data    to write in memory
        ALUctr <= MOVA;
        MemWr <= '1';
        wait for 10 ns;
        MemWr <= '0';
        assert memory(8) = x"00000005"
            report "Erreur : M(8) = 5 (0x5) !" 
            severity error;

        wait for 10 ns;

        -- READ memory from REGISTER -- M(RA) = RB -- M(8) = 0x5
        RW <= "0101"; -- unused
        RA <= x"2"; -- value is address to write in memory
        RB <= x"6"; -- unused
        ALUctr <= MOVA;
        MemToReg <= '1';
        wait for 10 ns;
        MemToReg <= '0';
        assert busW = x"00000005"
            report "Erreur : M(8) = 5 (0x5) !" 
            severity error;

        wait for 10 ns;


		report "End of test. Verify that no error was reported.";
		wait;
		
	end process;

end bench;
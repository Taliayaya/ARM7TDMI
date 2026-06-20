library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity VIC is
  port (
    CLK         : in std_logic;
    RESET       : in std_logic;
    IRQ_SERV    : in std_logic;
    IRQ0, IRQ1  : in std_logic;

    IRQ         : out std_logic;
    VICPC      : out std_logic_vector(31 downto 0)
  ) ;
end entity;

architecture RTL of VIC is
    signal IRQ_prev : std_logic_vector(1 downto 0);
    signal IRQ_memo : std_logic_vector(1 downto 0);

begin
process (CLK, RESET) begin
    if RESET = '1' then
        IRQ_memo    <= (others => '0');
        IRQ_prev    <= (others => '0');
    elsif rising_edge(CLK) then
        IRQ_prev(0) <= IRQ0;
        IRQ_prev(1) <= IRQ1;
        if IRQ_prev(0) = '0' and IRQ0 = '1' then
            IRQ_memo(0) <= '1';
        elsif IRQ_SERV = '1' and IRQ_memo(0) = '1' then
            IRQ_memo(0) <= '0';
        end if;

        if IRQ_prev(1) = '0' and IRQ1 = '1' then
            IRQ_memo(1) <= '1';
        elsif IRQ_SERV = '1' and IRQ_memo(1) = '1' and IRQ_memo(0) = '0' then
            IRQ_memo(1) <= '0';
        end if;
    end if;
end process;

process (IRQ_memo) begin
    if IRQ_memo(0) = '1' then -- highest priority 
        VICPC <= x"00000009";
    elsif IRQ_memo(1) = '1' then
        VICPC <= x"00000015";
    else -- no request => forced to 0
        VICPC <= x"00000000";
    end if;
end process;
IRQ <= IRQ_memo(0) or IRQ_memo(1);
end architecture ;
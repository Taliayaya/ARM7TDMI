library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEMORY is
    generic (WordSize : integer := 32;
             AddrSize : integer := 6);
    port (
        CLK     : in std_logic;
        RESET   : in std_logic;
        DataIn  : in std_logic_vector(WordSize - 1 downto 0); -- Bus de donnés en écriture sur 32 bits
        DataOut : out std_logic_vector(WordSize -1 downto 0); -- Bus de donnés en écriture sur 32 bits
        Addr    : in std_logic_vector(AddrSize - 1 downto 0); -- Bus d'adresses en lecture et écriture sur 6 bits
        WrEn    : in std_logic
    );
end entity;

architecture RTL of MEMORY is
constant WordCount : INTEGER := 2**AddrSize;
type MEM_TABLE is array (0 to WordCount - 1) of std_logic_vector(DataIn'range);
signal table : MEM_TABLE; 
begin
process (CLK, RESET) begin
    if RESET = '1' then
        table <= (others => (others => '0'));
    elsif rising_edge(CLK) then
        if WrEn = '1' then
            table(to_integer(unsigned(Addr))) <= DataIn;
        end if;
    end if;
end process;
    DataOut <= table(to_integer(unsigned(Addr)));

end architecture;
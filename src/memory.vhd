library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEMORY is
    generic (
        WordSize : integer := 32;
        AddrSize : integer := 6
    );
    port (
        CLK     : in  std_logic;
        RESET   : in  std_logic;
        DataIn  : in  std_logic_vector(WordSize - 1 downto 0);
        DataOut : out std_logic_vector(WordSize - 1 downto 0) := (others => '0');
        Addr    : in  std_logic_vector(AddrSize - 1 downto 0);
        WrEn    : in  std_logic
    );
end entity;

architecture RTL of MEMORY is

    constant WordCount : integer := 2**AddrSize;
    type MEM_TABLE is array (0 to WordCount - 1) of std_logic_vector(WordSize - 1 downto 0);

    function init_mem return MEM_TABLE is
        variable result : MEM_TABLE;
    begin
        for i in 0 to WordCount - 1 loop
            result(i) := (others => '0');
        end loop;
        -- Initialisation des donn�es de 0x10 � 0x19
        result(16) := x"00000001";
        result(17) := x"00000002";
        result(18) := x"00000003";
        result(19) := x"00000004";
        result(20) := x"00000005";
        result(21) := x"00000006";
        result(22) := x"00000007";
        result(23) := x"00000008";
        result(24) := x"00000009";
        result(25) := x"0000000A";
        return result;
    end init_mem;

    signal table : MEM_TABLE := init_mem;

begin

    process (CLK, RESET) begin
        if RESET = '1' then
            table <= init_mem;       -- reset remet les donn�es initiales
        elsif rising_edge(CLK) then
            if WrEn = '1' then
                table(to_integer(unsigned(Addr))) <= DataIn;
            end if;
        end if;
    end process;

    DataOut <= table(to_integer(unsigned(Addr)));

end architecture;
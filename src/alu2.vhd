library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU2 is
    port (
        op    : in std_logic_vector(1 downto 0);
        busA, busB  : in std_logic_vector(31 downto 0);
        busW     : out std_logic_vector(31 downto 0);
        flagN, flagZ : out std_logic
    );
end entity;

architecture RTL of ALU2 is
constant ADD  : std_logic_vector(1 downto 0) := "00";  -- Y = A + B
constant MOVB : std_logic_vector(1 downto 0) := "01";  -- Y = B
constant SUB  : std_logic_vector(1 downto 0) := "10";  -- Y = A - B
constant MOVA : std_logic_vector(1 downto 0) := "11";  -- Y = A

signal result : signed(busW'range);
begin
with op select
    result <= signed(busA) + signed(busB) when ADD,
              signed(busA) - signed(busB) when SUB,
              signed(busB)                when MOVB,
              signed(busA)                when MOVA,
            (others => '0')               when others;

busW  <= std_logic_vector(result);
flagN <= '1' when result < 0 else '0';
flagZ <= '1' when result = 0 else '0';

end architecture;
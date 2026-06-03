library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX2x1 is
    generic (
        N : integer := 32
    );
    port (
        A, B: in std_logic_vector(N - 1 downto 0);
        COM : in std_logic;
        S : out std_logic_vector(N - 1 downto 0)
    );
end entity;

architecture RTL of MUX2x1 is
begin
    S <= A when COM = '0' else B;
end architecture;
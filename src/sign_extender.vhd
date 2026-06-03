library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SIGN_EXTENDER is
    generic (
        N: integer
    );
    port (
        E : in std_logic_vector(N - 1 downto 0);
        S : out std_logic_vector(31 downto 0)
    );
end entity;

architecture RTL of SIGN_EXTENDER is
begin
    S <= (31 downto N  => E(N - 1)) & E;
end architecture;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ONE_REGISTER is
    port (Clk: in STD_LOGIC;
         Reset: in STD_LOGIC;
         W: in STD_LOGIC_VECTOR(31 downto 0);
         Value: out STD_LOGIC_VECTOR(31 downto 0)   
    );
end entity;

architecture Behaviour of ONE_REGISTER is
    
begin process (Clk, Reset)
begin
    if Reset = '1' then
        Value <= (others => '0');
    elsif rising_edge(Clk) then
            Value <= W;
    end if;
end process;
end architecture;

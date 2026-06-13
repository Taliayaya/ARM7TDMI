library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ONE_REGISTER is
    port (Clk: in STD_LOGIC;
         Rst: in STD_LOGIC;
         WE: in STD_LOGIC;
         DataIN: in STD_LOGIC_VECTOR(31 downto 0);
         DataOut: out STD_LOGIC_VECTOR(31 downto 0) := (others => '0')
    );
end entity;

architecture Behaviour of ONE_REGISTER is
    
begin process (Clk, Rst)
begin
    if Rst = '1' then
        DataOut <= (others => '0');
    elsif rising_edge(Clk) then
        if WE = '1' then
            DataOut <= DataIN;
        end if;
    end if;
end process;
end architecture;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY TOP_LEVEL is
	PORT
	(
		CLOCK_50 	:  IN  STD_LOGIC;
		KEY			 	:  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		SW 				:  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0 			:  OUT  STD_LOGIC_VECTOR(0 TO 6);
		HEX1 			:  OUT  STD_LOGIC_VECTOR(0 TO 6);
		HEX2 			:  OUT  STD_LOGIC_VECTOR(0 TO 6);
		HEX3 			:  OUT  STD_LOGIC_VECTOR(0 TO 6)
	);
END entity;

ARCHITECTURE RTL OF TOP_LEVEL IS 

	signal 	rst, clk, pol  : std_logic;
	signal irq0, irq1 : std_logic;
	signal Afficheur: STD_LOGIC_VECTOR(31 downto 0);

BEGIN 

clk <= CLOCK_50;
rst <= SW(0);
pol <= SW(9);
irq0 <= not KEY(0);
irq1 <= not KEY(1);

PROCESSOR: entity work.PROCESSOR port map (
	CLK => clk,
	Reset => rst,
	IRQ0 => irq0,
	IRQ1 => irq1,
	Afficheur => Afficheur
);

S1: entity work.SEVEN_SEG port map (
	Data => Afficheur(3 downto 0),
	Pol => pol,
	Segout => HEX0
);
S2: entity work.SEVEN_SEG port map (
	Data => Afficheur(7 downto 4),
	Pol => pol,
	Segout => HEX1
);
S3: entity work.SEVEN_SEG port map (
	Data => Afficheur(11 downto 8),
	Pol => pol,
	Segout => HEX2
);
S4: entity work.SEVEN_SEG port map (
	Data => Afficheur(15 downto 12),
	Pol => pol,
	Segout => HEX3
);
end architecture;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use constants.all;

entity clock_divider_2 is
	Port ( 
		clk_50 	: in   std_logic; 	
		clk_25    : out  std_logic		
   );
end clock_divider_2;

architecture Behavioral of clock_divider_2 is
signal clk_25_s : std_logic;
begin
process(clk_50)
begin
	if (rising_edge(clk_50)) then
		clk_25_s <= not clk_25_s;
	end if;
end process;
clk_25 <= clk_25_s;
end Behavioral;


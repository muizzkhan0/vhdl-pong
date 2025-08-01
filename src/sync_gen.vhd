library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use constants.all;

entity sync_gen is
	port( 
		clk       : in std_logic;
      h_count   : in natural range 0 to h_total-1;
      v_count   : in natural range 0 to v_total-1;
      h_sync    : out std_logic;
      v_sync    : out std_logic
	);
end sync_gen;

architecture Behavioral of sync_gen is
signal h_sync_s : std_logic;
signal v_sync_s : std_logic;
begin
--h_sync
process(clk)
begin
	if (rising_edge(clk)) then
		if ((h_count > h_sync1 - 1) and (h_count < h_sync2 )) then
			 h_sync_s <= '1';                  
		else
			 h_sync_s <= '0';
		end if;
	end if;
end process;
--v_sync
process(clk, h_count)
begin
  if (rising_edge(clk)) then
		if ((v_count > v_sync1 -1) and (v_count < v_sync2)) then
			 v_sync_s <= '1';
	else
			 v_sync_s <= '0';
		end if;
  end if;
end process;
h_sync <= h_sync_s;
v_sync <= v_sync_s;
end Behavioral;


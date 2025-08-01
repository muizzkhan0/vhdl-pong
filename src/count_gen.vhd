library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use constants.all;

entity count_gen is
	port(	
		clk  : in std_logic ;
		new_frame :out std_logic;
		h_count   : out natural range 0 to h_total-1;
      v_count   : out natural range 0 to v_total-1
	);
end count_gen;

architecture Behavioral of count_gen is
signal new_frame_s : std_logic;
signal h_count_s : natural range 0 to h_total-1;
signal v_count_s : natural range 0 to v_total-1;
begin
process(clk,h_count_s,v_count_s)
	begin          
		if (rising_edge(clk)) then
			new_frame_s <= '0';
			if (h_count_s >= h_total-1) then 
			  h_count_s <= 0 ;  
			  if (v_count_s >= v_total-1) then
				 v_count_s <= 0 ;
				 new_frame_s <= '1';
			  else				
				 v_count_s <= v_count_s+1 ;
			  end if ;
			else
				h_count_s <= h_count_s+1;
			end if;
		end if ;	
end process;
v_count <= v_count_s;
h_count <= h_count_s;
new_frame <= new_frame_s;
end Behavioral;


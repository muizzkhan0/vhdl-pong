library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use constants.all;

entity background is
	port (
		clk       : in  std_logic;
		h_count   : in natural range 0 to h_total-1;
      v_count   : in natural range 0 to v_total-1;
      background : out std_logic;		
      center     : out std_logic;
      edge  	  : out std_logic
   );
end background;

architecture Behavioral of background is
signal edge_s : std_logic;
signal center_s : std_logic;
signal background_s : std_logic;

begin
process(clk)
begin
	if rising_edge(clk) then
		if (h_count< edge_size-1) or ((h_count> h_active-edge_size) 
		and (h_count< h_active-1)) or  (v_count < edge_size-1) 
		or ((v_count > v_active-edge_size) and (v_count < v_active-1)) then
			edge_s <= '1';
			background_s <= '0';
			center_s <= '0';
		elsif ((h_count>= 319) and (h_count<= 321))
			and (((v_count>= edge_size ) and (v_count<= v_active-edge_size))) 		
		then
			center_s <= '1';
			background_s <= '0';
			edge_s <= '0';
		else 
			background_s <= '1';   
			edge_s <= '0';	  
			center_s <= '0';		
		end if;
	end if;		
end process; 
background <= background_s;   
edge <= edge_s;	  
center <= center_s;	
end Behavioral;


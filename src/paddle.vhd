library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use constants.all;

entity paddle is
	port (
		clk : in  std_logic;
		new_frame : in std_logic;
		h_count : in natural range 0 to h_total-1;
      v_count : in natural range 0 to v_total-1;
		left_up : in  std_logic;			
		left_down : in  std_logic;
		right_up : in  std_logic;			
		right_down : in  std_logic;
		left_pos : out natural range 0 to (v_active-v_paddle-1);
		right_pos : out natural range 0 to (v_active-v_paddle-1);
		left_paddle : out std_logic;				
		right_paddle : out std_logic
	);
end paddle;

architecture Behavioral of paddle is
signal left_up_s		: std_logic;
signal left_down_s	: std_logic;
signal right_up_s  	: std_logic;
signal right_down_s	: std_logic;
signal left_pos_s : natural range 0 to (v_active-v_paddle-1) :=150;
signal right_pos_s : natural range 0 to (v_active-v_paddle-1) := 150;
begin
process(clk)
begin
	if rising_edge(clk) then
		left_up_s <= left_up;
		left_down_s <= left_down;
		right_up_s <= right_up;
		right_down_s <= right_down;
	end if;
end process;
--left paddle
process(clk,new_frame)
begin
if rising_edge(clk) then
	if new_frame = '1' then
		if left_up_s = '1' then
				if left_pos_s > edge_size+20 then 
						left_pos_s <= left_pos_s - 2;
				elsif left_pos_s = edge_size+20 then
						left_pos_s <= left_pos_s;
				end if;
		elsif left_down_s = '1' then
				if left_pos_s < (v_active-v_paddle-edge_size-1-20) then
						left_pos_s <= left_pos_s + 2; 						    		
				elsif left_pos_s = (v_active-v_paddle-edge_size-20) then
						left_pos_s <= left_pos_s;
				end if;		
		end if;
	end if;
end if;
end process;

--right paddle
process(clk,new_frame)
begin
if rising_edge(clk) then
	if new_frame = '1' then
		if right_up_s = '1' then	
				if right_pos_s > edge_size+20 then
					 right_pos_s <= right_pos_s - 2;
				elsif right_pos_s = edge_size+20 then
						right_pos_s <= right_pos_s;
				end if;
		elsif right_down_s = '1' then	
				if right_pos_s < (v_active-v_paddle-edge_size-1-20) then
						right_pos_s <= right_pos_s + 2;
				elsif right_pos_s = (v_active-v_paddle-edge_size-20) then
						right_pos_s <= right_pos_s;
				end if;
		end if;
	end if;
end if;
end process;

process(clk)
begin
	if rising_edge(clk) then
		if (h_count>= edge_size+20) and (h_count<= (edge_size+h_paddle-1+20))
		and (v_count >= left_pos_s) and (v_count <= (left_pos_s+v_paddle-1))then
			left_paddle <= '1';		
		elsif (h_count>= (h_active-edge_size-h_paddle-20)) and (h_count<= (h_active-edge_size-1-20))
		and (v_count >= right_pos_s) and (v_count <= (right_pos_s+v_paddle-1)) then  
			right_paddle <= '1';
		else 
			left_paddle <= '0';
			right_paddle <= '0';
		end if;
	end if;
end process;
left_pos <= left_pos_s; 
right_pos <= right_pos_s;
end Behavioral;


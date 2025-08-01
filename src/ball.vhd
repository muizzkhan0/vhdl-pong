library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use constants.all;

entity ball is
	port(
		clk : in std_logic;
		new_frame: in std_logic;
		h_count : in natural range 0 to h_total-1;
      v_count : in natural range 0 to v_total-1;
		left_pos : in natural range 0 to (v_active-v_paddle-1);
		right_pos : in natural range 0 to (v_active-v_paddle-1);
		ball : out std_logic
	);
end ball;

architecture Behavioral of ball is
signal h_ball : natural range 0 to (h_active+ball_size) := 320;  
signal v_ball : natural range 0 to (v_active-ball_size-1) := 150;  		
signal h_ball_mov : std_logic := '1'; 
signal v_ball_mov : std_logic := '1';

begin
process (clk,left_pos,right_pos,new_frame)
begin 
	if rising_edge(clk) then	
	if new_frame = '1' then
		if h_ball_mov = '0' then 
			h_ball <= h_ball-2;	
			if (h_ball = edge_size+h_paddle+20) then
				if (v_ball >= left_pos-ball_size+20) and (v_ball <= left_pos+v_paddle-1-20) then
				  h_ball_mov <= '1';
				end if;
			elsif ((h_ball <= edge_size+20) and ((v_ball > 150) and (v_ball < 350))) then
				h_ball <= 350;
				v_ball <= 250;
				h_ball_mov <= '1';
				v_ball_mov <= '1';
			elsif (h_ball <= edge_size+20) then  
				h_ball_mov <= '1';
			end if;
		else
			h_ball <= h_ball+2;
			if (h_ball = h_active-edge_size-h_paddle-ball_size-20) then
				if (v_ball >= right_pos-ball_size) and (v_ball <= right_pos+v_paddle-1) then
					h_ball_mov <= '0';
				end if;	
			elsif ((h_ball >= h_active-edge_size-ball_size-20) and ((v_ball > 150) and (v_ball < 350)))then
				h_ball <= 350;
				v_ball <= 250;
				h_ball_mov <= '0';
				v_ball_mov <= '0';
			elsif(h_ball >= h_active-edge_size-ball_size-20)then
				h_ball_mov <= '0';
			end if;
		end if;
		
		if v_ball_mov = '0' then
			v_ball <= v_ball-2;
			if (v_ball <= edge_size+20) then
				v_ball_mov <= '1';
			elsif (v_ball = left_pos+v_paddle) or (v_ball = right_pos+v_paddle) then
				if ((h_ball >= edge_size-ball_size) and (h_ball <= edge_size+h_paddle))
				or ((h_ball >= h_active-edge_size-h_paddle-ball_size) 
				and (h_ball <= h_active-edge_size)) then
						v_ball_mov <= '1';
				end if;
			end if;
		else
			v_ball <= v_ball+2;
			if (v_ball >= (v_active-ball_size-edge_size-1-20)) then
				v_ball_mov <= '0';  
			elsif (v_ball = left_pos-ball_size) or (v_ball = right_pos-ball_size) then
				if ((h_ball >= edge_size-ball_size) and (h_ball <= edge_size+h_paddle))
				or ((h_ball >= h_active-edge_size-h_paddle-ball_size) 
				and (h_ball <= h_active-edge_size)) then
					v_ball_mov <= '0';
				end if;
			end if;
		end if;
	end if;
	end if;
end process;

process(clk)
begin
	if rising_edge(clk) then
		if (h_count>= h_ball) and (h_count<= h_ball+ball_size-1) 
      and (v_count >= v_ball) and (v_count <= v_ball+ball_size-1) then
			ball <= '1';
      else 
         ball <= '0';
      end if;
   end if;
end process;
end Behavioral;


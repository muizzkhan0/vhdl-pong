library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use constants.all;

entity VGA is
	Port ( 
		clk : in std_logic;
		h_count   : in natural range 0 to h_total-1;
      v_count   : in natural range 0 to v_total-1;
		ball : in std_logic;
		left_paddle : in std_logic;
      right_paddle : in std_logic;
      Rout   : out std_logic_vector(7 downto 0);
		Gout   : out std_logic_vector(7 downto 0);
		Bout   : out std_logic_vector(7 downto 0)
	);
end VGA;

architecture Behavioral of VGA is
signal Rout_s : std_logic_vector(7 downto 0);
signal Gout_s : std_logic_vector(7 downto 0);
signal Bout_s : std_logic_vector(7 downto 0);
begin
process(clk)
begin
if rising_edge(clk) then
	if ball = '1' then
		if (((v_count>150) and (v_count<350)) and ((h_count>20) and (h_count < 20+edge_size+ball_size))) --left goal
		or (((v_count>150) and (v_count<350)) and ((h_count>h_active-20-edge_size-ball_size) and (h_count < h_active-20))) --right goal
		then
			Rout_s <= "11111111";
			Gout_s <= "00000000";
			Bout_s <= "00000000";
		else
			Rout_s <= "11111111";
			Gout_s <= "11111111";
			Bout_s <= "00000000";
		end if;
	elsif left_paddle = '1' then
		Rout_s <= "00000000";
		Gout_s <= "00000000";
		Bout_s <= "11111111";
	elsif right_paddle = '1' then
		Rout_s <= "11111111";
		Gout_s <= "00000000";
		Bout_s <= "00000000";
	elsif (((v_count>150) and (v_count<350)) and ((h_count>20) and (h_count < 20+edge_size))) --left goal
	or (((v_count>150) and (v_count<350)) and ((h_count>h_active-20-edge_size) and (h_count < h_active-20))) --right goal
	then
		Rout_s <= "00000000";
		Gout_s <= "11111111";
		Bout_s <= "00000000";
	elsif (((h_count>20) and (h_count<20+edge_size)) and ((v_count>20) and (v_count < v_active-20))) -- top bar
	or (((h_count>h_active-20-edge_size) and (h_count<h_active-20)) and ((v_count>20) and (v_count < v_active-20))) --bottom bar
	or (((h_count>20) and (h_count<h_active-20)) and ((v_count>20) and (v_count < 20+edge_size))) --left bar
	or (((h_count>20) and (h_count<h_active-20)) and ((v_count>v_active-20-edge_size) and (v_count < v_active-20))) --right bar
	then
		Rout_s <= "11111111";
		Gout_s <= "11111111";
		Bout_s <= "11111111";
	elsif ((h_count>= 319) and (h_count<= 321))	
	and (
	   ((v_count> edge_size+50 ) and (v_count < edge_size+100))
	or ((v_count> edge_size+150 ) and (v_count< edge_size+200))
	or ((v_count> edge_size+250 ) and (v_count< edge_size+300))
	or ((v_count> edge_size+350 ) and (v_count< edge_size+400))
	) then -- center
		Rout_s <= "00000000";
		Gout_s <= "00000000";
		Bout_s <= "00000000";
	elsif (h_count < h_active -1) and (v_count < v_active-1) then
		Rout_s <= "00000000";
		Gout_s <= "11111111";
		Bout_s <= "00000000";
	else 
		Rout_s <= "00000000";
		Gout_s <= "00000000";
		Bout_s <= "00000000";
	end if;
end if;
end process;
Rout <= Rout_s;
Gout <= Gout_s;
Bout <= Bout_s;
end Behavioral;


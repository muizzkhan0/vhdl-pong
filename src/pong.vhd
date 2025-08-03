----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:00:48 11/11/2024 
-- Design Name: 
-- Module Name:    pong - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pong is
    Port ( clk_50 : in  STD_LOGIC;
			  sw1    : in STD_LOGIC := '0';
			  sw2    : in STD_LOGIC := '0';
			  sw3    : in STD_LOGIC := '0';
			  sw4    : in STD_LOGIC := '0';
           Rout : out  STD_LOGIC_VECTOR (7 downto 0);
           Gout : out  STD_LOGIC_VECTOR (7 downto 0);
           Bout : out  STD_LOGIC_VECTOR (7 downto 0);
           h_sync : out  STD_LOGIC;
           v_sync : out  STD_LOGIC;
			  clk_25 : out  STD_LOGIC);
end pong;

architecture Behavioral of pong is

--Signals

signal hcount : integer range 0 to 799 := 0;
signal vcount : integer range 0 to 524 := 0;

--constants used for drawing
signal hbar1_x1 : integer := 24; --top bar
signal hbar1_x2 : integer := 614;
signal hbar1_y1 : integer := 9;
signal hbar1_y2 : integer := 19;

signal hbar2_x1 : integer := 24; --bottom bar
signal hbar2_x2 : integer := 614;
signal hbar2_y1 : integer := 459;
signal hbar2_y2 : integer := 469;

signal vbar1_x1 : integer := 24; --top left bar
signal vbar1_x2 : integer := 34;
signal vbar1_y1 : integer := 19;
signal vbar1_y2 : integer := 189;

signal vbar2_x1 : integer := 24; --bottom left bar
signal vbar2_x2 : integer := 34;
signal vbar2_y1 : integer := 289;
signal vbar2_y2 : integer := 459;

signal vbar3_x1 : integer := 604; --top right bar
signal vbar3_x2 : integer := 614;
signal vbar3_y1 : integer := 19;
signal vbar3_y2 : integer := 189;

signal vbar4_x1 : integer := 604; --bottom right bar
signal vbar4_x2 : integer := 614;
signal vbar4_y1 : integer := 289;
signal vbar4_y2 : integer := 459;

signal bpaddle_x1 : integer := 44; --blue paddle
signal bpaddle_x2 : integer := 54;
signal bpaddle_y1 : integer range 0 to 479 := 199;
signal bpaddle_y2 : integer range 0 to 479 := 279;

signal ppaddle_x1 : integer := 584; --pink padde
signal ppaddle_x2 : integer := 594;
signal ppaddle_y1 : integer range 0 to 479 := 199;
signal ppaddle_y2 : integer range 0 to 479 := 279;

signal box1_x1 : integer := 0; --left side score box
signal box1_x2 : integer := 34;
signal box1_y1 : integer := 189;
signal box1_y2 : integer := 289;

signal box2_x1 : integer := 604; --right side score box
signal box2_x2 : integer := 639;
signal box2_y1 : integer := 189;
signal box2_y2 : integer := 289;

signal midline_x1 : integer := 318; --midline
signal midline_x2 : integer := 321;

signal m1_y1 : integer := 24; --midline segments
signal m1_y2 : integer := 69;
signal m2_y1 : integer := 79;
signal m2_y2 : integer := 124;
signal m3_y1 : integer := 134;
signal m3_y2 : integer := 179;
signal m4_y1 : integer := 189;
signal m4_y2 : integer := 234;
signal m5_y1 : integer := 244;
signal m5_y2 : integer := 289;
signal m6_y1 : integer := 299;
signal m6_y2 : integer := 344;
signal m7_y1 : integer := 354;
signal m7_y2 : integer := 399;
signal m8_y1 : integer := 409;
signal m8_y2 : integer := 454;

signal ball_x1 : integer range 0 to 639 := 314; --ball
signal ball_x2 : integer range 0 to 639 := 325; --the default values represent the middle of the field
signal ball_y1 : integer range 0 to 479 := 234;
signal ball_y2 : integer range 0 to 479 := 245;

--0 means positive direction, 1 means negative direction
signal ball_dirx : STD_LOGIC := '0';
signal ball_diry : STD_LOGIC := '0';

--used to signal when the ball was scored
signal score : STD_LOGIC := '0';

--used for keeping the ball red a short period of time
signal score_timer : integer range 0 to 60 := 0;

--signals when a new frame has been drawn
signal new_frame : STD_LOGIC := '0';

--the Pixel clock for the video DAC
signal clk25 : STD_LOGIC := '0';

begin
	process(clk_50)  --dividing the clock frequency
	begin
		if(rising_edge(clk_50)) then --invert clk_25 on rising edge of input clk_50
			clk25 <= not clk25;
			clk_25 <= clk25;
		end if;
	end process;
		
	process(clk25)
	begin
		--hcount and vcount logic
		if(rising_edge(clk25)) then --on the rising edge of clk
			new_frame <= '0';
			if(hcount >= 799) then
				hcount <= 0;
				if(vcount >= 524) then
					vcount <= 0;
					new_frame <= '1'; --a frame has just completed drawing
				else
					vcount <= vcount + 1;
				end if;
			else
				hcount <= hcount + 1;
			end if;
		end if;
	end process;
	
	--movement logic
	process(clk25)
	begin
		if(rising_edge(clk25)) then
			if(new_frame = '1') then --move once per new frame
				if(((ball_x2 <= box1_x2) and (ball_y1 >= box1_y1) and (ball_y2 <= box1_y2)) or
					((ball_x1 >= box2_x1) and (ball_y1 >= box2_y1) and (ball_y2 <= box2_y2))) then --reset to middle when score
					ball_x1 <= 314;
					ball_x2 <= 325;
					ball_y1 <= 234;
					ball_y2 <= 245;
					score <= '1';
				else
					if(score_timer >= 60) then --timer for keeping the ball red for 60 frames
						score <= '0';
						score_timer <= 0;
					else
						score_timer <= score_timer + 1;
					end if;
					if(ball_dirx = '0') then --ball x movement
						ball_x1 <= ball_x1 + 3;
						ball_x2 <= ball_x2 + 3;
					else
						ball_x1 <= ball_x1 - 3;
						ball_x2 <= ball_x2 - 3;
					end if;
					if(ball_diry = '0') then --ball y movement
						ball_y1 <= ball_y1 + 3;
						ball_y2 <= ball_y2 + 3;
					elsif(ball_diry = '1') then
						ball_y1 <= ball_y1 - 3;
						ball_y2 <= ball_y2 - 3;
					end if;
				end if;
				
				if(bpaddle_y1 >= hbar1_y2) then --blue paddle movement
					if(sw1 = '1') then	
						bpaddle_y1 <= bpaddle_y1 - 6;
						bpaddle_y2 <= bpaddle_y2 - 6;
					end if;
				end if;
				if(bpaddle_y2 <= hbar2_y1) then
					if(sw2 = '1') then
						bpaddle_y1 <= bpaddle_y1 + 6;
						bpaddle_y2 <= bpaddle_y2 + 6;
					end if;
				end if;
				
				if(ppaddle_y1 >= hbar1_y2) then --pink paddle movement
					if(sw3 = '1') then	
						ppaddle_y1 <= ppaddle_y1 - 6;
						ppaddle_y2 <= ppaddle_y2 - 6;
					end if;
				end if;
				if(ppaddle_y2 <= hbar2_y1) then
					if(sw4 = '1') then
						ppaddle_y1 <= ppaddle_y1 + 6;
						ppaddle_y2 <= ppaddle_y2 + 6;
					end if;
				end if;
			end if;
		end if;
	end process;

	--ball collision logic
	process(clk25)
	begin
		if(rising_edge(clk25)) then
			if(((ball_x1 <= vbar1_x2) and (ball_y1 <= vbar1_y2)) or --collision with vertical boundaries
				((ball_x1 <= vbar2_x2) and (ball_y2 >= vbar2_y1))) then
				ball_dirx <= '0';
			elsif (((ball_x2 >= vbar3_x1) and (ball_y1 <= vbar3_y2)) or 
				((ball_x2 >= vbar4_x1) and (ball_y2 >= vbar4_y1))) then
				ball_dirx <= '1';
			end if;
			if ((ball_x1 <= bpaddle_x2) and (ball_y1 >= bpaddle_y1) and (ball_y2 <= bpaddle_y2)) then --collision with paddles
				ball_dirx <= '0';
			elsif((ball_x2 >= ppaddle_x1) and (ball_y1 >= ppaddle_y1) and (ball_y2 <= ppaddle_y2)) then
				ball_dirx <= '1';
			end if;
			if((ball_y2 >= hbar2_y1)) then --collision with horizontal boundaries
				ball_diry <= '1';
			elsif(ball_y1 <= hbar1_y2) then
				ball_diry <= '0';
			end if;
		end if;	
	end process;
	
	
	process(clk25)
	begin
		if(rising_edge(clk25)) then
			--hsync and vsync logic
			if((hcount > 655) and (hcount < 752)) then
				h_sync <= '0';
			else
				h_sync <= '1';
			end if;
			if((vcount > 489) and (vcount < 492)) then
				v_sync <= '0';
			else
				v_sync <= '1';
			end if;
				
			--position comparators
			if((hcount <= 639) and (vcount <= 479)) then --default green background
				Rout <= "00000000";
				Gout <= "11111111";
				Bout <= "00000000";
				if((hcount >= hbar1_x1) and (hcount <= hbar1_x2) and (vcount >= hbar1_y1) and (vcount <= hbar1_y2)) then
					Rout <= "11111111";
					Gout <= "11111111";
					Bout <= "11111111";
				elsif((hcount >= hbar2_x1) and (hcount <= hbar2_x2) and (vcount >= hbar2_y1) and (vcount <= hbar2_y2)) then
					Rout <= "11111111";
					Gout <= "11111111";
					Bout <= "11111111";
				elsif((hcount >= vbar1_x1) and (hcount <= vbar1_x2) and (vcount >= vbar1_y1) and (vcount <= vbar1_y2)) then
					Rout <= "11111111";
					Gout <= "11111111";
					Bout <= "11111111";
				elsif((hcount >= vbar2_x1) and (hcount <= vbar2_x2) and (vcount >= vbar2_y1) and (vcount <= vbar2_y2)) then
					Rout <= "11111111";
					Gout <= "11111111";
					Bout <= "11111111";
				elsif((hcount >= vbar3_x1) and (hcount <= vbar3_x2) and (vcount >= vbar3_y1) and (vcount <= vbar3_y2)) then
					Rout <= "11111111";
					Gout <= "11111111";
					Bout <= "11111111";
				elsif((hcount >= vbar4_x1) and (hcount <= vbar4_x2) and (vcount >= vbar4_y1) and (vcount <= vbar4_y2)) then
					Rout <= "11111111";
					Gout <= "11111111";
					Bout <= "11111111";
				elsif((hcount >= bpaddle_x1) and (hcount <= bpaddle_x2) and (vcount >= bpaddle_y1) and (vcount <= bpaddle_y2)) then
					Rout <= "00000000";
					Gout <= "00000000";
					Bout <= "11111111";
				elsif((hcount >= ppaddle_x1) and (hcount <= ppaddle_x2) and (vcount >= ppaddle_y1) and (vcount <= ppaddle_y2)) then
					Rout <= "11111111";
					Gout <= "00000000";
					Bout <= "11111111";
				elsif((hcount >= ball_x1) and (hcount <= ball_x2) and (vcount >= ball_y1) and (vcount <= ball_y2)) then
					if(score = '1') then --change to red if ball was just scored
						Rout <= "11111111";
						Gout <= "00000000";
						Bout <= "00000000";
					else
						Rout <= "11111111"; --default ball is yellow
						Gout <= "11111111";
						Bout <= "00000000";
					end if;
				elsif((hcount >= midline_x1) and (hcount <= midline_x2)) then
					if(((vcount >= m1_y1) and (vcount <= m1_y2)) or
						((vcount >= m2_y1) and (vcount <= m2_y2)) or
						((vcount >= m3_y1) and (vcount <= m3_y2)) or
						((vcount >= m4_y1) and (vcount <= m4_y2)) or
						((vcount >= m5_y1) and (vcount <= m5_y2)) or
						((vcount >= m6_y1) and (vcount <= m6_y2)) or
						((vcount >= m7_y1) and (vcount <= m7_y2)) or
						((vcount >= m8_y1) and (vcount <= m8_y2))) then
						Rout <= "00000000";
						Gout <= "00000000";
						Bout <= "00000000";
					end if;
				end if;
			else
				Rout <= "00000000";
				Gout <= "00000000";
				Bout <= "00000000";
			end if;
		end if;
	end process;
end Behavioral;


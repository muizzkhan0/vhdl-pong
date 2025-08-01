library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;
use UNISIM.VComponents.all;
use constants.all;

entity top_level is
	Port ( 
		  clk_50	: in  std_logic;
		  left_up	: in  std_logic;
		  left_down 	: in  std_logic;
		  right_up 		: in  std_logic;
		  right_down 	: in  std_logic;
		  clk_25     : out std_logic;
		  h_sync        : out std_logic;
		  v_sync        : out std_logic;
		  Rout 		: out std_logic_vector(7 downto 0);
		  Bout 		: out std_logic_vector(7 downto 0);
		  Gout 		: out std_logic_vector(7 downto 0)
	);
end top_level;

architecture Behavioral of top_level is

COMPONENT clock_divider_2
	PORT (
		clk_50 	: in   std_logic; 	
		clk_25    : out  std_logic	
	);
END COMPONENT;

COMPONENT count_gen
	PORT (
		clk  : in std_logic ;
		new_frame : out std_logic;
		h_count   : out natural range 0 to h_total-1;
      v_count   : out natural range 0 to v_total-1
	);
END COMPONENT;

COMPONENT sync_gen
	PORT (
		clk       : in std_logic;
      h_count   : in natural range 0 to h_total-1;
      v_count   : in natural range 0 to v_total-1;
      h_sync    : out std_logic;
      v_sync    : out std_logic
	);
END COMPONENT;

COMPONENT paddle
	PORT (
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
END COMPONENT;

COMPONENT ball
	PORT (
		clk : in std_logic;
		new_frame: in std_logic;
		h_count : in natural range 0 to h_total-1;
      v_count : in natural range 0 to v_total-1;
		left_pos : in natural range 0 to (v_active-v_paddle-1);
		right_pos : in natural range 0 to (v_active-v_paddle-1);
		ball : out std_logic
	);
END COMPONENT;

COMPONENT VGA
	PORT (
		clk  : in std_logic ;
		h_count : in natural range 0 to h_total-1;
      v_count : in natural range 0 to v_total-1;
		ball : in std_logic;
		left_paddle : in std_logic;
      right_paddle : in std_logic;
      Rout   : out std_logic_vector(7 downto 0);
		Gout   : out std_logic_vector(7 downto 0);
		Bout   : out std_logic_vector(7 downto 0)
	);
END COMPONENT;

component icon
  PORT (
    CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0)
  );
end component;

component ila
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CLK : IN STD_LOGIC;
    DATA : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    TRIG0 : IN STD_LOGIC_VECTOR(0 TO 0)
  );
end component;

signal clk_25_s : std_logic;
signal h_count_s : natural range 0 to h_total-1;
signal v_count_s : natural range 0 to v_total-1;
signal left_paddle_s : std_logic;
signal right_paddle_s: std_logic;
signal ball_s : std_logic;
signal new_frame_s : std_logic;
signal left_pos_s : natural range 0 to (v_active-v_paddle-1);
signal right_pos_s : natural range 0 to (v_active-v_paddle-1);
signal Rout_s : std_logic_vector(7 downto 0);
signal Gout_s : std_logic_vector(7 downto 0);
signal Bout_s : std_logic_vector(7 downto 0);
signal h_sync_s : std_logic;
signal v_sync_s : std_logic;

signal control0 : STD_LOGIC_VECTOR(35 downto 0);
signal ila_data : std_logic_vector(31 downto 0);
signal trig0 	: std_logic_vector(0 TO 0);

begin
Inst_clock_divider_2: clock_divider_2 
PORT MAP(
	clk_50 => clk_50,
	clk_25 => clk_25_s
);

Inst_count_gen: count_gen 
PORT MAP(
	clk => clk_25_s,
	new_frame => new_frame_s,
	h_count => h_count_s,
   v_count => v_count_s
);

Inst_sync_gen: sync_gen
PORT MAP(
	clk => clk_25_s,
	h_count => h_count_s,
	v_count => v_count_s,
	h_sync => h_sync_s,
	v_sync => v_sync_s
);

Inst_paddle: paddle
PORT MAP(
	clk => clk_25_s,
	new_frame => new_frame_s,
	h_count => h_count_s,
	v_count => v_count_s,
	left_up => left_up,			
	left_down => left_down,
	right_up => right_up,		
	right_down => right_down,
	left_paddle => left_paddle_s,				
	right_paddle => right_paddle_s,
	left_pos => left_pos_s,
	right_pos => right_pos_s
);

Inst_ball: ball
PORT MAP(
	clk => clk_25_s,
	new_frame => new_frame_s,
	h_count => h_count_s,
	v_count => v_count_s,
	left_pos => left_pos_s,
	right_pos => right_pos_s,
	ball => ball_s
);

Inst_VGA: VGA
PORT MAP(
	clk  => clk_25_s,
	h_count => h_count_s,
	v_count => v_count_s,
	ball => ball_s,
	left_paddle => left_paddle_s,
	right_paddle => right_paddle_s,
	Rout => Rout_s,
	Gout => Gout_s,
	Bout => Bout_s
);

Inst_icon : icon
  port map (
    CONTROL0 => CONTROL0);

Inst_ila : ila
  port map (
    CONTROL => CONTROL0,
    CLK => clk_50,
    DATA => ila_data,
    TRIG0 => TRIG0);
	 
clk_25 <= clk_25_s;
Rout <= Rout_s;
Gout <= Gout_s;
Bout <= Bout_s;
h_sync <= h_sync_s;
v_sync <= v_sync_s;

--ila 
ila_data(0) <= clk_25_s;
ila_data(1) <= h_sync_s;
ila_data(2) <= v_sync_s;
ila_data(3) <= ball_s;
ila_data(14 downto 7) <= Rout_s;
ila_data(22 downto 15) <= Gout_s;
ila_data(30 downto 23) <= Bout_s;
ila_data(31) <= new_frame_s;

end Behavioral;


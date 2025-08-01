library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use constants.all;

entity edge is
	port (
		clk       : in  std_logic;
		h_count   : in std_logic_vector(9 downto 0);
      v_count   : in std_logic_vector(9 downto 0);
      background : out std_logic;		
      center     : out std_logic;
      edge  	  : out std_logic
   );
end edge;

architecture Behavioral of edge is

begin


end Behavioral;


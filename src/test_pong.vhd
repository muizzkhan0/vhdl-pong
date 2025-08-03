--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:37:21 11/20/2024
-- Design Name:   
-- Module Name:   /home/student1/a595khan/Documents/coe758/pong/test_pong.vhd
-- Project Name:  pong
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: pong
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_pong IS
END test_pong;
 
ARCHITECTURE behavior OF test_pong IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pong
    PORT(
         clk_50 : IN  std_logic;
         sw1 : IN  std_logic;
         sw2 : IN  std_logic;
         sw3 : IN  std_logic;
         sw4 : IN  std_logic;
         Rout : OUT  std_logic_vector(7 downto 0);
         Gout : OUT  std_logic_vector(7 downto 0);
         Bout : OUT  std_logic_vector(7 downto 0);
         h_sync : OUT  std_logic;
         v_sync : OUT  std_logic;
         clk_25 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_50 : std_logic := '0';
   signal sw1 : std_logic := '0';
   signal sw2 : std_logic := '0';
   signal sw3 : std_logic := '0';
   signal sw4 : std_logic := '0';

 	--Outputs
   signal Rout : std_logic_vector(7 downto 0);
   signal Gout : std_logic_vector(7 downto 0);
   signal Bout : std_logic_vector(7 downto 0);
   signal h_sync : std_logic;
   signal v_sync : std_logic;
   signal clk_25 : std_logic;

   -- Clock period definitions
   constant clk_50_period : time := 10 ns;
   constant clk_25_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pong PORT MAP (
          clk_50 => clk_50,
          sw1 => sw1,
          sw2 => sw2,
          sw3 => sw3,
          sw4 => sw4,
          Rout => Rout,
          Gout => Gout,
          Bout => Bout,
          h_sync => h_sync,
          v_sync => v_sync,
          clk_25 => clk_25
        );

   -- Clock process definitions
   clk_50_process :process
   begin
		clk_50 <= '0';
		wait for clk_50_period/2;
		clk_50 <= '1';
		wait for clk_50_period/2;
   end process;
 
   clk_25_process :process
   begin
		clk_25 <= '0';
		wait for clk_25_period/2;
		clk_25 <= '1';
		wait for clk_25_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_50_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;

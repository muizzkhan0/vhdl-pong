library IEEE;
use IEEE.STD_LOGIC_1164.all;

package constants is
--VGA parameters
constant h_total        : integer := 800;
constant h_frontPorch   : integer := 16;
constant h_syncPulse    : integer := 96;
constant h_backPorch    : integer := 48;
constant h_active       : integer := 640;

constant v_total        : integer := 525;
constant v_frontPorch   : integer := 10;
constant v_syncPulse    : integer := 2;
constant v_backPorch    : integer := 33;
constant v_active       : integer := 480;

constant h_sync1     : integer := h_active+h_frontPorch;
constant h_sync2     : integer := h_active+h_frontPorch+h_syncPulse;

constant v_sync1     : integer := v_active+v_frontPorch;
constant v_sync2     : integer := v_active+v_frontPorch+v_syncPulse;

--Objects
constant edge_size : integer := 10;
constant ball_size : integer := 10;

constant h_paddle : integer := 15;
constant v_paddle : integer := 100;

end constants;

package body constants is
 
end constants;

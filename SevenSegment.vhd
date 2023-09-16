library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------
-- 7-segment display driver. It displays a 4-bit number on a 7-segment
-- This is created as an entity so that it can be reused many times easily
-------------------------------------------------------------------------

entity SevenSegment is port (
   
   hex	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
); 
end SevenSegment;

architecture Behavioral of SevenSegment is

-------------------------------------------------------------------------
-- The following statements convert a 4-bit input, called dataIn to a pattern of 7 bits
-- The segment turns on when it is '1' otherwise '0'
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- The 4-bits represents either the 4-bits of hex_A and hex_B --
-- or the 4-bits of the sum and carry computed by the adder --
-- These bits must be converted to 7-bits so they can be displayed on the clock --
-- Each of the 7 bits represent 1 of 7 LEDS on the display --
-- When the corresponding bit is set to '1', the LED is turned on --
-- When the corresponding bit is set to '0', the LED is turned off --
-------------------------------------------------------------------------
begin
   with hex select				--GFEDCBA        3210      -- data in   
	sevenseg 				    <= "0000001" when "0011",    --red
										 "1000000" when "0010",    --orange
										 "0001000" when "0001",    --green
										 "0000000" when others;    
end architecture Behavioral; 
----------------------------------------------------------------------
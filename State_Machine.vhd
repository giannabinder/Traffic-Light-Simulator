library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity State_Machine IS Port
(
	g_clk, sm_clken, blink, reset, HLD_EW, HLD_NS                                                              : in std_logic;
	reg_clr_EW, reg_clr_NS, cross_EW, cross_NS                                                                 : out std_logic;
	EW_out, NS_out                                                                                             : out std_logic_vector(1 downto 0);
	state_number                                                                                               : out std_logic_vector(3 downto 0)
	
);
END ENTITY;
 

 Architecture SM of State_Machine is
 
 TYPE STATE_NAMES IS (g_b_0, g_b_1, g_s_2, g_s_3, g_s_4, g_s_5, o_6, o_7, r_8, r_9, r_10, r_11, r_12, r_13, r_14, r_15);   -- list all the STATE_NAMES values

 
 SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES


  BEGIN
  --------------------------------------------------------------------------------
 --State Machine:
 --------------------------------------------------------------------------------

 -- REGISTER_LOGIC PROCESS EXAMPLE
 
Register_Section: PROCESS (g_clk)  -- this process updates with a clock
BEGIN
	IF(rising_edge(g_clk)) THEN
		IF (reset = '1') THEN
			current_state <= g_b_0;
		ELSIF (reset = '0' AND sm_clken = '1') THEN
			current_state <= next_State;
		END IF;
	END IF;
END PROCESS;	



-- TRANSITION LOGIC PROCESS EXAMPLE

Transition_Section: PROCESS (HLD_NS, HLD_EW, current_state) 

BEGIN
  CASE current_state IS
  
			WHEN g_b_0 =>
				IF (HLD_NS = '0' AND HLD_EW = '1') THEN
					next_state <= o_6;
				ELSE
					next_state <= g_b_1;
				END IF;
				
				
			WHEN g_b_1 =>
				IF (HLD_NS = '0' AND HLD_EW = '1') THEN
					next_state <= o_6;
				ELSE
					next_state <= g_s_2;
				END IF;
    

			WHEN g_s_2 =>
				next_state <= g_s_3;
				
				
			WHEN g_S_3 =>
				next_state <= g_s_4;
				
			
			WHEN g_S_4 =>
				next_state <= g_s_5;
				
				
			WHEN g_S_5 =>
				next_state <= o_6;
				
				
			WHEN o_6 =>
				next_state <= o_7;
				
				
			WHEN o_7 =>
				next_state <= r_8;
				
				
			WHEN r_8 =>
				IF (HLD_NS = '1' AND HLD_EW = '0') THEN
					next_state <= r_14;
				ELSE
					next_state <= r_9;
				END IF;
				
				
			WHEN r_9 =>
				IF (HLD_NS = '1' AND HLD_EW = '0') THEN
					next_state <= r_14;
				ELSE
					next_state <= r_10;
				END IF;
				
			
			WHEN r_10 =>
				next_state <= r_11;
				
				
			WHEN r_11 =>
				next_state <= r_12;
				
			
			WHEN r_12 =>
				next_state <= r_13;
				
				
			WHEN r_13 =>
				next_state <= r_14;
				
				
			WHEN r_14 =>
				next_state <= r_15;
				
				
			WHEN r_15 =>
				next_state <= g_b_0;
				
				
	  END CASE;
 END PROCESS;
 

-- DECODER SECTION PROCESS EXAMPLE (MOORE FORM SHOWN)

Decoder_Section: PROCESS (current_state) 

BEGIN
     CASE current_state IS
	  
         -- "11" is red
			-- "01" is green
			-- "10" is orange
			-- "00" is none
			
			When g_b_0 =>
				EW_out       <= "11";
				reg_clr_EW   <= '0';
				reg_clr_NS   <= '0';
				cross_EW     <= '0';
				cross_NS     <= '0';
				state_number <="0000";
				
				IF (blink = '1') THEN 
					NS_out    <= "01";
				ELSE
					NS_out    <= "00";
				END IF;
				
				
				
			When g_b_1 =>
				EW_out       <= "11";
				reg_clr_EW   <= '0';
				reg_clr_NS   <= '0';
				cross_EW     <= '0';
				cross_NS     <= '0';
				state_number <="0001";
				
				IF (blink = '1') THEN 
					NS_out    <= "01";
				ELSE
					NS_out    <= "00";
				END IF;
				
				
			When g_s_2 =>
				EW_out       <= "11";
				NS_out       <= "01";
				reg_clr_EW   <= '0';
				reg_clr_NS   <= '0';
				cross_EW     <= '0';
				cross_NS     <= '1';
				state_number <="0010";
				
			
			When g_s_3 =>
				EW_out       <= "11";
				NS_out       <= "01";
				reg_clr_EW   <= '0';
				reg_clr_NS   <= '0';
				cross_EW     <= '0';
				cross_NS     <= '1';
				state_number <="0011";
								
			
			When g_s_4 =>
				EW_out       <= "11";
				NS_out       <= "01";
				reg_clr_EW   <= '0';
				reg_clr_NS   <= '0';
				cross_EW     <= '0';
				cross_NS     <= '1';
				state_number <="0100";
									
			
			When g_s_5 =>
				EW_out       <= "11";
				NS_out       <= "01";
				reg_clr_EW   <= '0';
				reg_clr_NS   <= '0';
				cross_EW     <= '0';
				cross_NS     <= '1';
				state_number <="0101";
												
			
			When o_6 =>
				EW_out       <= "11";
				NS_out       <= "10";
				reg_clr_EW   <= '0';
				reg_clr_NS   <= '1';
				cross_EW     <= '0';
				cross_NS     <= '0';
				state_number <="0110";
									
			
			When o_7 =>
				EW_out       <= "11";
				NS_out       <= "10";
				reg_clr_EW   <= '0';
				reg_clr_NS   <= '0';
				cross_EW     <= '0';
				cross_NS     <= '0';
				state_number <="0111";
				
				
			When r_8 =>
				NS_out       <= "11";
				reg_clr_EW   <= '0';
				reg_clr_NS   <= '0';
				cross_EW     <= '0';
				cross_NS     <= '0';
				state_number <="1000";
				
				IF (blink = '1') THEN 
					EW_out    <= "01";
				ELSE
					EW_out    <= "00";
				END IF;
				
				
				
			When r_9 =>
				NS_out       <= "11";
				reg_clr_EW   <= '0';
				reg_clr_NS   <= '0';
				cross_EW     <= '0';
				cross_NS     <= '0';
				state_number <="1001";
				
				IF (blink = '1') THEN 
					EW_out    <= "01";
				ELSE
					EW_out    <= "00";
				END IF;
				
							
			When r_10 =>
				EW_out       <= "01";
				NS_out       <= "11";
				reg_clr_EW   <= '0';
				reg_clr_NS   <= '0';
				cross_EW     <= '1';
				cross_NS     <= '0';
				state_number <="1010";
								
			
			When r_11 =>
				EW_out       <= "01";
				NS_out       <= "11";
				reg_clr_EW   <= '0';
				reg_clr_NS   <= '0';
				cross_EW     <= '1';
				cross_NS     <= '0';
				state_number <="1011";
									
			
			When r_12 =>
				EW_out       <= "01";
				NS_out       <= "11";
				reg_clr_EW   <= '0';
				reg_clr_NS   <= '0';
				cross_EW     <= '1';
				cross_NS     <= '0';
				state_number <="1100";
												
			
			When r_13 =>
				EW_out       <= "01";
				NS_out       <= "11";
				reg_clr_EW   <= '0';
				reg_clr_NS   <= '0';
				cross_EW     <= '1';
				cross_NS     <= '0';
				state_number <="1101";
									
			
			When r_14 =>
				EW_out       <= "10";
				NS_out       <= "11";
				reg_clr_EW   <= '1';
				reg_clr_NS   <= '0';
				cross_EW     <= '0';
				cross_NS     <= '0';
				state_number <="1110";
				
			
			When r_15 =>
				EW_out       <= "10";
				NS_out       <= "11";
				reg_clr_EW   <= '0';
				reg_clr_NS   <= '0';
				cross_EW     <= '0';
				cross_NS     <= '0';
				state_number <="1111";
	  END CASE;
 END PROCESS;

 END ARCHITECTURE SM;
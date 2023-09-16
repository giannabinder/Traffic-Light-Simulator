LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
		clkin_50		: in	std_logic;							-- The 50 MHz FPGA Clockinput
		rst_n			: in	std_logic;							-- The RESET input (ACTIVE LOW)
		pb_n			: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
		sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
		leds			: out std_logic_vector(7 downto 0);	-- for displaying the the lab4 project details
		-------------------------------------------------------------
		-- you can add temporary output ports here if you need to debug your design 
		-- or to add internal signals for your simulations
		-------------------------------------------------------------
		
		seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
		seg7_char1  : out	std_logic;							-- seg7 digi selectors
		seg7_char2  : out	std_logic							-- seg7 digi selectors
	);
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS

   component segment7_mux port (
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 		: in  std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
   );
   end component;

	
	
   component clock_generator port (
			sim_mode			: in boolean;
			reset				: in std_logic;
         clkin      		: in  std_logic;
			sm_clken			: out	std_logic;
			blink		  		: out std_logic
	);
   end component;
	
	

   component pb_inverters port (
			 pb_n					: in std_logic_vector(3 downto 0);
			 pb			  		: out std_logic_vector(3 downto 0)
	);
   end component;
	
	
	
	component SevenSegment is port (
   
			hex	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
			sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
	); 
	end component;
	
	
	
	component synchronizer is port (

			clk					: in std_logic;
			reset					: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
	  );
	 end component;

	

	component holding_register is port (

			clk					: in std_logic;
			reset					: in std_logic;
			register_clr		: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
	  );
	 end component;
	 
	 
	 component State_Machine is port (
			g_clk, sm_clken, blink, reset, HLD_EW, HLD_NS                                                              : in std_logic;
			reg_clr_EW, reg_clr_NS, cross_EW, cross_NS                                                                 : out std_logic;
			EW_out, NS_out                                                                                             : out std_logic_vector(1 downto 0);
			state_number                                                                                               : out std_logic_vector(3 downto 0)
	  );
	 end component;
			
	
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode						          : boolean := FALSE; -- set to FALSE for LogicalStep board downloads
	                                                     -- set to TRUE for SIMULATIONS
	
	SIGNAL sm_clken, blink   			          : std_logic; 
	
	SIGNAL pb								          : std_logic_vector(3 downto 0); -- pb(3) is used as an active-high reset for all registers
	
	SIGNAL reset                               : std_logic;
	
	SIGNAL SYNCH_EW, SYNCH_NS                  : std_logic;
	
	SIGNAL HLD_REG_EW, HLD_REG_NS              : std_logic;
	
	SIGNAL reg_clr_EW, reg_clr_NS              : std_logic;
	
	SIGNAL concatenation_EW, concatenation_NS  : std_logic_vector(3 downto 0);
	
	SIGNAL EW_AGD, NS_AGD                      : std_logic_vector(1 downto 0);
	
	SIGNAL EW_VII_display, NS_VII_display      : std_logic_vector(6 downto 0);
	
	
BEGIN

	reset              <= pb(3);
	concatenation_EW   <= "00" & EW_AGD; -- is the concatenation really necessary??????
	concatenation_NS   <= "00" & NS_AGD; -- is the concatenation really necessary??????
	
	leds(3) <= HLD_REG_EW;
	leds(1) <= HLD_REG_NS;

	----------------------------------------------------------------------------------------------------
	INST1: pb_inverters		port map (pb_n(3 downto 0), pb(3 downto 0));
	INST2: clock_generator 	port map (sim_mode, pb(3), clkin_50, sm_clken, blink);

	INST_SYNCH_EW: synchronizer port map (clkin_50, reset, pb(1), SYNCH_EW);
	INST_SYNCH_NS: synchronizer port map (clkin_50, reset, pb(0), SYNCH_NS);
	
	INST_HLD_REG_EW: holding_register port map (clkin_50, reset, reg_clr_EW, SYNCH_EW, HLD_REG_EW);
	INST_HLD_REG_NS: holding_register port map (clkin_50, reset, reg_clr_NS, SYNCH_NS, HLD_REG_NS);
	
	
	INST_STATE_MACHINE: state_machine port map (clkin_50, sm_clken, blink, reset, HLD_REG_EW, HLD_REG_NS, reg_clr_EW, reg_clr_NS, leds(2), leds(0), EW_AGD(1 downto 0), NS_AGD(1 downto 0), leds(7 downto 4));
			
	
	INST_VII_Seg_EW: SevenSegment port map(concatenation_EW(3 downto 0), EW_VII_display(6 downto 0));
	INST_VII_Seg_NS: SevenSegment port map(concatenation_NS(3 downto 0), NS_VII_display(6 downto 0));
	
	INST_SEG_VII_MUX: segment7_mux port map (clkin_50, NS_VII_display(6 downto 0), EW_VII_display(6 downto 0), seg7_data(6 downto 0), seg7_char1, seg7_char2); -- check order of seg7_char_NS and EW


END SimpleCircuit;

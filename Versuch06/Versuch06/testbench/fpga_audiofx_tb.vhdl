------------------------------------------------
-- 	Institute of Microelectronic Systems
-- 	Architectures and Systems
-- 	Leibniz Universitaet Hannover
------------------------------------------------
-- 	lab : 			Design Methods for FPGAs
--	file :			fpga_audiofx_tb.vhdl
--	authors :		Christian Leibold
--	last update :	22.09.2015
--	description :	Testbench for AudioFX
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fpga_audiofx_pkg.all;

entity fpga_audiofx_tb is

end entity fpga_audiofx_tb;

architecture rtl of fpga_audiofx_tb is

	component fpga_audiofx is
		port (
			clock_ext_50 	: in  	std_ulogic;
			reset_n_extern	: in 	std_ulogic;
			wm8731_clk     	: out   std_ulogic;
			i2s_sclk    	: in    std_ulogic;
			i2s_adc_ws		: in    std_ulogic;
			i2s_adc_sdat  	: in    std_ulogic;
			i2s_dac_ws 		: in    std_ulogic;
			i2s_dac_sdat  	: out   std_ulogic;
			i2c_sdat     	: inout std_logic;
			i2c_sclk     	: out   std_logic
		);
	end component fpga_audiofx;

	-- general signals
	signal clock			: std_ulogic := '0';
	signal reset_n			: std_ulogic;
	signal reset			: std_ulogic;
	
	-- audio-codec wm8731 signals
	component acodec_model is
		generic (
			SAMPLE_WIDTH 	: natural;
			SAMPLE_RATE 	: natural;
			SAMPLE_FILE 	: string
		);
		port (
			i2s_ref_sclk 	: in    std_ulogic;
			i2s_sclk		: out   std_ulogic;
			i2s_adc_ws		: out   std_ulogic;
			i2s_adc_sdat	: out   std_ulogic;
			i2s_dac_ws		: out   std_ulogic;
			i2s_dac_sdat	: in    std_ulogic;
			i2c_sdat		: inout std_logic;
			i2c_sclk		: in    std_logic
		);
	end component acodec_model;
	
	signal wm8731_clk		: std_ulogic;
	signal i2s_sclk			: std_ulogic;
	signal i2s_adc_ws		: std_ulogic;
	signal i2s_adc_sdat		: std_ulogic;
	signal i2s_dac_ws 		: std_ulogic;
	signal i2s_dac_sdat  	: std_ulogic;
	signal i2c_sdat 		: std_logic;
	signal i2c_sclk 		: std_logic;
	  
begin

	gen_reset : process
	begin
		reset_n <= '0';
		wait for 40 ns;
		reset_n <= '1';
		wait;
	end process gen_reset;
	
	gen_clock : process(clock)
	begin
		clock <= not clock after 10 ns;
	end process gen_clock;


	fpga_audiofx_inst : fpga_audiofx
		port map (
			clock_ext_50 	=> clock,
			reset_n_extern	=> reset_n,
			wm8731_clk     	=> wm8731_clk,
			i2s_sclk    	=> i2s_sclk,
			i2s_adc_ws		=> i2s_adc_ws,
			i2s_adc_sdat  	=> i2s_adc_sdat,
			i2s_dac_ws 		=> i2s_dac_ws,
			i2s_dac_sdat  	=> i2s_dac_sdat,
			i2c_sdat     	=> i2c_sdat,
			i2c_sclk     	=> i2c_sclk
		);

	i2c_sclk  <= 'H';
	i2c_sdat  <= 'H';
	reset	  <= not reset_n;
		
	acodec_model_inst : acodec_model
		generic map (
			SAMPLE_WIDTH 	=> SAMPLE_WIDTH,
			SAMPLE_RATE 	=> 44100,
			SAMPLE_FILE 	=> "../testbench/audio_samples.txt"
		)
		port map(
			i2s_ref_sclk 	=> wm8731_clk,
			i2s_sclk		=> i2s_sclk,
			i2s_adc_ws		=> i2s_adc_ws,
			i2s_adc_sdat	=> i2s_adc_sdat,
			i2s_dac_ws		=> i2s_dac_ws,
			i2s_dac_sdat	=> i2s_dac_sdat,
			i2c_sdat		=> i2c_sdat,
			i2c_sclk		=> i2c_sclk
		);
		
end architecture rtl;
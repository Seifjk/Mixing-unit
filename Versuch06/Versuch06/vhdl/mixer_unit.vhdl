-----------------------------------------------------------
-- 	Institute of Microelectronic Systems
-- 	Architectures and Systems
-- 	Leibniz Universitaet Hannover
-----------------------------------------------------------
-- 	lab : 			Design Methods for FPGAs
--	file :			mixer_unit.vhdl
--	authors :		
--	last update :	
--	description :	
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.fpga_audiofx_pkg.all;

entity mixer_unit is
	port (
		clock  		: in  std_ulogic;
		reset		: in  std_ulogic;
		-- serial audio-data inputs 
		ain_sync	: in  std_ulogic_vector(1 downto 0);
		ain_data	: in  std_ulogic_vector(1 downto 0);
		-- serial audio-data output
		aout_sync	: out std_ulogic;
		aout_data	: out std_ulogic
	);
end mixer_unit;
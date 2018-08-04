`timescale 1ns/1ps
module sdram_initialization_tst();
	reg sclk		;
	reg snrst		;
	wire		cke			;
	wire [ 3:0]	cmd	       	;							
	wire [12:0]	mod_config 	;							
	wire 		init_done	;
	
	sdram_initialization sdram_initialization_init (		.sclk		(sclk		),
															.snrst		(snrst		),
															.cke		(cke		),
															.cmd		(cmd		),
															.mod_config	(mod_config	),
															.init_done  (init_done  )
															);
	
	initial begin
		sclk = 1'b1 ;
		snrst = 1'b0 ;
		#60
		snrst = 1'b1 ;
		#30
		snrst = 1'b0 ;
		#60
		snrst = 1'b1 ;
	end 
	
	always #25 sclk = ~sclk ;
	
endmodule
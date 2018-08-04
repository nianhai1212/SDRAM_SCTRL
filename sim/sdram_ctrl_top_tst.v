`timescale 1ns/1ps 
module sdram_ctrl_top_tst ();
	reg sclk	;
    reg snrst   ;
    
    wire [15:0] Dq		; 
    wire [12:0] Addr	; 
    wire [ 1:0] Ba		; 
    wire 		Clk		;  
    wire 		Cke		;  
    wire 		Cs_n	;  
    wire 		Ras_n	;  
    wire 		Cas_n	;  
    wire 		We_n	;  
    wire [1:0] 	Dqm 	;
	
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

	sdram_ctrl_top sdram_ctrl_top_init (	.sclk	(sclk ),
											.snrst  (snrst),
											        
											.Dq		(Dq		), 
											.Addr	(Addr	), 
											.Ba		(Ba		), 
											.Clk	(Clk	), 
											.Cke	(Cke	), 
											.Cs_n	(Cs_n	), 
											.Ras_n	(Ras_n	), 
											.Cas_n	(Cas_n	), 
											.We_n	(We_n	), 
											.Dqm    (Dqm 	)
											);
											
	mt48lc16m16a2 mt48lc16m16a2_inst ( .Dq		(Dq		),
                                       .Addr	(Addr	),
                                       .Ba		(Ba		),
                                       .Clk		(Clk	),
									   .Cke		(Cke	),
                                       .Cs_n	(Cs_n	),
                                       .Ras_n	(Ras_n	),
                                       .Cas_n	(Cas_n	),
                                       .We_n	(We_n	),
                                       .Dqm     (Dqm 	)
									);

endmodule
`timescale 1 ns/ 1 ps
module uart_tx_vlg_tst();

	reg sysclk		;
	reg nrst		;
	
	reg [7:0] datain	;
	reg flag_tx		;
	
	wire rs232_tx	;
					
	wire tx_done	;
	
	uart_tx uart_tx_inst(	.sysclk		(sysclk		),
							.nrst		(nrst		),
							.datain		(datain		),
							.flag_tx	(flag_tx	),
							.rs232_tx	(rs232_tx	),
							.tx_done	(tx_done	)	
							);
	
	initial 
	begin
		sysclk = 1'b1 ;
		nrst   = 1'b0 ;
		datain = 8'b0 ;
		flag_tx = 1'b0 ;
		#50 nrst = 1'b1 ;
	end 
	
	always #10 sysclk=~sysclk;
	
	initial
	begin
		//repeat( 3 ) begin
			#100 flag_tx = 1'b1 ;
			#120 flag_tx = 1'b0 ;
			#1800000 flag_tx = 1'b1 ;
			#1800020 flag_tx = 1'b0 ;
		//end
	end
	
	initial
	begin
		//repeat( 3 ) begin
			#100  datain = 8'h5a ;
			#1800000 datain = 8'ha5 ;
		//end
	end
	
endmodule
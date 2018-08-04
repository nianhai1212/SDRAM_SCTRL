module uart_rx (	sysclk		,
					nrst		,
					
					rs232_rx	,
					
					rx_done		,
					rx_data		
					);
	input sysclk ;
	input nrst   ;
	input rs232_rx ;
	output reg rx_done ;
	output reg [7:0] rx_data ;
	//output [7:0] rx_data ;
	
	// clkdomin chg pre_processing 
	reg rs232_rx_d   ;
	reg rs232_rx_dd  ;
	reg rs232_rx_ddd ;
	always@( posedge sysclk )
	begin
		if( ~nrst ) begin
			rs232_rx_d   <= 1'b1 ;
		    rs232_rx_dd  <= 1'b1 ;
		    rs232_rx_ddd <= 1'b1 ;
		end
		else begin
			rs232_rx_d   <= rs232_rx    ;
		    rs232_rx_dd  <= rs232_rx_d  ;
		    rs232_rx_ddd <= rs232_rx_dd ;
		end 
	end
	
	wire rx_in ;
	assign rx_in = rs232_rx_ddd ;
	
	// rs232_rx negedge detect 
	reg rx_falling_edge ;
	always@( posedge sysclk )
	begin
		if( ~nrst ) begin
			rx_falling_edge <= 1'b0 ;
		end
		else if( ~rs232_rx_dd & rs232_rx_ddd )begin
			rx_falling_edge <= 1'b1 ;
		end 
		else begin
			rx_falling_edge <= 1'b0 ;
		end 
	end
	
	// bit_cnt and bit sample_flag gen
	localparam  IDLE	= 2'b01 ,
				CNT_GEN = 2'b10 ;
	reg [ 1:0] current_state ;
	reg [15:0] sample_cnt    ;
	reg [ 3:0] bit_cnt       ;
	reg  	   flag_rx_busy  ;
	always@( posedge sysclk )
	begin
		if( ~nrst ) begin
			current_state <= IDLE ;
			flag_rx_busy  <= 1'b0 ;
			sample_cnt    <= 16'b0 ;
			bit_cnt       <= 4'b0  ;
			rx_done       <= 1'b0  ;
		end
		else begin
			case( current_state )
				IDLE:begin
					rx_done       <= 1'b0  ;
					if( rx_falling_edge ) begin
						current_state <= CNT_GEN ;
						sample_cnt    <= 16'b0   ;
						bit_cnt       <= 4'b0    ;
						flag_rx_busy  <= 1'b1    ;
					end
					else begin
						current_state <= IDLE  ;
						sample_cnt    <= 16'b0 ;
						bit_cnt       <= 4'b0  ;
						flag_rx_busy  <= 1'b0  ;
					end 
				end 
				CNT_GEN:begin
					if ( bit_cnt == 4'd8 && sample_cnt == 16'd5208 ) begin
						current_state 	<= IDLE 	;
						bit_cnt 		<= 4'd0 	;
						sample_cnt 		<= 16'd0 	;
						flag_rx_busy    <= 1'b1     ;
						rx_done         <= 1'b1	    ;
					end 
					if( sample_cnt == 16'd5208 ) begin
						sample_cnt 	<= 16'b0 ;
						bit_cnt 	<= bit_cnt + 1'b1 	;
					end 
					else begin
						sample_cnt <= sample_cnt + 1'b1 ;
					end 
				end 
			endcase
		end 
	end
	
	// flag_sample 
	reg flag_samle ;
	always@( posedge sysclk )
	begin
		if( ~nrst ) begin
			flag_samle <= 1'b0 ;
		end
		else if ( sample_cnt == 2604 ) begin
			flag_samle <= 1'b1 ;
		end 
		else begin
			flag_samle <= 1'b0 ;
		end
	end
	
	// recieve serial data
	reg [8:0] cash_rxdata ;
	always@( posedge sysclk )
	begin
		if( ~nrst ) begin
			cash_rxdata <= 9'b0 ;
		end
		else if ( flag_samle ) begin
			cash_rxdata <= { rx_in,cash_rxdata[8:1] };
		end
		else begin
			cash_rxdata <= cash_rxdata ;
		end
	end
	
	// rx_data output
	//assign rx_data = cash_rxdata[8:1] ;
	always@( posedge sysclk )
	begin
		if( ~nrst ) 
			rx_data <= 8'b0 ;
		else if ( rx_done ) 
			rx_data <= cash_rxdata[8:1] ;
		else 
			rx_data <= rx_data ;
	end
endmodule 
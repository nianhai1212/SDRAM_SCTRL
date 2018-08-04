module uart_tx (	sysclk		,
					nrst		,
					
					datain		,
					flag_tx		,
					
					rs232_tx	,
					
					tx_done		
					);
	input sysclk	;
	input nrst		;

	input [7:0] datain	;
	input flag_tx		;

	output reg rs232_tx	;
					
	output reg tx_done	;

	localparam	IDLE    =  2'b01 ,
				CNT_GEN =  2'b10 ;
	reg [ 1:0] current_state ;
	reg [ 3:0] bit_cnt       ;
	reg [15:0] sample_cnt   ;
	reg 	   flag_tx_busy ;
	always@( posedge sysclk )
	begin
		if( ~nrst ) begin
			current_state <= IDLE ;
			bit_cnt       <= 4'b0 ;
			sample_cnt    <= 16'b0;
			flag_tx_busy  <= 1'b0 ;
			tx_done		  <= 1'b0 ;
		end 
		else begin
			case( current_state )
				IDLE:begin
					tx_done <= 1'b0 ;
					if( flag_tx )begin
						current_state <= CNT_GEN ;
						bit_cnt       <= 4'b0    ;
						sample_cnt    <= 16'b0   ;
						flag_tx_busy  <= 1'b0    ;
					end
					else begin
						current_state <= IDLE    ;
						bit_cnt       <= 4'b0    ;
						sample_cnt    <= 16'b0   ;
						flag_tx_busy  <= 1'b0    ;
					end 
				end
				CNT_GEN:begin
					if ( bit_cnt == 4'd9 && sample_cnt == 16'd5208 ) begin
						current_state 	<= IDLE 	;
						bit_cnt 		<= 4'd0 	;
						sample_cnt 		<= 16'd0 	;
						flag_tx_busy    <= 1'b0     ;
						tx_done         <= 1'b1     ;
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

	// flag_tx gen
	reg flag_rs232_tx ;
	always@( posedge sysclk )
	begin
		if( ~nrst )
			flag_rs232_tx <= 1'b0 ;
		else if( sample_cnt == 16'd1 )
			flag_rs232_tx <= 1'b1 ;
		else 
			flag_rs232_tx <= 1'b0 ;
	end 
	
	// rs232tx_data 
	always@ ( posedge sysclk )
	begin
		if( ~nrst ) begin
			rs232_tx <= 1'b1 ;
		end 
		else if( flag_rs232_tx ) begin
			case( bit_cnt )
				4'd0: rs232_tx <= 1'b0 ;
				4'd1: rs232_tx <= datain[0];
				4'd2: rs232_tx <= datain[1];
				4'd3: rs232_tx <= datain[2];
				4'd4: rs232_tx <= datain[3];
				4'd5: rs232_tx <= datain[4];
				4'd6: rs232_tx <= datain[5];
				4'd7: rs232_tx <= datain[6];
				4'd8: rs232_tx <= datain[7];
				4'd9: rs232_tx <= 1'b1 ;
				default:rs232_tx <= 1'b1 ;
			endcase
		end 
	end
	
endmodule
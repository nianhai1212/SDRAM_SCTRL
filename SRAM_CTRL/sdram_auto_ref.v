module sdram_auto_ref ( sclk  ,
                        snrst ,
						
						initial_done ,
						
						aref_en ,
						aref_req ,
						ref_done ,
						
						aref_cmd	  ,
						sdram_addr    
						);
	input sclk  ;
	input snrst ;	

	input initial_done ;
						
	input aref_en  ;					
	output aref_req ;					
	output ref_done ;					
						
	output reg [ 3:0] aref_cmd	  ;					
	output [12:0] sdram_addr   ;					
	
	localparam  DELAY15US	=	'd600 ;
	localparam  CMD_AFRE    =   4'b0001 ;
	localparam  CMD_NOP     =   4'b0111 ;
	localparam  CMD_PRECHAR =   4'b0010 ;
	
	reg [ 3:0] cmd_cnt ;
	reg [ 9:0] ref_cnt ;
	always@( posedge sclk or negedge snrst )
	begin
		if( ~snrst ) 
			ref_cnt <= 10'b0 ;
		else if( ref_cnt >= DELAY15US )
			ref_cnt <= 10'b0 ;
		else if( initial_done )
			ref_cnt <= ref_cnt + 1'b1 ;
	end
	
	assign aref_req = ( ref_cnt >= DELAY15US )?1'b1:1'b0 ;
	
	// flag_aref gen
	reg flag_aref ;
	always@( posedge sclk or negedge snrst )
	begin
		if( ~snrst )
			flag_aref <= 1'b0 ;
 		else if( ref_done )
			flag_aref <= 1'b0 ; 
		else if( aref_en )
			flag_aref <= 1'b1 ;
	end
	
	//cmd_cnt 
	always@( posedge sclk or negedge snrst )
	begin
		if( ~snrst )
			cmd_cnt <= 4'b0 ;
		else if( flag_aref )
			cmd_cnt <= cmd_cnt + 1'b1 ;
		else 
			cmd_cnt <= 4'b0 ;
	end
	
	//cmd_output
	always@( posedge sclk or negedge snrst )
	begin
		if( ~snrst )
			aref_cmd <= CMD_NOP ;
		else begin
			case( cmd_cnt )
				1: aref_cmd <= CMD_AFRE ;
				2: aref_cmd <= CMD_PRECHAR    ;
				default:aref_cmd <= CMD_NOP ;
			endcase 
		end 
	end 
	
	// precharge all
	assign sdram_addr = 13'b0_0100_0000_0000 ;
	assign ref_done   = ( cmd_cnt >= 4'd3 )?1'b1:1'b0 ;
endmodule
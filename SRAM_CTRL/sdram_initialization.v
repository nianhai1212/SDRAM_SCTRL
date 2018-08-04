module sdram_initialization (	sclk		,
								snrst		,
								cke			,
								cmd			,
								mod_config	,
								init_done
								);
	input sclk		;
	input snrst		;
	output	reg			cke			;
	output	reg [ 3:0]	cmd	       	;							
	output	reg [12:0]	mod_config 	;							
/* 	output	reg 		init_done	; */
	output	     		init_done	;						
	
	localparam	CMD_NOP			=	4'b0111,							
	            CMD_ACTIVE		=	4'b0011,  					
	            CMD_READ		=	4'b0101,						
	            CMD_WRITE		=	4'b0100,						
	            CMD_BT			=	4'b0110,				//BURST_TERMINITE				
	            CMD_PRCH		=	4'b0010,				//PRICHARGE					
	            CMD_AR_or_SR	=	4'b0001,				//AUTO REFRESH or SELF REFRESH
	            CMD_LMR			=	4'b0000;				//LOAD_MODE_REGISTER
	localparam	MODE_REG	=	13'b0_0000_0010_0010 ;  //CL = 2 ;BL = 4 Sequentially
	localparam	PRECHAR_ALL =   13'b0_0100_0000_0000 ;  //precharge all banks 
	
	localparam	CNT200US	=	'd7999	;//8000 cks actually 
	
	localparam	IDLE					=   6'b000001,
				NOP_AFTER_DELAY			=	6'b000010,
				PRECHAR					=   6'b000100,
				AUTO_REF				=   6'b001000,
				LMR						=	6'b010000,
				ST_init_done_reg			=	6'b100000;
	reg	[ 5:0]	current_state	;
	
	// sdram initialization 
	reg	[15:0]	cnt_cmd	;
	reg init_done_reg ;
	assign init_done = init_done_reg ;
	always@( posedge sclk or negedge snrst )
	begin
		if( ~snrst ) begin
			current_state		<= IDLE    ;
			cmd			<= CMD_NOP ;
			mod_config	<=	13'b0  ;
			init_done_reg   <=  1'b0   ;
			cnt_cmd     <=  16'b0  ;
		end
		else begin
			case( current_state )
				IDLE:begin
					cmd			<=	CMD_NOP	;
					mod_config	<=	13'b0 	;
					init_done_reg   <=  1'b0    ;
					if( cnt_cmd == CNT200US ) begin
						current_state	<=	NOP_AFTER_DELAY;
						cnt_cmd	<=	16'b0 ;
					end
					else begin
						current_state	<=	IDLE	;
						cnt_cmd			<=	cnt_cmd + 1'b1	;
					end 
				end
				NOP_AFTER_DELAY:begin
					cmd			<=	CMD_NOP	;
					mod_config  <=  13'b0   ;
					if( cnt_cmd == 13'd1 ) begin
						current_state	<= PRECHAR ;
						cnt_cmd			<=  cnt_cmd + 1'b1 ;
					end
					else if( cnt_cmd == 13'd2 )begin
						current_state	<=	AUTO_REF ;
						cnt_cmd			<=  cnt_cmd + 1'b1 ;
					end
					else if( cnt_cmd == 13'd5 )begin
						current_state	<=	AUTO_REF ;
						cnt_cmd			<=  cnt_cmd + 1'b1 ;
					end
					else if( cnt_cmd == 13'd9 )begin
						current_state	<=	LMR 	;
						cnt_cmd			<=  cnt_cmd + 1'b1 ;
					end 
					else if( init_done_reg ) begin
						current_state	<=	NOP_AFTER_DELAY	;
						cnt_cmd			<=	16'd0			;
					end
					else begin
						current_state	<=	NOP_AFTER_DELAY	;
						cnt_cmd			<=	cnt_cmd + 1'b1 ;
					end 
				end 
				PRECHAR:begin
					current_state	<=	NOP_AFTER_DELAY	;
					cmd				<=	CMD_PRCH		;
					mod_config		<=	PRECHAR_ALL		;	
				end
				AUTO_REF:begin
					current_state	<=	NOP_AFTER_DELAY	;
					cmd				<=	CMD_AR_or_SR	;
					mod_config		<=	13'b0			;
				end 
				LMR:begin
					current_state	<=	ST_init_done_reg	;
					cmd				<=	CMD_LMR 	;
					mod_config		<=	MODE_REG	;
				end 
				ST_init_done_reg:begin
					current_state	<=	NOP_AFTER_DELAY	;
					init_done_reg		<=	1'b1		;
					cmd				<=	CMD_NOP 	;
					mod_config		<=	13'b0		;
				end 
				default:begin
					current_state		<= IDLE    ;
					cmd					<= CMD_NOP ;
					mod_config			<=	13'b0  ;
					init_done_reg   		<=  1'b0   ;
				end 
			endcase 
		end 
	end 
	
	//cke output 
	always@( posedge sclk or negedge snrst )
	begin
		if( ~snrst )
			cke	<= 1'b0 ;
		else if( current_state == IDLE && cnt_cmd == 16'd6000 )
			cke <= 1'b1 ;
		else 
			cke <= cke  ;
	end
	
	//init_done gen
/* 	reg init_done_reg_d ;
	always@( posedge sclk or negedge snrst )
	begin
		if( ~snrst )
			init_done_reg_d <= 1'b0 ;
		else 
			init_done_reg_d <= init_done_reg ;
			
		if( init_done_reg && ~init_done_reg_d )
			init_done <= 1'b1 ;
		else 
			init_done <= 1'b0 ;			
	end  */
	
endmodule 
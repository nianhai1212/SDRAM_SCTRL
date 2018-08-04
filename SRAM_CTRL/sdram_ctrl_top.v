module sdram_ctrl_top (	sclk	,
						snrst   ,
						
						Dq		, 
						Addr	, 
						Ba		, 
						Clk	, 
						Cke	, 
						Cs_n	, 
						Ras_n	, 
						Cas_n	, 
						We_n	, 
						Dqm
						);
	input		  sclk  ;
	input		  snrst ;
	output [15:0] Dq	; 
	output [12:0] Addr	; 
	output [ 1:0] Ba	; 
	output Clk		; 
	output Cke		; 
	output Cs_n		; 
	output Ras_n	; 
	output Cas_n	; 
	output We_n		; 
	output [1:0] Dqm ;
	
	assign Clk  = ~sclk ;
//	assign Cs_n = ( ~snrst )?1'b1:1'b0 ;
	
	wire [3:0] cmd_init ;	
	wire [12:0] addr_init ;
	wire init_done_w ;
	sdram_initialization sdram_initialization_init(	.sclk		(sclk ),
													.snrst		(snrst),
													.cke		(Cke  ),
													.cmd		(cmd_init  ),
													.mod_config	(addr_init ),
													.init_done  (init_done_w)
													);
	wire refresh_req ;
	reg  en_refresh  ;
	wire refresh_done ;	
	wire [3:0] cmd_aref ;
	wire [12:0] addr_aref ;	
	sdram_auto_ref sdram_auto_ref_int ( .sclk  (sclk ),
                        .snrst (snrst),
						
						.initial_done (init_done_w),
						
						.aref_en (en_refresh),
						.aref_req ( refresh_req ),
						.ref_done ( refresh_done),
						
						.aref_cmd	  ( cmd_aref  ),
						.sdram_addr   ( addr_aref ) 
						);
	
	localparam	IDLE	=	5'b0_0001	,
				ARBIT	=	5'b0_0010	,
				AFRE	=	5'b0_0100	;
	reg	[4:0]	current_state	;
	
	always@( posedge sclk or negedge snrst )
	begin
		if( ~snrst )begin
			current_state <= IDLE ;
		end
		else begin
			case( current_state )
				IDLE :begin
					if( init_done_w ) begin
						current_state <= ARBIT ;
					end
					else begin
						current_state <= IDLE ;
					end 
				end 
				ARBIT :begin
					if( en_refresh ) begin
						current_state <= AFRE ;
					end
					else begin
						current_state <= ARBIT ;
					end 
				end 
				AFRE :begin
					if( refresh_done )
						current_state <= ARBIT ;
					else 
						current_state <= AFRE  ;
				end 
			endcase
		end 
	end 
	
	// en_refresh gen
	always@( posedge sclk or negedge snrst )
	begin
		if( ~snrst ) 
			en_refresh <= 1'b0 ;
		else if( current_state == ARBIT && refresh_req )
			en_refresh <= 1'b1 ;
		else 
			en_refresh <= 1'b0 ;
	end 
	
	assign { Cs_n, Ras_n, Cas_n, We_n }= ( current_state == IDLE )?cmd_init:cmd_aref ;	
	assign Addr = (  current_state == IDLE  )? addr_init:addr_aref ;
	
endmodule 
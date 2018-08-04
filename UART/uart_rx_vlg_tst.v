`timescale 1 ns/ 1 ps
module uart_rx_vlg_tst();
// constants                                           
// general purpose registers
//reg eachvec;
// test vector input registers
reg nrst;
reg rs232_rx;
reg sysclk;
// wires                                               
wire rx_done;
wire [7:0] rx_data;

// assign statements (if any)                          
uart_rx i1 (
// port map - connection between master ports and signals/registers   
	.nrst(nrst),
	.rs232_rx(rs232_rx),
	.sysclk(sysclk),
	.rx_done(rx_done),
	.rx_data(rx_data)
);
initial                                                
begin                                                  
   sysclk=0;
	nrst=0;
	rs232_rx=1;
	#23 nrst=1;
end 
                                                   
always #10 sysclk=~sysclk;

initial
begin
	repeat(1)
begin
	#208000 rs232_rx=0;// start bit
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=1;// stop bit
	#208000 rs232_rx=0;// start bit
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;// stop bit
	#208000 rs232_rx=0;// start bit
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=1;// stop bit
	#208000 rs232_rx=0;// start bit
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;// stop bit
	#208000 rs232_rx=0;// start bit
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=1;// stop bit
	#208000 rs232_rx=0;// start bit
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;// stop bit
	#208000 rs232_rx=0;// start bit
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=1;// stop bit
	#208000 rs232_rx=0;// start bit
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;// stop bit
	#208000 rs232_rx=0;// start bit
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=1;// stop bit
	#208000 rs232_rx=0;// start bit
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;// stop bit
	#208000 rs232_rx=0;// start bit
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=1;// stop bit
	#208000 rs232_rx=0;// start bit
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;// stop bit
	#208000 rs232_rx=0;// start bit
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=1;// stop bit
	#208000 rs232_rx=0;// start bit
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;// stop bit
	#208000 rs232_rx=0;// start bit
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=1;// stop bit
	#208000 rs232_rx=0;// start bit
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;
	#104000 rs232_rx=0;
	#104000 rs232_rx=1;// stop bit
	end
end                                                   
endmodule
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "interface.sv"
`include "uvm_test.sv"

`define DEF_FIFO_WIDTH 8
`define DEF_FIFO_DEPTH 2**6

module fifo_top;
   
 bit clk,rstN;
  always #5 clk = ~clk;

	initial begin
      //rstN = 1; #50 rstN = 0;
      rstN = 0; 
      repeat(5)
      @(posedge intf.clk);
	rstN=1; 
	#145; rstN=0;
	#10; rstN=1; 
	#350 rstN=0;
    end
  
	// instantiate interface 
	fifo_intf 	intf (.clk(clk),.rstN(rstN));
	
	
	// Connect DUT and interface signals
	fifo #(.FIFO_WIDTH(`DEF_FIFO_WIDTH),.FIFO_DEPTH(`DEF_FIFO_DEPTH))
	 DUT   (.clk(intf.clk),
			.rstN(intf.rstN),
			.wr_en(intf.wr_en),
			.rd_en(intf.rd_en),
			.data_in(intf.data_in),
			.data_out(intf.data_out),
    		.empty(intf.empty),
            .full(intf.full),
            .wrptr(intf.wrptr),
            .rdptr(intf.rdptr)
            );
  
  initial begin
    uvm_config_db#(virtual fifo_intf)::set(uvm_root::get(),"*","vif",intf);
  end
  
  initial begin 
    run_test("fifo_test");
  end
  
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
  
endmodule

`timescale 1ns/1ns
interface fifo_intf (input logic clk,rstN);	
  
  parameter FIFO_WIDTH = 8;
  
  logic wr_en;				
  logic [FIFO_WIDTH-1:0]  data_in;				
	logic rd_en;				
	logic empty;				
	logic full;				
  logic [FIFO_WIDTH-1:0]  data_out;
  logic [5:0] wrptr,rdptr;
	
  clocking fifo_mon_cb @(posedge clk);
	default input #0ns output #0ns;			
	input wr_en;				
	input data_in;				
	input rd_en;				
	input empty;				
	input full;				
	input data_out;	
    input  wrptr;
    input rdptr;
	endclocking
	
	modport fifo_mon_mp(clocking fifo_mon_cb,input clk,input rstN);	
	
      clocking fifo_drv_cb @(posedge clk);
		default input #0ns output #0ns;
      input data_out;
		input full;
		input empty;
		output rd_en; 
		output data_in;
		output wr_en;
        input wrptr;
        input rdptr;
	endclocking

	modport fifo_drv_mp(clocking fifo_drv_cb,input clk,input rstN);
endinterface

class fifo_seq_item extends uvm_sequence_item;
  
  parameter FIFO_WIDTH = 8;
  
  rand bit       wr_en;
  rand bit       rd_en;
  rand bit [FIFO_WIDTH-1:0] data_in;
       
  bit [FIFO_WIDTH-1:0] data_out;
  bit empty,full;
  bit [5:0] wrptr,rdptr;
  static int count;
  
  `uvm_object_utils_begin(fifo_seq_item)
    `uvm_field_int(wr_en,UVM_ALL_ON)
    `uvm_field_int(rd_en,UVM_ALL_ON)
  	`uvm_field_int(data_in,UVM_ALL_ON)
  `uvm_object_utils_end
  

  function new(string name = "fifo_seq_item");
    super.new(name);
  endfunction

  constraint wr_rd_c { wr_en != rd_en; };
  //constraint wr_c { wr_en == ~wr_en;}
  //constraint rd_c { rd_en == ~rd_en;}
  constraint wr_c { if(count < 64) 
	  		 wr_en == 1;
			else
			       rd_en == 1;	
				 };


			function void post_randomize();
				count++;
			endfunction 		
endclass

`define DRIV_IF vif.fifo_drv_mp.fifo_drv_cb
`define CLK vif.fifo_drv_mp.clk

class fifo_driver extends uvm_driver #(fifo_seq_item);
 
   virtual fifo_intf vif;
 
  `uvm_component_utils(fifo_driver)

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
 
 function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction: build_phase
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(!uvm_config_db#(virtual fifo_intf)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"}); 
  endfunction: connect_phase
 
  virtual task run_phase(uvm_phase phase);
    //forever begin
      //seq_item_port.get_next_item(req);
    reset(); 
    drive(); 
      //seq_item_port.item_done();
    //end
    endtask : run_phase
  
   virtual task reset;
  @(posedge `CLK);
        begin
    $display("DRV: resetting");
         wait(!vif.rstN); 
    `DRIV_IF.data_in <= 0;
    `DRIV_IF.wr_en <= 0;
          `DRIV_IF.rd_en <= 0;
	 wait (vif.rstN);
    $display("DRV: done resetting");
        end
  endtask 
  
  virtual task drive();
    forever begin
      seq_item_port.get_next_item(req);
    `DRIV_IF.wr_en <= 0;
    `DRIV_IF.rd_en <= 0;
    @(posedge `CLK); 
    
    if(req.wr_en) begin // write operation
       @(posedge `CLK);
      `DRIV_IF.wr_en <= req.wr_en;
      `DRIV_IF.data_in <= req.data_in;
      @(posedge `CLK);
      req.wrptr = `DRIV_IF.wrptr;
      req.full = `DRIV_IF.full;
      req.empty = `DRIV_IF.empty;
    end
    else if(req.rd_en) begin //read operation
       @(posedge `CLK);
      `DRIV_IF.rd_en <= req.rd_en;
      @(posedge `CLK);
      req.rdptr = `DRIV_IF.rdptr;
      req.data_out = `DRIV_IF.data_out;
      req.empty = `DRIV_IF.empty;
      req.full = `DRIV_IF.full;
    end
      seq_item_port.item_done();
    end
    
  endtask : drive
endclass : fifo_driver

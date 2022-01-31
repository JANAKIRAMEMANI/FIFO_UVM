class fifo_monitor extends uvm_monitor;
 
  virtual fifo_intf vif;
 
  uvm_analysis_port #(fifo_seq_item) item_collected_port;
 
  // Placeholder to capture transaction information.
  fifo_seq_item trans_collected;
 
  `uvm_component_utils(fifo_monitor)
 
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
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
    forever begin
      @(posedge vif.fifo_mon_mp.clk);
      wait(vif.fifo_mon_cb.wr_en || vif.fifo_mon_cb.rd_en);
      
        @(posedge vif.fifo_mon_mp.clk);
        trans_collected.wr_en = vif.fifo_mon_cb.wr_en;
        trans_collected.data_in = vif.fifo_mon_cb.data_in;
        trans_collected.wrptr = vif.fifo_mon_cb.wrptr;
        
        trans_collected.rd_en = vif.fifo_mon_cb.rd_en;
        trans_collected.rdptr = vif.fifo_mon_cb.rdptr;
       
      trans_collected.data_out = vif.fifo_mon_cb.data_out;
      trans_collected.empty = vif.fifo_mon_cb.empty;
      trans_collected.full = vif.fifo_mon_cb.full;
     
	  item_collected_port.write(trans_collected);
      end 
  endtask : run_phase

 
endclass : fifo_monitor

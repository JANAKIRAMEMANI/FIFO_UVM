class fifo_scoreboard extends uvm_scoreboard;
 
 fifo_seq_item pkt_qu[$];

  bit [7:0] sc_mem [0:130];
 
 uvm_analysis_imp#(fifo_seq_item, fifo_scoreboard) item_collected_export;
  `uvm_component_utils(fifo_scoreboard)
  
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      item_collected_export = new("item_collected_export", this);
    //foreach(sc_mem[i]) sc_mem[i] = 8'h00;
  endfunction: build_phase
  
  virtual function void write(fifo_seq_item pkt);
    //pkt.print();
    pkt_qu.push_back(pkt);
  endfunction : write

  virtual task run_phase(uvm_phase phase);
    fifo_seq_item fifo_pkt;
    
    forever begin
      wait(pkt_qu.size() > 0);
      fifo_pkt = pkt_qu.pop_front();
      
      if(fifo_pkt.wr_en) begin
        sc_mem[fifo_pkt.wrptr] = fifo_pkt.data_in;
        `uvm_info(get_type_name(),$sformatf("----::WRITE DATA::----"),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("wrptr: %0h",fifo_pkt.wrptr),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("Data: %0h",fifo_pkt.data_in),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("full: %0h",fifo_pkt.full),UVM_LOW)
        `uvm_info(get_type_name(),$sformatf("empty: %0h",fifo_pkt.empty),UVM_LOW)
        `uvm_info(get_type_name(),"----------------------------",UVM_LOW)        
      end
      else if(fifo_pkt.rd_en) begin
        if(sc_mem[fifo_pkt.rdptr] == fifo_pkt.data_out) begin
          `uvm_info(get_type_name(),$sformatf("---::READ DATA Match::---"),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("rdptr: %0h",fifo_pkt.rdptr),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("sc_mem: %p",sc_mem),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",sc_mem[fifo_pkt.rdptr],fifo_pkt.data_out),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("full: %0h",fifo_pkt.full),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("empty: %0h",fifo_pkt.empty),UVM_LOW)
          `uvm_info(get_type_name(),"-------------------------",UVM_LOW)
        end
        else begin
          `uvm_error(get_type_name(),"---- :: READ DATA MisMatch :: ----")
          `uvm_info(get_type_name(),$sformatf("rdptr: %0h",fifo_pkt.rdptr),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",sc_mem[fifo_pkt.rdptr],fifo_pkt.data_out),UVM_LOW)
          `uvm_info(get_type_name(),"--------------------------",UVM_LOW)
        end
      end
    end
  endtask : run_phase
endclass : fifo_scoreboard

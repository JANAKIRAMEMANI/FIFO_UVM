`include "uvm_agent.sv"
`include "uvm_scoreboard.sv"
`include "uvm_coverage.sv"

class fifo_env extends uvm_env;
 
  fifo_agent      fifo_agnt;
  fifo_scoreboard fifo_scb;
  fifo_coverage fifo_cov;
  
  `uvm_component_utils(fifo_env)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    fifo_agnt = fifo_agent::type_id::create("fifo_agnt", this);
    fifo_scb  = fifo_scoreboard::type_id::create("fifo_scb", this);
    fifo_cov  = fifo_coverage::type_id::create("fifo_cov", this);
  endfunction : build_phase
  
  function void connect_phase(uvm_phase phase);
    fifo_agnt.monitor.item_collected_port.connect(fifo_scb.item_collected_export);
    fifo_agnt.monitor.item_collected_port.connect(fifo_cov.item_collected_export);
    
  endfunction : connect_phase
  
 
endclass : fifo_env

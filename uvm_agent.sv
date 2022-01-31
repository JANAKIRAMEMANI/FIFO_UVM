`include "uvm_sequence_item.sv"
`include "uvm_sequencer.sv"
`include "uvm_sequence.sv"
`include "uvm_driver.sv"
`include "uvm_monitor.sv"


class fifo_agent extends uvm_agent;
   fifo_driver    driver;
  fifo_sequencer sequencer;
  fifo_monitor   monitor;
 
  // UVM automation macros for general components
  `uvm_component_utils(fifo_agent)
 
  // constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
 
  // build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    monitor = fifo_monitor::type_id::create("monitor", this);
    
    if(get_is_active() == UVM_ACTIVE) begin
    driver    = fifo_driver::type_id::create("driver", this);
    sequencer = fifo_sequencer::type_id::create("sequencer", this);
    end
    
  endfunction : build_phase
 
 function void connect_phase(uvm_phase phase); 
      driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction : connect_phase

endclass : fifo_agent

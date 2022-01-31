`include "uvm_env.sv"

class fifo_test extends uvm_test;
 
  `uvm_component_utils(fifo_test)
 
  fifo_env env;
  fifo_sequence seq;
  
  function new(string name = "fifo_test",uvm_component parent);
    super.new(name,parent);
  endfunction : new
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	env = fifo_env::type_id::create("env", this);
  endfunction : build_phase
  
  virtual function void end_of_elaboration();
	print();
  endfunction
  
  function void report_phase(uvm_phase phase);
   uvm_report_server svr;
   super.report_phase(phase);
   
   svr = uvm_report_server::get_server();
   
   if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) 
   `uvm_info(get_type_name(), "----   TEST FAIL   ----", UVM_NONE)
   else 
   `uvm_info(get_type_name(), "----   TEST PASS   ----", UVM_NONE) 
  endfunction 
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this,"run-raise objection");
    seq = fifo_sequence::type_id::create("seq",this);
    seq.start(env.fifo_agnt.sequencer);
    #50;
    phase.drop_objection(this,"run-drop objection");
  endtask
 
endclass : fifo_test

class fifo_sequence extends uvm_sequence#(fifo_seq_item);
    
  `uvm_object_utils(fifo_sequence)
  
  function new(string name = "fifo_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(130)
      begin
    req = fifo_seq_item::type_id::create("req");
     wait_for_grant();
    req.randomize();
    send_request(req);
    wait_for_item_done();
   end 
  endtask
endclass

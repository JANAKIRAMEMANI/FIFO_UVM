class fifo_coverage extends uvm_subscriber #(fifo_seq_item);
   
  `uvm_component_utils(fifo_coverage)
  
  uvm_analysis_imp#(fifo_seq_item, fifo_coverage) item_collected_export;
  
    fifo_seq_item pkt;
   time t1,t2;
  int i=0,t;
   time t3,t4;
  int j=0,r;
    
   virtual fifo_intf 	vif;
   
  covergroup cg_1;
     //din:coverpoint pkt.data_in ;
    //dout: coverpoint pkt.data_out ;
	 rp:coverpoint pkt.rdptr;
     empty:coverpoint pkt.empty ;
     full:coverpoint pkt.full;                       
     wp:coverpoint pkt.wrptr;
     wr_en:coverpoint pkt.wr_en;
    rd_en:coverpoint pkt.rd_en;
     
    endgroup
	
  covergroup cg_2;
    coverpoint t {bins one_clk_wr_operation[]={10};}
    coverpoint r {bins one_clk_rd_operation[]={10};}
    //coverpoint p {bins one_clk_wr_rd_operation[]={0};}
  endgroup
        
    function new(string name, uvm_component parent);
        super.new(name, parent);
		item_collected_export = new("item_collected_export", this);
		cg_1 = new();
        cg_2 = new();
    endfunction: new
	
   function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_full_name(),"build phase-driver",UVM_LOW) 
        if(!uvm_config_db#(virtual fifo_intf)::get(this, "", "vif", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    endfunction

  function void write(fifo_seq_item t);
        pkt = t;
		cg_1.sample();
    endfunction: write
  
    task run_phase(uvm_phase phase);
       pkt = fifo_seq_item::type_id::create("pkt");
    forever begin
    $display("coverage working wr_en %d",pkt.wr_en);
    @(posedge vif.clk);
    if( pkt.wr_en==1)
            begin
              i++;
              $display("coverage working i=%d",i);
              if(i==1) begin
				t1=$time; 
                $display("coverage working t1=%t",t1);
                end
              else if(i==2) begin
			  t2=$time;
                $display("coverage working t2=%t",t2);
                  
              t=t2-t1;
                $display("coverage working t=%t",t);
                end
            end
    else
      $display("coverage not working");
        
    if( pkt.rd_en==1)
            begin
              j++;
              $display("coverage working j=%d",j);
              if(j==1)
                begin
                 t3=$time;
                  $display("coverage working t3=%t",t3);
                end
              else if(j==2)
                begin
                t4=$time;
                  $display("coverage working t4=%t",t4);
				
				r=t4-t3;
                  $display("coverage working r=%t",r);
                end
            end
    else
      $display("coverage not working");
        
        
	`uvm_info("coverage", "/////Data calculation in coverage/////////", UVM_NONE);
      //$display("my coverage is at t=%t, t1=%t, %t",t,t1,t2);
    cg_2.sample( );
     
    end
   endtask
  
  

    virtual function void extract_phase(uvm_phase phase);
      `uvm_info(get_type_name(), $sformatf("Coverage : %f", $get_coverage()), UVM_LOW)`uvm_info(get_type_name(), $sformatf("Coverage1 %f",cg_1.get_coverage()),UVM_LOW)
      
         
      `uvm_info(get_type_name(), $sformatf("Coverage2 %f",cg_2.get_coverage()),UVM_LOW)
      `uvm_info(get_type_name(), $sformatf("Coverage2_wr_operation %f",cg_2.t.get_coverage()),UVM_LOW)
      `uvm_info(get_type_name(), $sformatf("Coverage2_rd_operation %f",cg_2.r.get_coverage()),UVM_LOW)
      //`uvm_info(get_type_name(), $sformatf("Coverage2_wr_rd_operation %f",cg_2.p.get_coverage()),UVM_LOW)
    endfunction: extract_phase

endclass

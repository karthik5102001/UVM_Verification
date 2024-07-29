class Driver extends uvm_driver#(Transaction);
  
     `uvm_component_utils(Driver)
  
  virtual mul_if mul_iff;
  Transaction Trans;
 
  function new(string name = "Driver", uvm_component parent);
    super.new(name,parent);
  endfunction	
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(! uvm_config_db #(virtual mul_if) :: get(this,"","MULTI",mul_iff))
      `uvm_error("Driver","UNABLE TO ACCESS");
    
  endfunction
  
  task run_phase(uvm_phase phase);
    	forever begin
          seq_item_port.get_next_item(Trans);
          mul_iff.a <= Trans.a;
          mul_iff.b <= Trans.b;
          `uvm_info("DRV", $sformatf("a : %0d  b : %0d  y : %0d", Trans.a, Trans.b, Trans.y), UVM_NONE);
          seq_item_port.item_done();
          #20;
          
        end
  endtask
  
  
endclass
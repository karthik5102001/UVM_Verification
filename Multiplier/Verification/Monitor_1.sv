class Monitor extends uvm_monitor;
  
  `uvm_component_utils(Monitor)
  
  uvm_analysis_port #(Transaction) analysis_port;
  virtual mul_if mul_iff;
  Transaction Trans;
 
  function new(string name = "Monitor",uvm_component parent);
    super.new(name,parent);
    analysis_port = new("analysis_port",this);
    endfunction
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    Trans = Transaction ::type_id :: create("Trans");
    if(!uvm_config_db #(virtual mul_if) :: get(this,"","MULTI",mul_iff))
    		`uvm_error("drv","Unable to access Interface");
  endfunction
  
   task run_phase(uvm_phase phase);
     forever begin
    #20;
    Trans.a = mul_iff.a;
    Trans.b = mul_iff.b;
    Trans.y = mul_iff.y;
       `uvm_info("MON", $sformatf("a : %0d  b : %0d  y : %0d", Trans.a, Trans.b, Trans.y), UVM_NONE);
       analysis_port.write(Trans);
    end
  endtask
  
endclass
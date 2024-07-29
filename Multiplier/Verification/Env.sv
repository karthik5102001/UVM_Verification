class envo extends uvm_env;
  
  `uvm_component_utils(envo)
  
  Agent_1 age_1;
  score sb;
  
  function new(string name = "envo",uvm_component parent);
    super.new(name,parent);
  endfunction	
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    age_1 = Agent_1 :: type_id :: create("age_1",this);
    sb = score :: type_id :: create("score",this);
  endfunction
  
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    age_1.moni.analysis_port.connect(this.sb.analysis_imp);
    endfunction
  
endclass
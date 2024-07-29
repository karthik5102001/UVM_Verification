class Agent_1 extends uvm_agent;
  
  `uvm_component_utils(Agent_1)

  function new(string name = "Agent_1",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  Driver driv;
  uvm_sequencer#(Transaction) seqr;
  Monitor moni;	
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driv = Driver :: type_id :: create("Driver",this);
    seqr =  uvm_sequencer#(Transaction) :: type_id :: create("Seqr",this);
    moni = Monitor :: type_id :: create("moni",this);   
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driv.seq_item_port.connect(seqr.seq_item_export);
  endfunction   
  
endclass
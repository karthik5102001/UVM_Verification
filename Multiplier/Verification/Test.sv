class Test extends uvm_test;
  
  `uvm_component_utils(Test)
  
  sequence_1 seq_1;
  envo env;
  
  function new (string name = "Test", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seq_1 = sequence_1 :: type_id :: create("Seq_1");
    env = envo :: type_id :: create("envio",this);
    endfunction
  
   task run_phase(uvm_phase phase);
     while(env.sb.cg.get_coverage() < 100) begin
    phase.raise_objection(this);
     seq_1.start(env.age_1.seqr); 
    #20;
    phase.drop_objection(this);
     end
    
  endtask
  
  
  
endclass
`include "uvm_macros.svh"
import uvm_pkg :: *;


//////////////////////////////////////---DUT---//////////////////////////////


module adder(a,b,out);
  input [3:0] a;
  input [3:0] b;
  output [4:0] out;
  
  assign out = a + b;
  
endmodule


////////////////////////////////////---INTERFACE----///////////////////////////

interface add_if;
  logic [3:0] a;
  logic [3:0] b;
  logic [3:0] out;
endinterface

///////////////////////////////////---GENERATOR----/////////////////////////////

class transactions extends uvm_sequence_item;
  
  rand bit [3:0] a;
  rand bit [3:0] b;
  bit [3:0] out;
  
  virtual add_if adif;
  
  `uvm_object_utils_begin(transactions)
  `uvm_field_int(a,UVM_DEFAULT)
  `uvm_field_int(b,UVM_DEFAULT)
  `uvm_field_int(out,UVM_DEFAULT)
  `uvm_object_utils_end
  
  function new( string name = "transactions");
    super.new(name); 
  endfunction
  
endclass  
//////////////////////////////////---SEQUENCE---///////////////////////////////////

class generator extends uvm_sequence #(transactions);
  `uvm_object_utils(generator)
  
  transactions t;
  
  function new( string name = "generator");
    super.new(name); 
     t = transactions :: type_id :: create("transactions");
  endfunction
 
  
  task body();
    
    start_item(t);
    assert(t.randomize()) else $display("FAILED");
    finish_item(t);
    
  endtask

endclass

  
///////////////////////////////////---DRIVER---/////////////////////////////////////


class driver extends uvm_driver #(transactions);
  
  transactions t_1;
  virtual add_if adif;
  
  `uvm_component_utils(driver)
  
  function new (string name = "driver" , uvm_component parent);
    super.new(name,parent);
    endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t_1 = transactions :: type_id :: create("transactions_1");
    if (! uvm_config_db #(virtual add_if) :: get(this,"","addif",adif))
      `uvm_error("ERROR_VIF","ERROR IN FETCHING VIRTUAL INTERFACE");
  endfunction
  
  
  task run_phase(uvm_phase phase);
    forever begin
    //phase.raise_objection(this);
      seq_item_port.get_next_item(t_1);
      driver_logic();	
    seq_item_port.item_done();
    //phase.drop_objection(this);
    end
  endtask
      ////////////////////////----
      task driver_logic();
    		adif.a <= t_1.a;
            adif.b <= t_1.b;
        `uvm_info("DRIVER",$sformatf("THE VALUE A = %d, B = %0d , OUT = %0d ",t_1.a,t_1.b,t_1.out),UVM_NONE);
        #10;
      endtask      
  
endclass

      
/////////////////////////////////////////---MONITOR---////////////////////////////////////////////////
      
      
class monitor extends uvm_monitor;
        
   `uvm_component_utils(monitor)
        
    transactions t_2;
  
  virtual add_if adif;
  
  uvm_analysis_port #(transactions) moni_put;
  
   function new (string name = "monitor" , uvm_component parent);
    	super.new(name,parent);
    endfunction
        
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t_2 = transactions :: type_id :: create("transactions_2");
    moni_put = new("moni_put",this);
    if (! uvm_config_db #(virtual add_if) :: get(this,"","addif",adif))
      `uvm_error("ERROR_VIF","ERROR IN FETCHING VIRTUAL INTERFACE");
  endfunction
  
    task run_phase(uvm_phase phase);
    forever begin
    monitor_logic();
    end
    endtask
      ////////////////////////----
      task monitor_logic();
        #10;
    		t_2.a = adif.a;
            t_2.b = adif.b;
        	t_2.out = adif.out;
        `uvm_info("MONITOR",$sformatf("THE VALUE A = %d, B = %0d , OUT = %0d ",adif.a,adif.b,adif.out),UVM_NONE);
        moni_put.write(t_2);
      endtask 
  
  
endclass
      
///////////////////////////////////////////---SCOREBOARD---///////////////////////////////////////////
      
      
   class scoreboard extends uvm_scoreboard;
        	
     `uvm_component_utils(scoreboard)
        
     uvm_analysis_imp #(transactions,scoreboard) put;
        
     transactions t_3;
        
    function new (string name = "scoreboard" , uvm_component parent);
    	super.new(name,parent);
    endfunction
            
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t_3 = transactions :: type_id :: create("transactions_3");
    put = new("PUT",this);
  endfunction  
     
     function void write(input transactions t);
       		t_3 = t;
       `uvm_info("SCO",$sformatf("Data rcvd from Monitor a: %0d , b : %0d and out : %0d",t_3.a,t_3.b,t_3.out), UVM_NONE);
       if(t_3.out == t_3.a + t_3.b)
         `uvm_info("DONE","[VERIFIED]",UVM_NONE)
       else 
         `uvm_info("DONE","[NOT-VERIFIED]",UVM_NONE);
     endfunction
     
      endclass
  
////////////////////////////////////////////---AGENT---/////////////////////////////////      

      class agent extends uvm_agent;
        
        driver drv;
        monitor moni;
        
        uvm_sequencer #(transactions) seqR;
        
        
        `uvm_component_utils(agent)
    
        function new (string name = "agent" , uvm_component parent);
    	 super.new(name,parent);  
        endfunction
        
        function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          drv = driver :: type_id :: create("driver",this);
          moni = monitor :: type_id :: create("moni",this);
          seqR = uvm_sequencer #(transactions) :: type_id :: create("seqR",this);
         endfunction
        
        function void connect_phase(uvm_phase phase);
          super.connect_phase(phase);
          drv.seq_item_port.connect(seqR.seq_item_export);
        endfunction
        
        
      endclass
      
///////////////////////////////////////////////---ENVIRONMENT---///////////////////////////////////////////
      
      
      class env extends uvm_env;
        
        agent ag_1;
        scoreboard scrb;

        `uvm_component_utils(env)
        
        function new (string name = "env" , uvm_component parent);
    	 super.new(name,parent);  
        endfunction
        
        function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          ag_1 = agent :: type_id :: create("agent",this);
          scrb = scoreboard :: type_id :: create("scoreboard",this);
        endfunction
        
        function void connect_phase(uvm_phase phase);
          super.connect_phase(phase);
          ag_1.moni.moni_put.connect(scrb.put);
        endfunction
        
      endclass

////////////////////////////////////////////////----TEST----/////////////////////////////////////////////
      
      class test extends uvm_test;
        
        `uvm_component_utils(test)
        
        env e_1;
        generator gen;
        
        function new (string name = "test" , uvm_component parent);
    	 super.new(name,parent);  
        endfunction
        
        function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          e_1 = env :: type_id :: create("env",this);
          gen = generator :: type_id :: create("generator",this);
         endfunction
        
        task run_phase(uvm_phase phase);
          repeat(10) begin
          phase.raise_objection(this);
          gen.start(e_1.ag_1.seqR);
          phase.drop_objection(this);
          end
        endtask
        
        
      endclass

////////////////////////////////////////////---TOP---/////////////////////////////////////////////
      
      
      module top;
        
        add_if adif();
        
        adder DUT(.a(adif.a), .b(adif.b) ,.out(adif.out));
        
        initial begin
          uvm_config_db #(virtual add_if) :: set(null,"*","addif",adif);  
          run_test("test");
        end
        
      endmodule


/////////////////////////////////////////////////////////////////////////////////////////////////////








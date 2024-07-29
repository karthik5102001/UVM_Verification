class score extends uvm_scoreboard;
  
  `uvm_component_utils(score)
  
  Transaction Trans_2;
  uvm_analysis_imp#(Transaction,score) analysis_imp;
  int no_of_data;
  int no_of_correct;
  int no_of_wrong;
  
  covergroup cg;
    option.per_instance=1;
    option.name = "MULTIPLAYER";
    option.auto_bin_max = 8;
    option.at_least = 1;
    
    coverpoint Trans_2.a ;
    coverpoint Trans_2.b ;
    coverpoint Trans_2.y ;
    
  endgroup
  
  function new(string name = "SCORE",uvm_component parent);
    super.new(name,parent);
     cg = new();
  endfunction
    
   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_imp = new("Analysis_imp",this);
  endfunction
  
  function void write(Transaction Trans_1);
          if(Trans_1.y == Trans_1.a * Trans_1.b) begin
            no_of_data ++ ;
            no_of_correct ++;
            Trans_2 = Transaction :: type_id :: create("Trans_2");
            Trans_2 = Trans_1;
            cg.sample();
            $display("******************************************************************");
            `uvm_info("[SCRB]",$sformatf("NUMBER OF DATA %0d AND CORRECT DATA %0d",no_of_data,no_of_correct),UVM_LOW);
            $display("******************************************************************");
          end
          else begin
            no_of_data++;
            no_of_wrong++;
            Trans_2 = Transaction :: type_id :: create("Trans_2");
            Trans_2 = Trans_1;
            cg.sample();
            $display("******************************************************************");
            `uvm_info("[SCRB]",$sformatf("NUMBER OF DATA %0d AND WRONG DATA %0d",no_of_data,no_of_wrong),UVM_LOW);
           $display("******************************************************************");
          end
          
        
  endfunction
  
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
    `uvm_info("[FINAL]",$sformatf("Result Pass %0d",no_of_correct),UVM_LOW);
    $display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
    $display("------------------------------------------------------------------------") ;
    $display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
    `uvm_info("[FINAL]",$sformatf("Result Failed %0d",no_of_wrong),UVM_LOW);
    $display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
    $display("------------------------------------------------------------------------") ;
    $display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
    `uvm_info("[FINAL]",$sformatf("Total Data sent %0d",no_of_data),UVM_LOW);
    $display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");

  endfunction 
  
  
endclass
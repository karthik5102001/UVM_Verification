class Transaction extends uvm_sequence_item;
 
  `uvm_object_utils(Transaction)
  
  rand bit [3:0] a;
  rand bit [3:0] b;
  bit [7:0] y;
  
  function new (input string name = "KarthikS");
    super.new(name);
  endfunction
  
  
endclass  
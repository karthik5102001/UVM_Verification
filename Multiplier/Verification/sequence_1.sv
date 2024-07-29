class sequence_1 extends uvm_sequence#(Transaction);
  
  `uvm_object_utils(sequence_1)
  
  Transaction trans;
  
  function new(string name = "Sequence_1");
    super.new(name);
    endfunction
  
  task body();
    //repeat(20) begin
      trans = Transaction :: type_id :: create("Transaction");
      start_item(trans);
      assert(trans.randomize())
        `uvm_info("SEQ", $sformatf("a : %0d  b : %0d  y : %0d", trans.a, trans.b, trans.y), UVM_NONE);
      finish_item(trans);
      
  //  end
  endtask
  
endclass
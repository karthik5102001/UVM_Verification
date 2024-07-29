
interface mul_if;
  logic [3:0] a;
  logic [3:0] b;
  logic [7:0] y;
  
endinterface

`include "packet.sv"

module test;
  
  import pack::*;
  import uvm_pkg::*;
  
  mul_if iif();
  
  mul DUT(.a(iif.a),.b(iif.b),.y(iif.y));
  
  initial begin
    uvm_config_db #(virtual mul_if):: set(null,"*","MULTI",iif);
    run_test("Test");
  end
  
  initial begin
    $dumpfile("dump.vdc");
    $dumpvars;
  end

endmodule  
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2024 19:45:12
// Design Name: KARTHIK S
// Module Name: 8x3_Priority_encoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: It a basic 8x3 Priority Encoder 
// 
//////////////////////////////////////////////////////////////////////////////////


module eightxthree_Priority_encoder(
in,out
    );
    input [7:0] in;
    output reg [2:0] out;
    
    always @(in) begin
                casez(in)
			8'b1???_???? : out = 3'b111;
			8'b01??_???? : out = 3'b110;
			8'b001?_???? : out = 3'b101;
			8'b0001_???? : out = 3'b100;
			8'b0000_1??? : out = 3'b011;
			8'b0000_01?? : out = 3'b010;
			8'b0000_001? : out = 3'b001;
			8'b0000_0001 : out = 3'b000;
                    default : out = 3'bxxx;
                endcase
                end    
    
endmodule

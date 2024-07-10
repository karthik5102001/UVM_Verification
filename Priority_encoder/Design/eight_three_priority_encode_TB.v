`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2024 20:03:33
// Design Name: 
// Module Name: eight_three_priority_encoder_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module eight_three_priority_encoder_tb;

reg [7:0] in;
wire [2:0] out;

eightxthree_Priority_encoder DUT (.in(in),.out(out));

task random();
begin
	
	repeat(20)
		begin
			in = $random;
			#10;
		
		end	

end
endtask




initial begin

	random();
	random();
	random();

end

initial begin
$monitor("The data IN is %0b and out is %0d ",in,out);
end



endmodule

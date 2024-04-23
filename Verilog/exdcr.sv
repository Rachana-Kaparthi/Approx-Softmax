`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2024 19:04:46
// Design Name: 
// Module Name: exdcr
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


module exdcr(X,Y,Bin,Bout,R );

input X,Y,Bin;
output Bout,R;

wire remainder;

assign R = X ^ Y ^ Bin;
assign Bout = (~(X ^ Y) & Bin) || (~X&Y); 
endmodule

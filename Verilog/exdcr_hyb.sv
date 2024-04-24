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


module exdcr_hyb(X,Y,Bin,flag,Bout,R );

input X,Y,Bin,flag;
output Bout,R;

wire remainder;

assign R = X ^ Y ^ Bin;
assign Bout =flag ? ((~(X ^ Y) & Bin) || (~X&Y)) : ((X&Y) || (Y&Bin) || (X&Bin)); 
endmodule

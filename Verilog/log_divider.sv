`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2024 20:56:58
// Design Name: 
// Module Name: log_divider
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


module log_divider(input [31:0]XL, [31:0]RH, Y[31:0], output [7:0]QL );

wire [63:0]data_merge;
wire [5:0]sel_64;
wire [4:0]sel_32;

assign data_merge = {XL,RH}; 

////////////////LOD - 64bits/////////

assign sel_64[5] = (data_merge[63:32] != 0) ? 1  : 0;
assign sel_64[4] = sel_64[5] ? ((data_merge[63:48] != 0) ? 1  : 0) : ((data_merge[31:16] != 0) ? 1  : 0);
assign sel_64[3] = sel_64[5] ? (sel_64[4] ? ((data_merge[63:56] != 0) ? 1 : 0) : ((data_merge[47:40] != 0) ? 1 : 0)) : (sel_64[4] ? ((data_merge[31:24] != 0) ? 1 : 0) : ((data_merge[15:8] != 0) ? 1 : 0));
assign sel_64[2] = (sel_64[5:3] == 3'b111) ? ((data_merge[63:60] !=0 ) ? 1 : 0 ) :((sel_64[5:3] == 3'b110) ? ((data_merge[59:56] !=0 ) ? 1 : 0 ) )
endmodule

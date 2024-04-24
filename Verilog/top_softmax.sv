`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2024 19:23:10
// Design Name: 
// Module Name: top_softmax
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


module top_softmax #(parameter wid_int = 5, wid_MSB1 = 4, wid_MSB2 = 4, wid_LSB = 8, size = 5)(input [16:0]x[1:5], output [16:0]softmax[1:5] );

logic [36:0]den;
logic [20:0]exp[1:5];  // 5bits position and 16bits exponent value
logic [15:0]quo[1:5];
logic [31:0]rem[1:5];
logic [5:0]LOD_nu[1:5];
logic [4:0]LOD_de;
logic [4:0]quo_append[1:5];
softmax #(.wid_int(wid_int), .wid_MSB1(wid_MSB1), .wid_MSB2(wid_MSB2), .wid_LSB(wid_LSB)) a1 (x[1],exp[1]);
softmax #(.wid_int(wid_int), .wid_MSB1(wid_MSB1), .wid_MSB2(wid_MSB2), .wid_LSB(wid_LSB)) a2 (x[2],exp[2]);
softmax #(.wid_int(wid_int), .wid_MSB1(wid_MSB1), .wid_MSB2(wid_MSB2), .wid_LSB(wid_LSB)) a3 (x[3],exp[3]);
softmax #(.wid_int(wid_int), .wid_MSB1(wid_MSB1), .wid_MSB2(wid_MSB2), .wid_LSB(wid_LSB)) a4 (x[4],exp[4]);
softmax #(.wid_int(wid_int), .wid_MSB1(wid_MSB1), .wid_MSB2(wid_MSB2), .wid_LSB(wid_LSB)) a5 (x[5],exp[5]);
//denominator a6( exp[1][20:0],exp[2][20:0],exp[3][20:0],exp[4][20:0],exp[5][20:0], den);

denominator b1 (
    .exp1(exp[1]),
    .exp2(exp[2]),
    .exp3(exp[3]),
    .exp4(exp[4]),
    .exp5(exp[5]),
    .Den(den)
);

LOD32 a9(.sel(LOD_de),.data(den[31:0]));
genvar i ;

generate 

for(i=1;i<=5;i++)begin

array_divider a7 (exp[i][15:8], den[31:0],rem[i],quo[i][15:8]);
//log_input[i] = {rem[i],exp[i][7:0],24'b0};
LOD64 a8(.sel(LOD_nu[i]),.data( {rem[i],exp[i][7:0],24'b0}));

log_divider a10 (.pos_nu(exp[i][20:16]),.pos_de(den[36:32]),
   .num( {rem[i],exp[i][7:0],24'b0}),
    .den(den[31:0]),
    .quo_low(quo[i][7:0]),
    .LOD_nu(LOD_nu[i]), .LOD_de(LOD_de));
    
assign quo_append[i]  = (exp[i][20:16] < 5'd8) ? (24-32-den[36:32]-(8-exp[i][20:16])) : (24-32-den[36:32]);

assign softmax[i]={1'b1,(quo[i]>>quo_append[i])};
 end
 endgenerate



endmodule

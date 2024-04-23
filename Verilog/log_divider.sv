`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2024 12:27:06 PM
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


module log_divider(
    input [4:0]pos_nu,pos_de,
    input [63:0]num,
    input [31:0]den,
    output [7:0]quo_low,
    input [5:0]LOD_nu, 
    input [4:0]LOD_de
    );
    

 wire [32:0]quo_temp;
 wire [5:0]quo_1;
 wire [31:0]quo_2;
 wire [3:0]pos_n;
 wire [63:0]num_temp;
 wire [31:0]den_temp;
 
 assign pos_n = pos_nu - 8;
 

 
 wire [5:0]LOD_n;
 wire [4:0]LOD_d;
 wire [31:0]k1,k2;
 wire [5:0]s1;
 wire [4:0]s2;
 
 assign LOD_n = 64 - LOD_nu; 
  assign LOD_d = 32 - LOD_de; 

 
 assign s1 = (pos_nu > 4'd8) ? (pos_n+(32-LOD_n)) : (64-LOD_n);
 assign s2 = pos_de - LOD_d ;
 
 
 assign num_temp=num << (LOD_n-1);
 assign den_temp=den << (LOD_d-1);
 assign k1 = num_temp[63:32];
 assign k2 = den_temp[31:0];
 
 
 assign quo_1 = s1-s2;
 assign quo_2 = k1-k2;
 
// assign quo_temp = quo_1 + quo_2;

 assign quo_low = (k1 >k2) ? (quo_1 ? ((1+k1-k2) << quo_1) : ((1+k1-k2) >> quo_1)): (quo_1 ? ((2+k1-k2) << (quo_1-1)) : ((2+k1-k2) >> (quo_1-1)));
     
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2024 12:32:08
// Design Name: 
// Module Name: Denominator
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


module denominator (input [20:0]exp1,exp2,exp3,exp4,exp5,output [36:0]Den
    );
    
wire [15:0]exp1_temp,exp2_temp,exp3_temp,exp4_temp,exp5_temp;
wire [4:0] highest;
wire [4:0]  temp_highest,temp_highest1, temp_highest2 ;
wire  [19:0] den;

assign temp_highest = (exp1[20:16] > exp2[20:16]) ? exp1[20:16] : exp2[20:16];
    // Compare the third value with the current highest
  assign  temp_highest1 = (exp3[20:16] > temp_highest) ? exp3[20:16] : temp_highest;

    // Compare the fourth value with the current highest
   assign temp_highest2 = (exp4[20:16] > temp_highest1) ? exp4[20:16] : temp_highest1;

    // Compare the fifth value with the current highest
 assign  highest = (exp5[20:16] > temp_highest) ? exp5[20:16] : temp_highest;
  
assign exp1_temp = highest > exp1[20:16] ? exp1[15:0] >> (highest-exp1[20:16]) : exp1[15:0] ;
assign exp2_temp = highest > exp2[20:16] ? exp2[15:0] >> (highest-exp2[20:16]) : exp2[15:0] ;
assign exp3_temp = highest > exp3[20:16] ? exp3[15:0] >> (highest-exp3[20:16]) : exp3[15:0] ;
assign exp4_temp = highest > exp4[20:16] ? exp4[15:0] >> (highest-exp4[20:16]) : exp4[15:0] ;
assign exp5_temp = highest > exp5[20:16] ? exp5[15:0] >> (highest-exp5[20:16]) : exp5[15:0] ;
//initial begin
//#20
//$display("%0h %0h %0h %0h" ,temp_highest,temp_highest1,temp_highest2, highest);
//$display("%0h %0h ", exp1_temp,exp2_temp );
//end

assign den = exp1_temp[15:0] + exp2_temp[15:0] + exp3_temp[15:0] + exp4_temp[15:0] + exp5_temp[15:0];

assign Den = {highest,den,12'b0};
endmodule

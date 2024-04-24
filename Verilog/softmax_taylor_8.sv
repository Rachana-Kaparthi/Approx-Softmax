`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.03.2024 12:09:23
// Design Name: 
// Module Name: softmax
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


module softmax_8 #(parameter wid_int = 5, wid_MSB1 = 4, wid_MSB2 = 0,wid_MSB3 = 0, wid_LSB=8)(input [16:0]x, output [20:0]exp);

/// x range -10 to 10

logic [19:0]exp_int[1:21]; 
logic [19:0]exp_MSB1[1:31];
logic [19:0]exp_LSB[1:31];
//logic [19:0]exp_LSB3[1:31];
//logic [19:0]exp_MSB3[1:(2**wid_MSB3)];

logic [wid_int-1 : 0]x_int;
logic [wid_MSB1-1 : 0]x_msb1;
logic [wid_LSB-1:0]x_lsb;
//logic [wid_MSB3-1:0]x_msb3;
//logic [(16-wid_int-wid_MSB1-wid_LSB2):0]x_lsb3;
logic [19:0]ans_int,ans_msb1,ans_lsb;
logic [31:0]ans_1,ans_2;
logic [20:0]ans;
logic [4:0]position, position1,position2,position3;
//logic [15:0]expval_int[1:8];
//logic [15:0]expval_MSB1[1:16];
//logic [15:0]expval_MSB2[1:16];
//logic [15:0]expval_LSB[1:4];

assign x_int = x[16:(17-wid_int)];
assign x_msb1 = x[(16-wid_int):(17-wid_int-wid_MSB1)];
//assign x_lsb2 = x[(16-wid_int-wid_MSB1):(17-wid_int-wid_MSB1-wid_LSB2)];
assign x_lsb = x[(16-wid_int-wid_MSB1):0];


logic flag;
logic [12:0]one;
logic [12:0]tayl;
logic [12:0]Carry;


///////////// 4 bits position data, 16bits value


assign exp_int[1] = 20'b00010000000000000000;
assign exp_int[2] = 20'b00010000000000000100;
assign exp_int[3] = 20'b00010000000000001010;
assign exp_int[4] = 20'b00010000000000011101;
assign exp_int[5] = 20'b00010000000001010001;
assign exp_int[6] = 20'b00010000000011011100;
assign exp_int[7] = 20'b00010000001001011000;
assign exp_int[8] = 20'b00010000011001011111;
assign exp_int[9] = 20'b00010001000101010010;
assign exp_int[10] = 20'b00010010111100010110;
assign exp_int[11] = 20'b00011000000000000000;
assign exp_int[12] = 20'b00101010110111110011;
assign exp_int[13] = 20'b00111110110001110010;
assign exp_int[14] = 20'b01011010000010110000;
assign exp_int[15] = 20'b01101101101001100100;
assign exp_int[16]= 20'b10001001010001101001;
assign exp_int[17] = 20'b10011100100110110110;
assign exp_int[18] = 20'b10111000100100010100;
assign exp_int[19] = 20'b11001011101001001111;
assign exp_int[20] = 20'b11011111110100111000;
assign exp_int[21] = 20'b11111010110000010100;

////////////////////// 2 bits integer and 14 bits fraction -- position data 0010 --- values are exp(0000) to exp(1111)

assign exp_MSB1[1] = 20'b00100001100100010000;
assign exp_MSB1[2] = 20'b00100001101010101101;
assign exp_MSB1[3] = 20'b00100001110001100110;
assign exp_MSB1[4] = 20'b00100001111000111011;
assign exp_MSB1[5] = 20'b00100010000000101110;
assign exp_MSB1[6] = 20'b00100010001001000001;
assign exp_MSB1[7] = 20'b00100010010001110111;
assign exp_MSB1[8] = 20'b00100010011011010001;
assign exp_MSB1[9] = 20'b00100010100101010010;
assign exp_MSB1[10] = 20'b00100010101111111100;
assign exp_MSB1[11] = 20'b00100010111011010010;
assign exp_MSB1[12] = 20'b00100011000111010111;
assign exp_MSB1[13] = 20'b00100011010100001110;
assign exp_MSB1[14] = 20'b00100011100001111010;
assign exp_MSB1[15] = 20'b00100011110000011111;
assign exp_MSB1[16] = 20'b00100100000000000000;
assign exp_MSB1[17] = 20'b00100100010000100000;
assign exp_MSB1[18] = 20'b00100100100010000101;
assign exp_MSB1[19] = 20'b00100100110100110010;
assign exp_MSB1[20] = 20'b00100101001000101101;
assign exp_MSB1[21] = 20'b00100101011101111010;
assign exp_MSB1[22] = 20'b00100101110100011110;
assign exp_MSB1[23] = 20'b00100110001100100000;
assign exp_MSB1[24] = 20'b00100110100110000100;
assign exp_MSB1[25] = 20'b00100111000001010010;
assign exp_MSB1[26] = 20'b00100111011110010001;
assign exp_MSB1[27] = 20'b00100111111101000111;
assign exp_MSB1[28] = 20'b00101000011101111100;
assign exp_MSB1[29] = 20'b00101001000000111001;
assign exp_MSB1[30] = 20'b00101001100110000111;
assign exp_MSB1[31] = 20'b00101010001101101110;

 
  
 integer i,j,k,m,n;
assign j = (x_int == 5'b11010) ? 1 :
           (x_int == 5'b11001) ? 2 :
           (x_int == 5'b11000) ? 3 :
           (x_int == 5'b10111) ? 4 :
           (x_int == 5'b10110) ? 5 :
           (x_int == 5'b10101) ? 6 :
           (x_int == 5'b10100) ? 7 :
           (x_int == 5'b10011) ? 8 :
           (x_int == 5'b10010) ? 9 :
           (x_int == 5'b10001) ? 10 :
           (x_int == 5'b00000) ? 11 :
           (x_int == 5'b00001) ? 12 :
           (x_int == 5'b00010) ? 13 :
           (x_int == 5'b00011) ? 14 :
           (x_int == 5'b00100) ? 15 :
           (x_int == 5'b00101) ? 16 :
           (x_int == 5'b00110) ? 17 :
           (x_int == 5'b00111) ? 18 :
           (x_int == 5'b01000) ? 19 :
           (x_int == 5'b01001) ? 20 :
           (x_int == 5'b01010) ? 21 :   0 ;      
assign ans_int = exp_int [j]; 

assign k = ({x_int[4],x_msb1} == 5'b11111) ? 1 :
           ({x_int[4],x_msb1} == 5'b11110) ? 2 :
           ({x_int[4],x_msb1} == 5'b11101) ? 3 :
           ({x_int[4],x_msb1} == 5'b11100) ? 4 :
           ({x_int[4],x_msb1} == 5'b11011) ? 5 :
           ({x_int[4],x_msb1} == 5'b11010) ? 6 :
           ({x_int[4],x_msb1} == 5'b11001) ? 7 :
           ({x_int[4],x_msb1} == 5'b11000) ? 8 :
           ({x_int[4],x_msb1} == 5'b10111) ? 9 :
           ({x_int[4],x_msb1} == 5'b10110) ? 10 :
           ({x_int[4],x_msb1} == 5'b10101) ? 11 :
           ({x_int[4],x_msb1} == 5'b10100) ? 12 :
           ({x_int[4],x_msb1} == 5'b10011) ? 13 :
           ({x_int[4],x_msb1} == 5'b10010) ? 14 :
           ({x_int[4],x_msb1} == 5'b10001) ? 15 :
           ({x_int[4],x_msb1} == 5'b00000) ? 16 :
           ({x_int[4],x_msb1} == 5'b00001) ? 17:
           ({x_int[4],x_msb1} == 5'b00010) ? 18 :
           ({x_int[4],x_msb1} == 5'b00011) ? 19:
           ({x_int[4],x_msb1} == 5'b00100) ? 20:
           ({x_int[4],x_msb1} == 5'b00101) ? 21:
           ({x_int[4],x_msb1} == 5'b00110) ? 22:
           ({x_int[4],x_msb1} == 5'b00111) ? 23:
           ({x_int[4],x_msb1} == 5'b01000) ? 24 :
           ({x_int[4],x_msb1} == 5'b01001) ? 25 :
           ({x_int[4],x_msb1} == 5'b01010) ? 26 :
           ({x_int[4],x_msb1} == 5'b01011) ? 27 :
           ({x_int[4],x_msb1} == 5'b01100) ? 28 :
           ({x_int[4],x_msb1} == 5'b01101) ? 29 :
           ({x_int[4],x_msb1} == 5'b01110) ? 30 :
           ({x_int[4],x_msb1} == 5'b01111) ? 31 :
           0;
           
assign ans_msb1 = exp_MSB1[k];



assign flag = x[16];    
assign one = 13'b1000000000000;
 assign tayl = {5'd0, x_lsb3};

exdcr_hyb s1(one[0],tayl[0],1'b0,flag,Carry[0],ans_lsb[3] );  

genvar i;

generate 
for(i=1; i<13; i++)begin

exdcr_hyb s2(one[i],tayl[i],Carry[i-1],flag,Carry[i],ans_lsb[i+3] );  

end
endgenerate  

assign ans_lsb[2:0] = 3'd0;
assign ans_lsb[19:16] = 4'd1;
           
assign position1 = ((32 - (ans_int[19:16] + ans_msb1[19:16]) ) > 16) ?  (32-(ans_int[19:16] + ans_msb1[19:16])-16) :0;
assign position2 = ((16+position1-ans_lsb[19:16]) > 16) ? (16+position1-ans_lsb[19:16]-16) :0;
// 64-(ans_int[19:16] + ans_msb1[19:16] + ans_msb2[19:16] + ans_lsb[19:16]);
//assign position3 = ((16+position2-ans_lsb3[19:16]) > 16) ? (16+position2-ans_lsb3[19:16]-16) :0;
assign position = (position2 < 16) ? (16-position2) : 0;
booth #(.N(16),.lsb(0)) b1
            ( .a(ans_int[15:0]),
             .b(ans_msb1[15:0]),
             .res(ans_1));
booth #(.N(16),.lsb(0)) b2
            ( .a(ans_1[31:16]),
             .b(ans_lsb[15:0]),
             .res(ans_2));
/*
booth #(.N(16),.lsb(1)) b3
            ( .a(ans_2[31:16]),
             .b(ans_lsb3[15:0]),
             .res(ans_3));          
*/
//assign ans_1 = ans_int[15:0]*ans_msb1[15:0];
//assign ans_2 = ans_1[31:16]*ans_msb2[15:0];
//assign ans_3 = ans_2[31:16]*ans_lsb[15:0];
assign exp = {position,ans_2[31:16]};




endmodule

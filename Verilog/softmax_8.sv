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


module softmax_8 #(parameter wid_int = 5, wid_MSB1 = 4, wid_MSB2 = 0,wid_MSB3 = 0, wid_LSB1=8)(input [16:0]x, output [20:0]exp);

/// x range -10 to 10

logic [19:0]exp_int[1:21]; 
logic [19:0]exp_MSB1[1:31];
logic [19:0]exp_LSB2[1:31];
logic [19:0]exp_LSB3[1:31];
//logic [19:0]exp_MSB3[1:(2**wid_MSB3)];

logic [wid_int-1 : 0]x_int;
logic [wid_MSB1-1 : 0]x_msb1;
logic [wid_LSB2-1:0]x_lsb2;
//logic [wid_MSB3-1:0]x_msb3;
logic [(16-wid_int-wid_MSB1-wid_LSB2):0]x_lsb3;
logic [19:0]ans_int,ans_msb1,ans_lsb2, ans_lsb3;
logic [31:0]ans_1,ans_2,ans_3;
logic [20:0]ans;
logic [4:0]position, position1,position2,position3;
//logic [15:0]expval_int[1:8];
//logic [15:0]expval_MSB1[1:16];
//logic [15:0]expval_MSB2[1:16];
//logic [15:0]expval_LSB[1:4];

assign x_int = x[16:(17-wid_int)];
assign x_msb1 = x[(16-wid_int):(17-wid_int-wid_MSB1)];
assign x_lsb2 = x[(16-wid_int-wid_MSB1):(17-wid_int-wid_MSB1-wid_LSB2)];
assign x_lsb3 = x[(16-wid_int-wid_MSB1-wid_LSB2):0];
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

//////////////////// 1bit integer and 15bits fraction ---position bits 4 bits ---  0001
/*
assign exp_MSB2[1] = 20'b00011000000000000000;
assign exp_MSB2[2] = 20'b00011000000010000000;
assign exp_MSB2[3] = 20'b00011000000100000001;
assign exp_MSB2[4] = 20'b00011000000110000010;
assign exp_MSB2[5] = 20'b00011000001000000100;
assign exp_MSB2[6] = 20'b00011000001010000110;
assign exp_MSB2[7] = 20'b00011000001100001001;
assign exp_MSB2[8] = 20'b00011000001110001100;
assign exp_MSB2[9] = 20'b00011000010000010000;
assign exp_MSB2[10] = 20'b00011000010010010100;
assign exp_MSB2[11] = 20'b00011000010100011001;
assign exp_MSB2[12] = 20'b00011000010110011110;
assign exp_MSB2[13] = 20'b00011000011000100100;
assign exp_MSB2[14] = 20'b00011000011010101010;
assign exp_MSB2[15] = 20'b00011000011100110001;
assign exp_MSB2[16] = 20'b00011000011110111001;
*/
/////////////////// 1bit integer and 15bits fraction

assign exp_LSB2[1] = 20'b00010111100010000000;
assign exp_LSB2[2] = 20'b00010111100100000000;
assign exp_LSB2[3] = 20'b00010111100110000000;
assign exp_LSB2[4] = 20'b00010111101000000000;
assign exp_LSB2[5] = 20'b00010111101010000000;
assign exp_LSB2[6] = 20'b00010111101100000000;
assign exp_LSB2[7] = 20'b00010111101110000000;
assign exp_LSB2[8] = 20'b00010111110000000000;
assign exp_LSB2[9] = 20'b00010111110010000000;
assign exp_LSB2[10] = 20'b00010111110100000000;
assign exp_LSB2[11] = 20'b00010111110110000000;
assign exp_LSB2[12] = 20'b00010111111000000000;
assign exp_LSB2[13] = 20'b00010111111010000000;
assign exp_LSB2[14] = 20'b00010111111100000000;
assign exp_LSB2[15] = 20'b00010111111110000000;
assign exp_LSB2[16] = 20'b00011000000000000000;
assign exp_LSB2[17] = 20'b00011000000010000000;
assign exp_LSB2[18] = 20'b00011000000100000000;
assign exp_LSB2[19] = 20'b00011000000110000000;
assign exp_LSB2[20] = 20'b00011000001000000000;
assign exp_LSB2[21] = 20'b00011000001010000000;
assign exp_LSB2[22] = 20'b00011000001100000000;
assign exp_LSB2[23] = 20'b00011000001110000000;
assign exp_LSB2[24] = 20'b00011000010000000000;
assign exp_LSB2[25] = 20'b00011000010010000000;
assign exp_LSB2[26] = 20'b00011000010100000000;
assign exp_LSB2[27] = 20'b00011000010110000000;
assign exp_LSB2[28] = 20'b00011000011000000000;
assign exp_LSB2[29] = 20'b00011000011010000000;
assign exp_LSB2[30] = 20'b00011000011100000000;
assign exp_LSB2[31] = 20'b00011000011110000000;
//////////////////////////////

assign exp_LSB3[1] = 20'b00010111111110001000;
assign exp_LSB3[2] = 20'b00010111111110010000;
assign exp_LSB3[3] = 20'b00010111111110011000;
assign exp_LSB3[4] = 20'b00010111111110100000;
assign exp_LSB3[5] = 20'b00010111111110101000;
assign exp_LSB3[6] = 20'b00010111111110110000;
assign exp_LSB3[7] = 20'b00010111111110111000;
assign exp_LSB3[8] = 20'b00010111111111000000;
assign exp_LSB3[9] = 20'b00010111111111001000;
assign exp_LSB3[10] = 20'b00010111111111010000;
assign exp_LSB3[11] = 20'b00010111111111011000;
assign exp_LSB3[12] = 20'b00010111111111100000;
assign exp_LSB3[13] = 20'b00010111111111101000;
assign exp_LSB3[14] = 20'b00010111111111110000;
assign exp_LSB3[15] = 20'b00010111111111111000;
assign exp_LSB3[16] = 20'b00011000000000000000;
assign exp_LSB3[17] = 20'b00011000000000001000;
assign exp_LSB3[18] = 20'b00011000000000010000;
assign exp_LSB3[19] = 20'b00011000000000011000;
assign exp_LSB3[20] = 20'b00011000000000100000;
assign exp_LSB3[21] = 20'b00011000000000101000;
assign exp_LSB3[22] = 20'b00011000000000110000;
assign exp_LSB3[23] = 20'b00011000000000111000;
assign exp_LSB3[24] = 20'b00011000000000111111;
assign exp_LSB3[25] = 20'b00011000000001001000;
assign exp_LSB3[26] = 20'b00011000000001010000;
assign exp_LSB3[27] = 20'b00011000000001011000;
assign exp_LSB3[28] = 20'b00011000000001100000;
assign exp_LSB3[29] = 20'b00011000000001101000;
assign exp_LSB3[30] = 20'b00011000000001110000;
assign exp_LSB3[31] = 20'b00011000000001111000;
//// For x[1]
//assign {x_pos[1], x_int[1], x_msb1[1], x_msb2[1], x_lsb[1]} = {x[1][15:13], x[1][12:10], x[1][9:6], x[1][5:2], x[1][1:0]};

//// For x[2]
//assign { x_pos[2], x_int[2], x_msb1[2], x_msb2[2], x_lsb[2]} = {x[2][15:13], x[2][12:10], x[2][9:6], x[2][5:2], x[2][1:0]};

//// For x[3]
//assign { x_pos[3], x_int[3], x_msb1[3], x_msb2[3],  x_lsb[3]} = {x[2][15:13], x[3][12:10], x[3][9:6], x[3][5:2], x[3][1:0]};

//// For x[4]
//assign { x_pos[4], x_int[4], x_msb1[4], x_msb2[4],  x_lsb[4]} = {x[2][15:13], x[4][12:10], x[4][9:6], x[4][5:2], x[4][1:0]};

//// For x[5]
//assign {x_pos[5], x_int[5], x_msb1[5], x_msb2[5],  x_lsb[5]} = {x[2][15:13], x[5][12:10], x[5][9:6], x[5][5:2], x[5][1:0]};
 
 
  
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

assign m = ({x_int[4],x_lsb2} == 5'b11111) ? 1 :
           ({x_int[4],x_lsb2} == 5'b11110) ? 2 :
           ({x_int[4],x_lsb2} == 5'b11101) ? 3 :
           ({x_int[4],x_lsb2} == 5'b11100) ? 4 :
           ({x_int[4],x_lsb2} == 5'b11011) ? 5 :
           ({x_int[4],x_lsb2} == 5'b11010) ? 6 :
           ({x_int[4],x_lsb2} == 5'b11001) ? 7 :
           ({x_int[4],x_lsb2} == 5'b11000) ? 8 :
           ({x_int[4],x_lsb2} == 5'b10111) ? 9 :
           ({x_int[4],x_lsb2} == 5'b10110) ? 10 :
           ({x_int[4],x_lsb2} == 5'b10101) ? 11 :
           ({x_int[4],x_lsb2} == 5'b10100) ? 12 :
           ({x_int[4],x_lsb2} == 5'b10011) ? 13 :
           ({x_int[4],x_lsb2} == 5'b10010) ? 14 :
           ({x_int[4],x_lsb2} == 5'b10001) ? 15 :
           ({x_int[4],x_lsb2} == 5'b00000) ? 16 :
           ({x_int[4],x_lsb2} == 5'b00001) ? 17:
           ({x_int[4],x_lsb2} == 5'b00010) ? 18 :
           ({x_int[4],x_lsb2} == 5'b00011) ? 19:
           ({x_int[4],x_lsb2} == 5'b00100) ? 20:
           ({x_int[4],x_lsb2} == 5'b00101) ? 21:
           ({x_int[4],x_lsb2} == 5'b00110) ? 22:
           ({x_int[4],x_lsb2} == 5'b00111) ? 23:
           ({x_int[4],x_lsb2} == 5'b01000) ? 24 :
           ({x_int[4],x_lsb2} == 5'b01001) ? 25 :
           ({x_int[4],x_lsb2} == 5'b01010) ? 26 :
           ({x_int[4],x_lsb2} == 5'b01011) ? 27 :
           ({x_int[4],x_lsb2} == 5'b01100) ? 28 :
           ({x_int[4],x_lsb2} == 5'b01101) ? 29 :
           ({x_int[4],x_lsb2} == 5'b01110) ? 30 :
           ({x_int[4],x_lsb2} == 5'b01111) ? 31 :
           0;
           
assign  ans_lsb2 = exp_LSB2[m];
/*assign n = (x_lsb == 3'b000) ? 1 :
           (x_lsb == 3'b001) ? 2 :
           (x_lsb == 3'b010) ? 3 :
           (x_lsb == 3'b011) ? 4 :
           (x_lsb == 3'b100) ? 5 :
           (x_lsb == 3'b101) ? 6 :
           (x_lsb == 3'b110) ? 7 :
           (x_lsb == 3'b111) ? 8 :
           0; 
assign ans_lsb = exp_LSB[n];
*/

assign n = ({x_int[4],x_lsb3} == 5'b11111) ? 1 :
           ({x_int[4],x_lsb3} == 5'b11110) ? 2 :
           ({x_int[4],x_lsb3} == 5'b11101) ? 3 :
           ({x_int[4],x_lsb3} == 5'b11100) ? 4 :
           ({x_int[4],x_lsb3} == 5'b11011) ? 5 :
           ({x_int[4],x_lsb3} == 5'b11010) ? 6 :
           ({x_int[4],x_lsb3} == 5'b11001) ? 7 :
           ({x_int[4],x_lsb3} == 5'b11000) ? 8 :
           ({x_int[4],x_lsb3} == 5'b10111) ? 9 :
           ({x_int[4],x_lsb3} == 5'b10110) ? 10 :
           ({x_int[4],x_lsb3} == 5'b10101) ? 11 :
           ({x_int[4],x_lsb3} == 5'b10100) ? 12 :
           ({x_int[4],x_lsb3} == 5'b10011) ? 13 :
           ({x_int[4],x_lsb3} == 5'b10010) ? 14 :
           ({x_int[4],x_lsb3} == 5'b10001) ? 15 :
           ({x_int[4],x_lsb3} == 5'b00000) ? 16 :
           ({x_int[4],x_lsb3} == 5'b00001) ? 17:
           ({x_int[4],x_lsb3} == 5'b00010) ? 18 :
           ({x_int[4],x_lsb3} == 5'b00011) ? 19:
           ({x_int[4],x_lsb3} == 5'b00100) ? 20:
           ({x_int[4],x_lsb3} == 5'b00101) ? 21:
           ({x_int[4],x_lsb3} == 5'b00110) ? 22:
           ({x_int[4],x_lsb3} == 5'b00111) ? 23:
           ({x_int[4],x_lsb3} == 5'b01000) ? 24 :
           ({x_int[4],x_lsb3} == 5'b01001) ? 25 :
           ({x_int[4],x_lsb3} == 5'b01010) ? 26 :
           ({x_int[4],x_lsb3} == 5'b01011) ? 27 :
           ({x_int[4],x_lsb3} == 5'b01100) ? 28 :
           ({x_int[4],x_lsb3} == 5'b01101) ? 29 :
           ({x_int[4],x_lsb3} == 5'b01110) ? 30 :
           ({x_int[4],x_lsb3} == 5'b01111) ? 31 :
           0;
           
assign  ans_lsb3 = exp_LSB3[n];
assign position1 = ((32 - (ans_int[19:16] + ans_msb1[19:16]) ) > 16) ?  (32-(ans_int[19:16] + ans_msb1[19:16])-16) :0;
assign position2 = ((16+position1-ans_lsb2[19:16]) > 16) ? (16+position1-ans_lsb2[19:16]-16) :0;
// 64-(ans_int[19:16] + ans_msb1[19:16] + ans_msb2[19:16] + ans_lsb[19:16]);
assign position3 = ((16+position2-ans_lsb3[19:16]) > 16) ? (16+position2-ans_lsb3[19:16]-16) :0;
assign position = (position3 < 16) ? (16-position3) : 0;
booth #(.N(16),.lsb(0)) b1
            ( .a(ans_int[15:0]),
             .b(ans_msb1[15:0]),
             .res(ans_1));
booth #(.N(16),.lsb(0)) b2
            ( .a(ans_1[31:16]),
             .b(ans_lsb2[15:0]),
             .res(ans_2));
booth #(.N(16),.lsb(1)) b3
            ( .a(ans_2[31:16]),
             .b(ans_lsb3[15:0]),
             .res(ans_3));          
//assign ans_1 = ans_int[15:0]*ans_msb1[15:0];
//assign ans_2 = ans_1[31:16]*ans_msb2[15:0];
//assign ans_3 = ans_2[31:16]*ans_lsb[15:0];
assign exp = {position,ans_3[31:16]};




endmodule

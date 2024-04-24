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


module softmax #(parameter wid_int = 5, wid_MSB1 = 4, wid_MSB2 = 4, wid_LSB = 4, wid_MSB3 = 0)(input [16:0]x, output [20:0]exp);

/// x range -10 to 10

logic [19:0]exp_int[1:21]; 
logic [19:0]exp_MSB1[1:(2**wid_MSB1)];
logic [19:0]exp_MSB2[1:(2**wid_MSB2)];
logic [19:0]exp_LSB[1:(2**wid_LSB)];
//logic [19:0]exp_MSB3[1:(2**wid_MSB3)];

logic [wid_int-1 : 0]x_int;
logic [wid_MSB1-1 : 0]x_msb1;
logic [wid_MSB2-1:0]x_msb2;
//logic [wid_MSB3-1:0]x_msb3;
logic [(16-wid_int-wid_MSB1-wid_MSB2):0]x_lsb;
logic [19:0]ans_int,ans_msb1,ans_msb2,ans_lsb;
logic [31:0]ans_1,ans_2,ans_3;
logic [20:0]ans;
logic [4:0]position, position1,position2,position3;
//logic [15:0]expval_int[1:8];
//logic [15:0]expval_MSB1[1:16];
//logic [15:0]expval_MSB2[1:16];
//logic [15:0]expval_LSB[1:4];

assign x_int = x[16:(17-wid_int)];
assign x_msb1 = x[(16-wid_int):(17-wid_int-wid_MSB1)];
assign x_msb2 = x[(16-wid_int-wid_MSB1):(17-wid_int-wid_MSB1-wid_MSB2)];
assign x_lsb = x[(16-wid_int-wid_MSB1-wid_MSB2):0];
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

assign exp_MSB1[1] = 20'b00100100000000000000;
assign exp_MSB1[2] = 20'b00100100010000100000;
assign exp_MSB1[3] = 20'b00100100100010000101;
assign exp_MSB1[4] = 20'b00100100110100110010;
assign exp_MSB1[5] = 20'b00100101001000101101;
assign exp_MSB1[6] = 20'b00100101011101111010;
assign exp_MSB1[7] = 20'b00100101110100011110;
assign exp_MSB1[8] = 20'b00100110001100100000;
assign exp_MSB1[9] = 20'b00100110100110000100;
assign exp_MSB1[10] = 20'b00100111000001010010;
assign exp_MSB1[11] = 20'b00100111011110010001;
assign exp_MSB1[12] = 20'b00100111111101000111;
assign exp_MSB1[13] = 20'b00101000011101111100;
assign exp_MSB1[14] = 20'b00101001000000111001;
assign exp_MSB1[15] = 20'b00101001100110000111;
assign exp_MSB1[16] = 20'b00101010001101101110;

//////////////////// 1bit integer and 15bits fraction ---position bits 4 bits ---  0001

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

/////////////////// 1bit integer and 15bits fraction
//assign exp_LSB[1] = 20'b00011000000000000000;
//assign exp_LSB[2] = 20'b00011000000000010000;
//assign exp_LSB[3] = 20'b00011000000000100000;
//assign exp_LSB[4] = 20'b00011000000000110000;
//assign exp_LSB[5] = 20'b00011000000001000000;
//assign exp_LSB[6] = 20'b00011000000001010000;
//assign exp_LSB[7] = 20'b00011000000001100000;
//assign exp_LSB[8] = 20'b00011000000001110000;

assign exp_LSB[1] = 20'b00011000000000000000;
assign exp_LSB[2] = 20'b00011000000000001000;
assign exp_LSB[3] = 20'b00011000000000010000;
assign exp_LSB[4] = 20'b00011000000000011000;
assign exp_LSB[5] = 20'b00011000000000100000;
assign exp_LSB[6] = 20'b00011000000000101000;
assign exp_LSB[7] = 20'b00011000000000110000;
assign exp_LSB[8] = 20'b00011000000000111000;
assign exp_LSB[9] = 20'b00011000000001000000;
assign exp_LSB[10] = 20'b00011000000001001000;
assign exp_LSB[11] = 20'b00011000000001010000;
assign exp_LSB[12] = 20'b00011000000001011000;
assign exp_LSB[13] = 20'b00011000000001100000;
assign exp_LSB[14] = 20'b00011000000001101000;
assign exp_LSB[15] = 20'b00011000000001110000;
assign exp_LSB[16] = 20'b00011000000001111000;

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

assign k = (x_msb1 == 4'b0000) ? 1 :
           (x_msb1 == 4'b0001) ? 2 :
           (x_msb1 == 4'b0010) ? 3 :
           (x_msb1 == 4'b0011) ? 4 :
           (x_msb1 == 4'b0100) ? 5 :
           (x_msb1 == 4'b0101) ? 6 :
           (x_msb1 == 4'b0110) ? 7 :
           (x_msb1 == 4'b0111) ? 8 :
           (x_msb1 == 4'b1000) ? 9 :
           (x_msb1 == 4'b1001) ? 10 :
           (x_msb1 == 4'b1010) ? 11 :
           (x_msb1 == 4'b1011) ? 12 :
           (x_msb1 == 4'b1100) ? 13 :
           (x_msb1 == 4'b1101) ? 14 :
           (x_msb1 == 4'b1110) ? 15 :
           (x_msb1 == 4'b1111) ? 16 :
           0;
           
assign ans_msb1 = exp_MSB1[k];

assign m = (x_msb2 == 4'b0000) ? 1 :
           (x_msb2 == 4'b0001) ? 2 :
           (x_msb2 == 4'b0010) ? 3 :
           (x_msb2 == 4'b0011) ? 4 :
           (x_msb2 == 4'b0100) ? 5 :
           (x_msb2 == 4'b0101) ? 6 :
           (x_msb2 == 4'b0110) ? 7 :
           (x_msb2 == 4'b0111) ? 8 :
           (x_msb2 == 4'b1000) ? 9 :
           (x_msb2 == 4'b1001) ? 10 :
           (x_msb2 == 4'b1010) ? 11 :
           (x_msb2 == 4'b1011) ? 12 :
           (x_msb2 == 4'b1100) ? 13 :
           (x_msb2 == 4'b1101) ? 14 :
           (x_msb2 == 4'b1110) ? 15 :
           (x_msb2 == 4'b1111) ? 16 :
           0;
           
assign  ans_msb2 = exp_MSB2[m];
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

assign n = (x_lsb == 4'b0000) ? 1 :
           (x_lsb == 4'b0001) ? 2 :
           (x_lsb == 4'b0010) ? 3 :
           (x_lsb == 4'b0011) ? 4 :
           (x_lsb == 4'b0100) ? 5 :
           (x_lsb == 4'b0101) ? 6 :
           (x_lsb == 4'b0110) ? 7 :
           (x_lsb == 4'b0111) ? 8 :
           (x_lsb == 4'b1000) ? 9 :
           (x_lsb == 4'b1001) ? 10 :
           (x_lsb == 4'b1010) ? 11 :
           (x_lsb == 4'b1011) ? 12 :
           (x_lsb == 4'b1100) ? 13 :
           (x_lsb == 4'b1101) ? 14 :
           (x_lsb == 4'b1110) ? 15 :
           (x_lsb == 4'b1111) ? 16 :
           0;
           
assign  ans_lsb = exp_LSB[n];
assign position1 = ((32 - (ans_int[19:16] + ans_msb1[19:16]) ) > 16) ?  (32-(ans_int[19:16] + ans_msb1[19:16])-16) :0;
assign position2 = ((16+position1-ans_msb2[19:16]) > 16) ? (16+position1-ans_msb2[19:16]-16) :0;
// 64-(ans_int[19:16] + ans_msb1[19:16] + ans_msb2[19:16] + ans_lsb[19:16]);
assign position3 = ((16+position2-ans_lsb[19:16]) > 16) ? (16+position2-ans_lsb[19:16]-16) :0;
assign position = (position3 < 16) ? (16-position3) : 0;
booth #(.N(16),.lsb(0)) b1
            ( .a(ans_int[15:0]),
             .b(ans_msb1[15:0]),
             .res(ans_1));
booth #(.N(16),.lsb(0)) b2
            ( .a(ans_1[31:16]),
             .b(ans_msb2[15:0]),
             .res(ans_2));
booth #(.N(16),.lsb(1)) b3
            ( .a(ans_2[31:16]),
             .b(ans_lsb[15:0]),
             .res(ans_3));          
//assign ans_1 = ans_int[15:0]*ans_msb1[15:0];
//assign ans_2 = ans_1[31:16]*ans_msb2[15:0];
//assign ans_3 = ans_2[31:16]*ans_lsb[15:0];
assign exp = {position,ans_3[31:16]};




endmodule

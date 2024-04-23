`timescale 1ns/1ps

`include "booth_reduction.sv"

module booth #(parameter N = 16,lsb = 0)
            (input [N-1:0] a,
             input [N-1:0] b,
             output reg [(2*N)-1:0] res );
             

reg [2:0] mr_window1, mr_window2,mr_window3, mr_window4,mr_window5,mr_window6,mr_window7,mr_window8;
reg [N-1:0] p [0:(N/2)-1];
reg [(N/2)-1:0] q;
reg [N-1:0] q1 [0:(N/2)-1];
reg [(N/2)-1:0] s;
reg [(N/2-1):0] r_msb;
reg [N-2:0] r_slice [0:(N/2)-1];
reg [(2*N)-1:0] pp [0:(N/2)-1];
reg [(2*N)-1:0]pp1;
reg [(2*N)-1:0]pp2;
//reg [(2*N)-1:0]pp1;
//reg [(2*N)-1:0]pp2;
//reg [N-1:0] pp_tmp [0:(N/2)-1];
  
 //mr_window
assign mr_window1 = {b[1:0],1'b0};
assign mr_window2 = b[3:1];
assign mr_window3 = b[5:3];
assign mr_window4 = b[7:5];
assign mr_window5 = b[9:7];
assign mr_window6 = b[11:9];
assign mr_window7 = b[13:11];
assign mr_window8 = b[15:13];
//positive or negative
assign p[0] = (mr_window1[2]) ? (~a + 1'b1) : a;
assign p[1] = (mr_window2[2]) ? (~a + 1'b1) : a;
assign p[2] = (mr_window3[2]) ? (~a + 1'b1) : a;
assign p[3] = (mr_window4[2]) ? (~a + 1'b1) : a;
assign p[4] = (mr_window5[2]) ? (~a + 1'b1) : a;
assign p[5] = (mr_window6[2]) ? (~a + 1'b1) : a;
assign p[6] = (mr_window7[2]) ? (~a + 1'b1) : a;
assign p[7] = (mr_window8[2]) ? (~a + 1'b1) : a;

//zero or non-zero
assign q[0] = (mr_window1[2] | mr_window1[1] | mr_window1[0]) & (~(mr_window1[2] & mr_window1[1] & mr_window1[0]));
assign q[1] = (mr_window2[2] | mr_window2[1] | mr_window2[0]) & (~(mr_window2[2] & mr_window2[1] & mr_window2[0]));
assign q[2] = (mr_window3[2] | mr_window3[1] | mr_window3[0]) & (~(mr_window3[2] & mr_window3[1] & mr_window3[0]));
assign q[3] = (mr_window4[2] | mr_window4[1] | mr_window4[0]) & (~(mr_window4[2] & mr_window4[1] & mr_window4[0]));
assign q[4] = (mr_window5[2] | mr_window5[1] | mr_window5[0]) & (~(mr_window5[2] & mr_window5[1] & mr_window5[0]));
assign q[5] = (mr_window6[2] | mr_window6[1] | mr_window6[0]) & (~(mr_window6[2] & mr_window6[1] & mr_window6[0]));
assign q[6] = (mr_window7[2] | mr_window7[1] | mr_window7[0]) & (~(mr_window7[2] & mr_window7[1] & mr_window7[0]));
assign q[7] = (mr_window8[2] | mr_window8[1] | mr_window8[0]) & (~(mr_window8[2] & mr_window8[1] & mr_window8[0]));
//extending to N-bits
assign q1[0] = {16{q[0]}};
assign q1[1] = {16{q[1]}};
assign q1[2] = {16{q[2]}};
assign q1[3] = {16{q[3]}};
assign q1[4] = {16{q[4]}};
assign q1[5] = {16{q[5]}};
assign q1[6] = {16{q[6]}};
assign q1[7] = {16{q[7]}};
//slicing
assign {r_msb[0],r_slice[0]} = p[0] & q1[0];
assign {r_msb[1],r_slice[1]} = p[1] & q1[1];
assign {r_msb[2],r_slice[2]} = p[2] & q1[2];
assign {r_msb[3],r_slice[3]} = p[3] & q1[3];
assign {r_msb[4],r_slice[4]} = p[4] & q1[4];
assign {r_msb[5],r_slice[5]} = p[5] & q1[5];
assign {r_msb[6],r_slice[6]} = p[6] & q1[6];
assign {r_msb[7],r_slice[7]} = p[7] & q1[7];
//multiply by 2 or not
assign s[0] = ~(mr_window1[1] ^ mr_window1[0]); 
assign s[1] = ~(mr_window2[1] ^ mr_window2[0]);
assign s[2] = ~(mr_window3[1] ^ mr_window3[0]);
assign s[3] = ~(mr_window4[1] ^ mr_window4[0]);
assign s[4] = ~(mr_window5[1] ^ mr_window5[0]);
assign s[5] = ~(mr_window6[1] ^ mr_window6[0]);
assign s[6] = ~(mr_window7[1] ^ mr_window7[0]);
assign s[7] = ~(mr_window8[1] ^ mr_window8[0]);
//partial product 
assign pp[0] = {{17{r_msb[0]}}, {(s[0] ? (r_slice[0]<<1) : r_slice[0])}};
assign pp[1] = {{15{r_msb[1]}}, {(s[1] ? (r_slice[1]<<1) : r_slice[1])},2'b0};
assign pp[2] = {{13{r_msb[2]}}, {(s[2] ? (r_slice[2]<<1) : r_slice[2])},4'b0};
assign pp[3] = {{11{r_msb[3]}}, {(s[3] ? (r_slice[3]<<1) : r_slice[3])},6'b0};
assign pp[4] = {{9{r_msb[4]}}, {(s[4] ? (r_slice[4]<<1) : r_slice[4])},8'b0};
assign pp[5] = {{7{r_msb[5]}}, {(s[5] ? (r_slice[5]<<1) : r_slice[5])},10'b0};
assign pp[6] = {{5{r_msb[6]}}, {(s[6] ? (r_slice[6]<<1) : r_slice[6])},12'b0};
assign pp[7] = {{3{r_msb[7]}}, {(s[7] ? (r_slice[7]<<1) : r_slice[7])},14'b0}; 

pp_reduction_booth #(.Bitwidth(N)) c1 (.pp(pp),.res(res));


if(lsb == 1'b1) begin
    assign pp[5] = 'b0;
    assign pp[6] = 'b0;
    assign pp[7] = {18'b1,14'b0};
    pp_reduction_booth#(.Bitwidth(N)) a1 (

    .pp(pp),
    .res(res));
    end
 else
    pp_reduction_booth#(.Bitwidth(N)) a2 (.pp(pp),  .res(res));
//assign res = pp1+(pp2<<1);

endmodule

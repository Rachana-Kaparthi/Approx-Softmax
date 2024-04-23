`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2024 19:30:11
// Design Name: 
// Module Name: array_divider
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


module array_divider(input [7:0]X,[31:0]Y,output [31:0]RH,[7:0]QH);
wire [32:0]XH; 
wire [31:0]Bout1,Bout2,Bout3,Bout4,Bout5,Bout6,Bout7,Bout8;
wire [31:0]R1,R2,R2,R3,R4,R5,R6,R7,R8;
wire [32:0]remainder1,remainder2,remainder3,remainder4,remainder5,remainder6,remainder7,remainder8;

assign XH = {X,25'b0};
//// row1 ////

exdcr a1(XH[0],Y[0],1'b0,Bout1[0],R1[0]);

genvar i ;
generate
for (i =1;i<=31;i++)begin
exdcr a2(XH[i],Y[i],Bout1[i-1],Bout1[i],R1[i]);
end
endgenerate
assign QH[7] = XH[32] || (~Bout1[31]) ; 

assign remainder1 = QH[7] ? {R1[31:0],1'b0} : {XH[31:0],1'b0} ;


/////////// row2 ///////////

exdcr a3(remainder1[0],Y[0],1'b0,Bout2[0],R2[0]);

genvar j ;
generate
for (j =1;j<=31;j++)begin
exdcr a4(remainder1[j],Y[j],Bout2[j-1],Bout2[j],R2[j]);
end
endgenerate
assign QH[6] = remainder1[32] || (~Bout2[31]) ; 

assign remainder2 = QH[6] ? {R2[31:0],1'b0} : {remainder1[31:0],1'b0} ;

/////////// row3 ////////////////

exdcr a5(remainder2[0],Y[0],1'b0,Bout3[0],R3[0]);

genvar k ;
generate
for (k =1;k<=31;k++)begin
exdcr a6(remainder2[k],Y[k],Bout3[j-1],Bout3[j],R3[j]);
end
endgenerate
assign QH[5] = remainder2[32] || (~Bout3[31]) ; 

assign remainder3 = QH[5] ? {R3[31:0],1'b0} : {remainder2[31:0],1'b0} ;



///////////////// row4 ///////////////////////

exdcr a7(remainder3[0],Y[0],1'b0,Bout4[0],R4[0]);

genvar l ;
generate
for (l =1;l<=3;l++)begin
exdcr a8(remainder3[l],Y[l],Bout4[l-1],Bout4[l],R4[l]);
end
endgenerate
assign QH[4] = remainder3[32] || (~Bout4[31]) ; 

assign remainder4= QH[4] ? {R4[31:0],1'b0} : {remainder3[31:0],1'b0} ;


/////////////////// row5 //////////////////////

exdcr a9(remainder4[0],Y[0],1'b0,Bout5[0],R5[0]);

genvar m ;
generate
for (m =1;m<=3;m++)begin
exdcr a10(remainder4[l],Y[l],Bout5[l-1],Bout5[l],R5[l]);
end
endgenerate
assign QH[3] = remainder4[32] || (~Bout5[31]) ; 

assign remainder5= QH[3] ? {R5[31:0],1'b0} : {remainder4[31:0],1'b0} ;

/////////////////////// row6 ////////////////////////////

exdcr a11(remainder5[0],Y[0],1'b0,Bout6[0],R6[0]);

genvar n ;
generate
for (n =1;n<=3;n++)begin
exdcr a12(remainder5[l],Y[l],Bout6[l-1],Bout6[l],R6[l]);
end
endgenerate
assign QH[2] = remainder5[32] || (~Bout6[31]) ; 

assign remainder6= QH[2] ? {R6[31:0],1'b0} : {remainder5[31:0],1'b0} ;

//////////////////////// row7 ///////////////////////////

exdcr a13(remainder6[0],Y[0],1'b0,Bout7[0],R7[0]);

genvar p ;
generate
for (p =1;p<=3;p++)begin
exdcr a14(remainder6[l],Y[l],Bout7[l-1],Bout8[l],R7[l]);
end
endgenerate
assign QH[1] = remainder6[32] || (~Bout7[31]) ; 

assign remainder7= QH[1] ? {R7[31:0],1'b0} : {remainder6[31:0],1'b0} ;

///////////////////////// row8 ////////////////////

exdcr a15(remainder7[0],Y[0],1'b0,Bout8[0],R8[0]);

genvar r ;
generate
for (r =1;r<=3;r++)begin
exdcr a16(remainder7[l],Y[l],Bout8[l-1],Bout8[l],R8[l]);
end
endgenerate
assign QH[0] = remainder7[32] || (~Bout8[31]) ; 

assign remainder8= QH[0] ? {R8[31:0],1'b0} : {remainder7[31:0],1'b0} ;

////////////////////////////////////

assign RH = remainder8[32:1];

endmodule


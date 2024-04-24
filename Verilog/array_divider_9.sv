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


module array_divider9(input [7:0]X,[8:0]Y,output [7:0]RH,[7:0]QH);
wire [8:0]XH; 
wire [8:0]Bout1,Bout2,Bout3,Bout4,Bout5,Bout6,Bout7,Bout8;
wire [8:0]R1,R2,R3,R4,R5,R6,R7,R8;
wire [9:0]remainder1,remainder2,remainder3,remainder4,remainder5,remainder6,remainder7,remainder8;

assign XH = {X,1'b0};
//// row1 ////

exdcr a1(XH[0],Y[0],1'b0,Bout1[0],R1[0]);

genvar i ;
generate
for (i =1;i<=8;i++)begin
exdcr a2(XH[i],Y[i],Bout1[i-1],Bout1[i],R1[i]);
end
endgenerate
assign QH[7] = Bout1[8] ? 0 : 1  ; 

assign remainder1 = QH[7] ? {R1[8:0],1'b0} : {XH[8:0],1'b0} ;


/////////// row2 ///////////

exdcr a3(remainder1[0],Y[0],1'b0,Bout2[0],R2[0]);

genvar j ;
generate
for (j =1;j<=8;j++)begin
exdcr a4(remainder1[j],Y[j],Bout2[j-1],Bout2[j],R2[j]);
end
endgenerate
assign QH[6] = remainder1[9] || (~Bout2[8]) ; 

assign remainder2 = QH[6] ? {R2[8:0],1'b0} : {remainder1[8:0],1'b0} ;

/////////// row3 ////////////////

exdcr a5(remainder2[0],Y[0],1'b0,Bout3[0],R3[0]);

genvar k ;
generate
for (k =1;k<=8;k++)begin
exdcr a6(remainder2[k],Y[k],Bout3[k-1],Bout3[k],R3[k]);
end
endgenerate
assign QH[5] = remainder2[9] || (~Bout3[8]) ; 

assign remainder3 = QH[5] ? {R3[8:0],1'b0} : {remainder2[8:0],1'b0} ;



///////////////// row4 ///////////////////////

exdcr a7(remainder3[0],Y[0],1'b0,Bout4[0],R4[0]);

genvar l ;
generate
for (l =1;l<=8;l++)begin
exdcr a8(remainder3[l],Y[l],Bout4[l-1],Bout4[l],R4[l]);
end
endgenerate
assign QH[4] = remainder3[9] || (~Bout4[8]) ; 

assign remainder4= QH[4] ? {R4[8:0],1'b0} : {remainder3[8:0],1'b0} ;


/////////////////// row5 //////////////////////

exdcr a9(remainder4[0],Y[0],1'b0,Bout5[0],R5[0]);

genvar m ;
generate
for (m =1;m<=8;m++)begin
exdcr a10(remainder4[m],Y[m],Bout5[m-1],Bout5[m],R5[m]);
end
endgenerate
assign QH[3] = remainder4[9] || (~Bout5[8]) ; 

assign remainder5= QH[3] ? {R5[8:0],1'b0} : {remainder4[8:0],1'b0} ;

/////////////////////// row6 ////////////////////////////

exdcr a11(remainder5[0],Y[0],1'b0,Bout6[0],R6[0]);

genvar n ;
generate
for (n =1;n<=8;n++)begin
exdcr a12(remainder5[n],Y[n],Bout6[n-1],Bout6[n],R6[n]);
end
endgenerate
assign QH[2] = remainder5[9] || (~Bout6[8]) ; 

assign remainder6= QH[2] ? {R6[8:0],1'b0} : {remainder5[8:0],1'b0} ;

//////////////////////// row7 ///////////////////////////

exdcr a13(remainder6[0],Y[0],1'b0,Bout7[0],R7[0]);

genvar p ;
generate
for (p =1;p<=8;p++)begin
exdcr a14(remainder6[p],Y[p],Bout7[p-1],Bout7[p],R7[p]);
end
endgenerate
assign QH[1] = remainder6[9] || (~Bout7[8]) ; 

assign remainder7= QH[1] ? {R7[8:0],1'b0} : {remainder6[8:0],1'b0} ;

///////////////////////// row8 ////////////////////

exdcr a15(remainder7[0],Y[0],1'b0,Bout8[0],R8[0]);

genvar r ;
generate
for (r =1;r<=8;r++)begin
exdcr a16(remainder7[r],Y[r],Bout8[r-1],Bout8[r],R8[r]);
end
endgenerate
assign QH[0] = remainder7[9] || (~Bout8[8]) ; 

assign remainder8= QH[0] ? {R8[8:0],1'b0} : {remainder7[8:0],1'b0} ;

////////////////////////////////////

assign RH = remainder8[8:1];

endmodule

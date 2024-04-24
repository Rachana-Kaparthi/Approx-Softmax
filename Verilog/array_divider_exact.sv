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


module array_divider_exact(input [15:0]X,[31:0]Y,output [31:0]RH,[15:0]QH);
wire [31:0]XH; 
wire [31:0]Bout1,Bout2,Bout3,Bout4,Bout5,Bout6,Bout7,Bout8,Bout9,Bout10, Bout11,Bout12,Bout13,Bout14,Bout15,Bout16;
wire [31:0]R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11,R12,R13,R14,R15,R16;
wire [32:0]remainder1,remainder2,remainder3,remainder4,remainder5,remainder6,remainder7,remainder8,remainder9,remainder10,remainder11,remainder12,remainder13,remainder14,remainder15,remainder16;

assign XH = {X,16'b0};
//// row1 ////

exdcr a1(XH[0],Y[0],1'b0,Bout1[0],R1[0]);

genvar i ;
generate
for (i =1;i<=31;i++)begin
exdcr a2(XH[i],Y[i],Bout1[i-1],Bout1[i],R1[i]);
end
endgenerate
assign QH[15] = Bout1[31] ? 0 : 1  ; 

assign remainder1 = QH[15] ? {R1[31:0],1'b0} : {XH[31:0],1'b0} ;


/////////// row2 ///////////

exdcr a3(remainder1[0],Y[0],1'b0,Bout2[0],R2[0]);

genvar j ;
generate
for (j =1;j<=31;j++)begin
exdcr a4(remainder1[j],Y[j],Bout2[j-1],Bout2[j],R2[j]);
end
endgenerate
assign QH[14] = remainder1[32] || (~Bout2[31]) ; 

assign remainder2 = QH[14] ? {R2[31:0],1'b0} : {remainder1[31:0],1'b0} ;

/////////// row3 ////////////////

exdcr a5(remainder2[0],Y[0],1'b0,Bout3[0],R3[0]);

genvar k ;
generate
for (k =1;k<=31;k++)begin
exdcr a6(remainder2[k],Y[k],Bout3[k-1],Bout3[k],R3[k]);
end
endgenerate
assign QH[13] = remainder2[32] || (~Bout3[31]) ; 

assign remainder3 = QH[13] ? {R3[31:0],1'b0} : {remainder2[31:0],1'b0} ;



///////////////// row4 ///////////////////////

exdcr a7(remainder3[0],Y[0],1'b0,Bout4[0],R4[0]);

genvar l ;
generate
for (l =1;l<=31;l++)begin
exdcr a8(remainder3[l],Y[l],Bout4[l-1],Bout4[l],R4[l]);
end
endgenerate
assign QH[12] = remainder3[32] || (~Bout4[31]) ; 

assign remainder4= QH[12] ? {R4[31:0],1'b0} : {remainder3[31:0],1'b0} ;


/////////////////// row5 //////////////////////

exdcr a9(remainder4[0],Y[0],1'b0,Bout5[0],R5[0]);

genvar m ;
generate
for (m =1;m<=31;m++)begin
exdcr a10(remainder4[m],Y[m],Bout5[m-1],Bout5[m],R5[m]);
end
endgenerate
assign QH[11] = remainder4[32] || (~Bout5[31]) ; 

assign remainder5= QH[11] ? {R5[31:0],1'b0} : {remainder4[31:0],1'b0} ;

/////////////////////// row6 ////////////////////////////

exdcr a11(remainder5[0],Y[0],1'b0,Bout6[0],R6[0]);

genvar n ;
generate
for (n =1;n<=31;n++)begin
exdcr a12(remainder5[n],Y[n],Bout6[n-1],Bout6[n],R6[n]);
end
endgenerate
assign QH[10] = remainder5[32] || (~Bout6[31]) ; 

assign remainder6= QH[10] ? {R6[31:0],1'b0} : {remainder5[31:0],1'b0} ;

//////////////////////// row7 ///////////////////////////

exdcr a13(remainder6[0],Y[0],1'b0,Bout7[0],R7[0]);

genvar p ;
generate
for (p =1;p<=31;p++)begin
exdcr a14(remainder6[p],Y[p],Bout7[p-1],Bout7[p],R7[p]);
end
endgenerate
assign QH[9] = remainder6[32] || (~Bout7[31]) ; 

assign remainder7= QH[9] ? {R7[31:0],1'b0} : {remainder6[31:0],1'b0} ;

///////////////////////// row8 ////////////////////

exdcr a15(remainder7[0],Y[0],1'b0,Bout8[0],R8[0]);

genvar r ;
generate
for (r =1;r<=31;r++)begin
exdcr a16(remainder7[r],Y[r],Bout8[r-1],Bout8[r],R8[r]);
end
endgenerate
assign QH[8] = remainder7[32] || (~Bout8[31]) ; 

assign remainder8= QH[8] ? {R8[31:0],1'b0} : {remainder7[31:0],1'b0} ;

////////////////////// row9 //////////////

exdcr a16(remainder8[0],Y[0],1'b0,Bout9[0],R9[0]);

genvar q ;
generate
for (q =1;q<=31;q++)begin
exdcr a16(remainder8[q],Y[q],Bout9[q-1],Bout9[q],R9[q]);
end
endgenerate
assign QH[7] = remainder8[32] || (~Bout9[31]) ; 

assign remainder9= QH[7] ? {R9[31:0],1'b0} : {remainder8[31:0],1'b0} ;


////////////////////// row10 //////////////

exdcr a17(remainder9[0],Y[0],1'b0,Bout10[0],R10[0]);

genvar s ;
generate
for (s =1;s<=31;s++)begin
exdcr a17(remainder9[s],Y[s],Bout10[s-1],Bout10[s],R10[s]);
end
endgenerate
assign QH[6] = remainder9[32] || (~Bout10[31]) ; 

assign remainder10= QH[6] ? {R10[31:0],1'b0} : {remainder9[31:0],1'b0} ;

////////////////////// row11 //////////////

exdcr a18(remainder10[0],Y[0],1'b0,Bout11[0],R11[0]);

genvar t ;
generate
for (t =1;t<=31;t++)begin
exdcr a18(remainder10[t],Y[t],Bout11[t-1],Bout11[t],R11[t]);
end
endgenerate
attign QH[5] = remainder10[32] || (~Bout11[31]) ; 

attign remainder11= QH[5] ? {R11[31:0],1'b0} : {remainder10[31:0],1'b0} ;

////////////////////// row12 //////////////

exdcr a19(remainder11[0],Y[0],1'b0,Bout12[0],R12[0]);

genvar tt ;
generate
for (tt =1;tt<=31;tt++)begin
exdcr a19(remainder11[tt],Y[tt],Bout12[tt-1],Bout12[tt],R12[tt]);
end
endgenerate
assign QH[4] = remainder11[32] || (~Bout12[31]) ; 

assign remainder12= QH[4] ? {R12[31:0],1'b0} : {remainder11[31:0],1'b0} ;

////////////////////// row13 //////////////

exdcr a20(remainder12[0],Y[0],1'b0,Bout13[0],R13[0]);

genvar tp ;
generate
for (tp =1;tp<=31;tp++)begin
exdcr a20(remainder12[tp],Y[tp],Bout13[tp-1],Bout13[tp],R13[tp]);
end
endgenerate
assign QH[3] = remainder12[32] || (~Bout13[31]) ; 

assign remainder13= QH[3] ? {R13[31:0],1'b0} : {remainder12[31:0],1'b0} ;

////////////////////// row14 //////////////

exdcr a21(remainder13[0],Y[0],1'b0,Bout14[0],R14[0]);

genvar tr ;
generate
for (tr =1;tr<=31;tr++)begin
exdcr a21(remainder13[tr],Y[tr],Bout14[tr-1],Bout14[tr],R14[tr]);
end
endgenerate
assign QH[2] = remainder13[32] || (~Bout14[31]) ; 

assign remainder14= QH[2] ? {R14[31:0],1'b0} : {remainder13[31:0],1'b0} ;

////////////////////// row15 //////////////

exdcr a22(remainder14[0],Y[0],1'b0,Bout15[0],R15[0]);

genvar tq ;
generate
for (tq =1;tq<=31;tq++)begin
exdcr a22(remainder14[tq],Y[tq],Bout15[tq-1],Bout15[tq],R15[tq]);
end
endgenerate
assign QH[1] = remainder14[32] || (~Bout15[31]) ; 

assign remainder15= QH[1] ? {R15[31:0],1'b0} : {remainder14[31:0],1'b0} ;

////////////////////// row16 //////////////

exdcr a23(remainder15[0],Y[0],1'b0,Bout16[0],R16[0]);

genvar te ;
generate
for (te =1;te<=31;te++)begin
exdcr a23(remainder15[te],Y[te],Bout16[te-1],Bout16[te],R16[te]);
end
endgenerate
assign QH[0] = remainder15[32] || (~Bout16[31]) ; 

//assign remainder14= QH[0] ? {R14[31:0],1'b0} : {remainder13[31:0],1'b0} ;


assign RH = remainder15[32:1];

endmodule

//`include "compressors_rachana.v"


module FA(input [2:0]p, output [2:1]w   );  // w[2] = carry ;  w[1] =sum
   xor sum(w[1], p[2],p[1],p[0]);   // w1 is sum
   wire ab,bc,ca;
   and a1(ab,p[2],p[1]);
   and a2(bc,p[1],p[0]);
   and a3(ca,p[0],p[2]);
   or carry(w[2], ab,bc,ca);        //w2 is carry
endmodule

module HA(input [1:0]p, output [2:1]w);
    xor sum(w[1],p[0],p[1]);
    and carry(w[2],p[0],p[1]);
endmodule

module exact_compressor_4_2(
    input [3:0]p,
    input cin,
    output sum, 
    output carry,
    output cout);
    wire w1;
    
    FA fa1 (.p(p[3:1])       ,.w({cout,w1}));   //[1](w1),.w[2](cout));
    FA fa2 (.p({p[0],w1,cin}),.w({carry,sum})); //[1](sum),.w[2](carry));
endmodule


module Positive_Compressor_4_2(sum,carry,a,b,c,d);
    input a,b,c,d;
    output sum,carry;
    wire w1,w2,t1,t2;
    /////   sum = a+b+c+d   /////
    or u1 (sum,a,b,c,d);
    /////   carry = ab+bc+bd+cd     /////
    /////   carry = (a+c)b+(b+c)d   /////
    or u2 (w1,a,c);
    or u3 (w2,b,c);
    and u4 (t1,w1,b);
    and u5 (t2,w2,d);
    or u6 (carry,t1,t2);
endmodule

module exact_compressor_5_2(
    input [4:0]p,
    input cin1,
    input cin2,
    output sum, 
    output carry,
    output cout1,
    output cout2);
    wire s1,s2;
    
    FA fa1 (.p(p[4:2]),         .w({cout1,s1}) );
    FA fa2 (.p({p[1],s1,cin1}), .w({cout2,s2}) );
    FA fa3 (.p({p[0],s2,cin2}), .w({carry,sum}) );
        
endmodule

module single_row_reduction_firststage_exact#(parameter Bitwidth=16)(

    input [(Bitwidth/2)-1:0]pp_row,
    input cin1,cin2,
    output [(Bitwidth/4)-1:0]pp_second_stage,
    output cout1,cout2
    );

exact_compressor_5_2 exact52(.p(pp_row[(Bitwidth/2)-1:(Bitwidth/2)-5]),.cin1(cin1),.cin2(cin2),.sum(pp_second_stage[3]),.carry(pp_second_stage[2]),.cout1(cout1),.cout2(cout2));
FA exact32(.p(pp_row[2:0]),.w(pp_second_stage[1:0]));

endmodule

module single_row_reduction_firststage_positive#(parameter Bitwidth=16)(

    input [(Bitwidth/2)-1:0]pp_row,
   // input cin1,cin2,
    output [(Bitwidth/4)-1:0]pp_second_stage
  //  output cout1,cout2
    );
Positive_Compressor_4_2 pos42_1(.sum(pp_second_stage[3]),.carry(pp_second_stage[2]),.a(pp_row[Bitwidth/2-1]),.b(pp_row[Bitwidth/2-2]),.c(pp_row[Bitwidth/2-3]),.d(pp_row[Bitwidth/2-4]));
 //exact_compressor_5_2 exact52(.p(pp_row[Bitwidth-1:Bitwidth-5]),.cin1(cin1),.cin2(cin2),.sum(pp_second_stage[3]),.carry(pp_second_stage[2]),.cout1(cout1),.cout2(cout2));

Positive_Compressor_4_2 pos42_2(.sum(pp_second_stage[0]),.carry(pp_second_stage[1]),.a(pp_row[Bitwidth/2-5]),.b(pp_row[Bitwidth/2-6]),.c(pp_row[Bitwidth/2-7]),.d(pp_row[Bitwidth/2-8]));

//Positive_Compressor_5_2 pos52(.sum(pp_second_stage[3]),.carry(pp_second_stage[2]),.e(pp_row[Bitwidth-1]),.d(pp_row[Bitwidth-2]),.c(pp_row[Bitwidth-3]),.b(pp_row[Bitwidth-4]),.a(pp_row[Bitwidth-5]));
//FA exact32(.p(pp_row[2:0]),.w(pp_second_stage[1:0]));

endmodule

// **************************************Booth reduction tree***********************************

module pp_reduction_booth#(parameter Bitwidth=16)(

    input [2*Bitwidth-1:0]pp[0:(Bitwidth/2)-1],
    output [2*Bitwidth-1:0] res
//    output [2*Bitwidth-1:0]pp1,pp2
    );
    
    wire [2*Bitwidth:0]cin1,cin2;
    wire [2*Bitwidth-1:0]pp_1st_stage_op[(Bitwidth/4)-1:0];
    reg [2*Bitwidth-1:0]pp1,pp2;
    
    assign cin1[Bitwidth:0]=0;
    assign cin2[Bitwidth:0]=0;
    
    //************ First Stage **************//
     
    genvar i;
    
    generate
        for(i=0;i<2*Bitwidth;i++) begin
            if (i>=Bitwidth) 
                begin
                    single_row_reduction_firststage_exact#(.Bitwidth(Bitwidth)) firststage (.pp_row({pp[0][i],pp[1][i],pp[2][i],pp[3][i],pp[4][i],pp[5][i],pp[6][i],pp[7][i]}),.cin1(cin1[i]),.cin2(cin2[i]),.pp_second_stage({pp_1st_stage_op[0][i],pp_1st_stage_op[1][i],pp_1st_stage_op[2][i],pp_1st_stage_op[3][i]}),.cout1(cin1[i+1]),.cout2(cin2[i+1]));
                end
            else 
                begin
                    single_row_reduction_firststage_positive#(.Bitwidth(Bitwidth)) firststage (.pp_row({pp[0][i],pp[1][i],pp[2][i],pp[3][i],pp[4][i],pp[5][i],pp[6][i],pp[7][i]}),.pp_second_stage({pp_1st_stage_op[0][i],pp_1st_stage_op[1][i],pp_1st_stage_op[2][i],pp_1st_stage_op[3][i]}));
                end
        end
    endgenerate
    
    //************ Second Stage **************//
   wire [2*Bitwidth-1:0]pp_2nd_stage_ip[Bitwidth/4-1:0];
   wire [2*Bitwidth:0]cin21;
    
    assign pp_2nd_stage_ip[Bitwidth/4-1]=pp_1st_stage_op[Bitwidth/4-1];
    assign pp_2nd_stage_ip[Bitwidth/4-2]=pp_1st_stage_op[Bitwidth/4-2]<<1;
    assign pp_2nd_stage_ip[Bitwidth/4-3]=pp_1st_stage_op[Bitwidth/4-3]<<1;
    assign pp_2nd_stage_ip[Bitwidth/4-4]=pp_1st_stage_op[Bitwidth/4-4];
    assign cin21[Bitwidth:0]=0;
   // assign pp2[0]=0;
    
    genvar j;
    
    generate
        for(j=0;j<2*Bitwidth;j++) begin
           //  exact_compressor_4_2 secondstage(.p({pp_2nd_stage_ip[0][j],pp_2nd_stage_ip[1][j],pp_2nd_stage_ip[2][j],pp_2nd_stage_ip[3][j]}),.cin(cin21[j]),.sum(pp1[j]),.carry(pp2[j]),.cout(cin21[j+1]));
            if (j>=Bitwidth) 
                begin
                    exact_compressor_4_2 secondstage(.p({pp_2nd_stage_ip[0][j],pp_2nd_stage_ip[1][j],pp_2nd_stage_ip[2][j],pp_2nd_stage_ip[3][j]}),.cin(cin21[j]),.sum(pp1[j]),.carry(pp2[j]),.cout(cin21[j+1]));
                end
            else 
                begin
//                    Positive_Compressor_4_2 secondstage(.sum(pp1[j]),.carry(pp2[j]),.a(pp_2nd_stage_ip[0][j]),.b(pp_2nd_stage_ip[1][j]),.c(pp_2nd_stage_ip[2][j]),.d(pp_2nd_stage_ip[3][j]));
                    Positive_Compressor_4_2 secondstage(.sum(pp1[j]),.carry(pp2[j]),.a(pp_2nd_stage_ip[3][j]),.b(pp_2nd_stage_ip[2][j]),.c(pp_2nd_stage_ip[1][j]),.d(pp_2nd_stage_ip[0][j]));
                end   
            
        end
    endgenerate
    
//    wire [2*Bitwidth-1:0]res;
    assign res=pp1+(pp2<<1);
endmodule

def array_divider(num,den):
    num += "0" * 24
    Bout = [[""] *  32 for _ in range(8)]
    R = [[""]  * 32 for _ in range(8)]
    Rem = [["" ] * 32 for _ in range(8)]
    QH = [""] * 8
    
    # num += "0"*24
    # Bout = [""] * 8
    # R = [""] * 8
    # Rem = [""]*8
    # QH = ""
    
    #Row-1 
    Bout[0][31],R[0][31]=exdcr(num[31],den[31],'0')
    for i in range(30,-1,-1) :
        Bout[0][i],R[0][i]=exdcr(num[i],den[i],Bout[0][i+1])
    QH[0] = '0' if Bout[0][0] =='1' else '1'
    Rem[0] = ''.join(R[0])+'0' if QH[0] == '1' else num[0:]+'0'
    # print(Rem[0])
    
    #Row-2
    # [Bout[1][31],R[1][31]]=exdcr(Rem[0][32],den[31],'0')
    # for i in range(30,-1,-1) :
    #     [Bout[1][i],R[1][i]]=exdcr(Rem[0][i+1],den[i],Bout[1][i+1])
    # QH[1] = str((~int(Bout[1][0],2)) | int(Rem[0][0],2))
    # Rem[1] =  R[1]+'0' if QH[1] == '1' else Rem[0][1:]+'0'
    
    for i in range(1,8):
        # print(f"#Row-{i+1}")
        Bout[i][31],R[i][31]=exdcr(Rem[i-1][32],den[31],'0')
        for j in range(30,-1,-1) :
            Bout[i][j],R[i][j]=exdcr(Rem[i-1][j+1],den[j],Bout[i][j+1])

        if (int(Bout[i][0],2)) : 
            neg_Bout = 0
        else :
            neg_Bout = 1
        QH[i] = str(neg_Bout | int(Rem[i - 1][0],2))            
        # QH[i] = str((~(int(Bout[i][0],2))) or int(Rem[i-1][0],2))
        Rem[i] =  ''.join(R[i])+'0' if QH[i] == '1' else Rem[i-1][1:]+'0'        
        
    QH1 = ''.join(QH)

    RH = Rem[7][:-1]
    return[RH,QH1]

    
def exdcr(x,y,bin,):
    # print(f"i={i},j={j}")
    X= int(x,2)
    Y= int(y,2)
    Bin = int(bin,2)
    R = X ^ Y ^ Bin;
    bout = (~(X ^ Y) & Bin) or (~X&Y)
    return [str(bout),str(R)]

# x="0101011"
# [bout,R]=exdcr(x[1],x[2],x[3])
# print([bout,R])

# a='10000110'
# b = '10110100101010111001001010101010'
        

# def array_divider(num, den):
#     num += "0" * 24
#     Bout = [["" for _ in range(32)] for _ in range(8)]
#     R = [["" for _ in range(32)] for _ in range(8)]
#     Rem = [["" for _ in range(32)] for _ in range(8)]
#     QH = [""] * 8

#     # Row-1
#     Bout[0][31], R[0][31] = exdcr(num[31], den[31], '0')
#     for i in range(30, -1, -1):
#         Bout[0][i], R[0][i] = exdcr(num[i], den[i], Bout[0][i + 1])
#     QH[0] = '0' if Bout[0][0] == '1' else '1'
#     Rem[0] = R[0] + '0' if QH[0] == '1' else num + '0'

#     for i in range(1, 8):
#         print(f"#Row-{i + 1}")
#         Bout[i][31], R[i][31] = exdcr(Rem[i - 1][32], den[31], '0')
#         for j in range(31, 0, -1):
#             Bout[i][j], R[i][j] = exdcr(Rem[i - 1][j], den[j - 1], Bout[i - 1][j])
#         print(Bout[i][0])
#         # if (int(Bout[i][0],2)) : neg_Bout = 0
#         # else :
#         neg_Bout = 1
#         QH[i] = (neg_Bout | int(Rem[i - 1][0],2))
#         Rem[i] = R[i] + '0' if QH[i] == '1' else Rem[i - 1][1:] + '0'

#     RH = Rem[7][:-1]
#     return [RH, QH]


# def exdcr(x, y, bin):
#     X = int(x)
#     Y = int(y)
#     Bin = int(bin)
#     R = X ^ Y ^ Bin
#     bout = (~(X ^ Y) & Bin) | (~X & Y)
#     return [str(bout), str(R)]


# a = '10000110'
# b = '10110100101010111001001010101010'

# [rem,ques] = array_divider(a, b)
# print(rem,ques)

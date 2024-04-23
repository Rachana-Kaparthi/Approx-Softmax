from array_divider import *
from exp import *
from log_divider import *
from LOD import *
from denominator import *
wid_int = 5
wid_MSB = 4
wid_MSB2 = 4
wid_LSB = 8
size = 5

def right_shift_string(string, shift_amount):
   
# Right shift by 4 bits
    shifted_string = '0' * shift_amount +string    
    return shifted_string
def top_module(x,n):
    # exp = [[""] *  21 for _ in range(5)]
    exp = [""]*n
    exp_1 = [""]*n
    rem = [""]*n
    quo_h = [""]*n
    quo_l = [""]*n
    quo_append = [""]*n
    lod_num = [""]*n
    softmax_value = [""]*n
    for i in range(n) :
        exp[i] = softmax(x[i])
        
    print("exp_1",exp)
    #exp = [sublist[0] for sublist in exp_1]
    print("exponent_top",exp)
    [pos_den,Den] = denominator(exp,n)
    lod_den = leading_one_detector32(Den)
    print("denominator_top", pos_den,Den)
    for i in range(n) :
        [rem[i],quo_h[i]] = array_divider(exp[i][5:13],Den)
        lod_num[i] = leading_one_detector64(rem[i]+exp[i][13:]+'0'*24)
        # print("lod_num",lod_num[i])
        quo_l[i] = log_divider(exp[i][0:5],Den[0:5],rem[i]+ exp[i][13:]+'0'*24,Den,lod_num[i],lod_den)
        quo_append[i] = (-16-int(pos_den,2)+int(exp[i][0:5],2)) if (int(exp[i][0:5] ,2)< 8) else (-8-int(pos_den,2))
        # print("quo_append", quo_append[i])
        softmax_value[i] = '1'+right_shift_string((quo_h[i] + quo_l[i]),abs(quo_append[i]))
        
    print("softmax values :")
    for i in range(n):
        print(softmax_value[i])
    return softmax_value

x = ["1010111011011010","1000110011011011","0010111011010010","0010011011111010","0100001011011010"]
softmax_value = top_module(x,5)
print(softmax_value)
    

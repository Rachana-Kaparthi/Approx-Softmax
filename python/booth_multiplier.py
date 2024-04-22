# from booth_reduction import*
# from reduction_tree1 import*
# from reduction_tree import*
def FA(a,b,c):
    sum = a^b^c
    carry = (a & b) | (b & c) | (c & a)

    return [carry,sum]
def HA(a,b):
    sum = a^b
    carry = a&b

    return [sum,carry]

def exact_42(a,b,c,d,cin):
    [cout,sum1]=FA(d,c,b)
    [carry,sum]=FA(a,cin,sum1)

    return [sum,carry,cout]

def exact_52(a,b,c,d,e,cin1,cin2):
    [cout1,sum1]=FA(d,c,e)
    [cout2,sum2]=FA(b,cin1,sum1)
    [carry,sum]=FA(a,cin2,sum2)

    return [sum,carry,cout1,cout2]

def mulby2(strrevy):
    a = strrevy
    a = a.strip()
    integer_value = int(a, 2)
    multiplied_value = integer_value * 2
    binary_string = bin(multiplied_value)[2:] 
    binary_string = binary_string.zfill(16)
    # print(binary_string)
    return binary_string

def twos_complement(binary_string):
    # Convert binary string to integer
    integer_value = int(binary_string, 2)
    # Calculate two's complement
    twos_complement_value = -integer_value
    # Convert the two's complement value back to binary string
    result = bin(twos_complement_value & 0b1111111111111111)[2:].zfill(16)
    return result

def exact_first_stage_single_row_reduction(pp_row,cin1,cin2):
    [sum52,carry52,cout1,cout2]=exact_52(pp_row[3],pp_row[4],pp_row[5],pp_row[6],pp_row[7],cin1,cin2)
    [carry32,sum32]=FA(pp_row[0],pp_row[1],pp_row[2])

    return [sum52,carry52,carry32,sum32,cout1,cout2]

def pp_reduction_exact(pp):

    pp1 = [0 for j in range(32)]
    pp2 = [0 for j in range(33)]
    
    # ********* first stage *********#
    
    cin1 = [0 for j in range(31)]
    cin2 = [0 for j in range(31)]
    pp_1st_stage = [[0 for i in range(32)] for j in range(4)]

    for i in range(30):
        [pp_1st_stage[3][i],pp_1st_stage[2][i+1],pp_1st_stage[1][i+1],pp_1st_stage[0][i],cin1[i+1],cin2[i+1]]=exact_first_stage_single_row_reduction([pp[0][i],pp[1][i],pp[2][i],pp[3][i],pp[4][i],pp[5][i],pp[6][i],pp[7][i]],cin1[i],cin2[i])
    [pp_1st_stage[2][30],pp_1st_stage[2][31] ] = HA(pp_1st_stage[2][30],cin1[i+1])
    [pp_1st_stage[1][30],pp_1st_stage[1][31] ] = HA(pp_1st_stage[1][30],cin2[i+1])

    # print("\n")
    # for i in range(4):
    #     print(pp_1st_stage[i])
 
    # ********* second stage *********#
   
    cin21 = [0 for j in range(33)]

    for i in range(32):
        [pp1[i],pp2[i+1],cin21[i+1]]=exact_42(pp_1st_stage[0][i],pp_1st_stage[1][i],pp_1st_stage[2][i],pp_1st_stage[3][i],cin21[i])

    # print("\n")
    # [dpp1,dpp2,dppres]=B2Dconversion(pp1,pp2)
    # print(pp1)
    # print(pp2)
    # print(dppres)

    return [pp1,pp2]


# # Example usage
# a = '10110100'
# b = twos_complement(a)
# print("Two's complement of 2 * ", a, ": ", b)

def booth_multiplier(x,y,n) :

    pp1 = [[0 for i in range(n)] for j in range(n//2)]
    pp =  [[0 for i in range(2*n)] for j in range(n//2)]

    # strx = str('{0:016b}'.format(x,'b'))
    # stry = str('{0:016b}'.format(y,'b'))
    strx = x
    stry = y
    # print("stry",stry)
    strx += '0'
    # print("string_x post appending zero is ",strx)

    for i in range(n//2):
        window = strx[-3:]
        strx = strx[:-2]
        # print(f"window[{i}] = {window}")
        # print("strx = ",strx)
        if window == '000' or window == '111' :
            pp1[i] = [0 for j in range(16)]
            # print(f"pp1[{i}] ={pp1[i]}")
        elif window == '001' or window == '010':
            pp1[i] = [int(bit) for bit in list(stry)]
            # print(f"pp1[{i}] ={pp1[i]}")
        elif window == '011' :
            pp1[i] =  [int(bit) for bit in list(mulby2(stry))]
            # print(f"pp1[{i}] ={pp1[i]}")
        elif window == '100' :
            pp1_tmp = mulby2(stry)
            pp1[i] = [int(bit) for bit in list(twos_complement(pp1_tmp))]
            # print(f"pp1[{i}] ={pp1[i]}")
        elif window == '101' or '110' :
            pp1[i] = [int(bit) for bit in list(twos_complement(stry))]
            # print(f"pp1[{i}] ={pp1[i]}")
    # for i in range(n//2) :
    #     print(pp1[i])

    for i in range(n//2):
        
        for j in range(32):
            if j>=(2*n-2*i):
                pp[i][j] = 0
            elif j<(2*n-2*i) and j >= (2*n-2*i-16):
                    pp[i][j] = pp1[i][j-(2*n-2*i-16)]
            elif j in range(0,2*n-2*i-16):
                pp[i][j] = pp1[i][0]
            
                    
        # elif i==1:
        #     for j in range(31):
        #         if j>=(2*n-2):
        #             pp[i][j] = 0
        #         elif j<(2*n-2) or j >= (2*n-18):
        #             pp[i][j] = pp1[i][j-14]
        #         elif j < (2*n-18) or j >= 0:
        #             pp[i][j] = pp1[i][n//2 - 1]
    
    reversed_lists = [lst[::-1] for lst in pp]

    # for i in range(n//2) :
    #     print(reversed_lists[i])

    [pp3,pp4] = pp_reduction_exact(reversed_lists)
    res=[0 for i in range(32)]
    carry=[0 for i in range(33)]

    for i in range(32):
        [carry[i+1],res[i]]=FA(pp3[i],pp4[i],carry[i])
    # print(res)
    # print(carry)
    # binary_string_1 = ''.join(map(str, res[::-1]))
    # print(binary_string_1)
    # print(len(binary_string_1))

    result = [0 for i in range(33)]
    result[:32] = res
    result[32] = carry[32]
    # print("result",result)
    # print(result)

    # print(carry.reverse())
    # print(res.reverse())

    # for i in range(n//2) :
    #     print(reversed_lists[i])
    binary_string = ''.join(map(str, result[::-1]))
    # print(binary_string)
    # print(len(binary_string))
    str_send = binary_string[:16]
    # print(str_send,len(str_send))

    return str_send



n = 16
x = "1001010001101001"
y = "1010111011110100"
pp2 = booth_multiplier(x,y,n)
print("pp2",pp2)
# print("2's complement")
# print(twos_complement('00000110'))

# for i in range(n//2) :
#     print(pp2[i])
# print('\n')


# reversed_lists = [lst[::-1] for lst in pp2]

# for i in range(n//2) :
#     print(reversed_lists[i])

# [pp3,pp4] = pp_reduction_exact(reversed_lists)
# res=[0 for i in range(32)]
# carry=[0 for i in range(33)]

# for i in range(32):
#     [carry[i+1],res[i]]=FA(pp3[i],pp4[i],carry[i])
# print(res)
# print(carry)
# # binary_string_1 = ''.join(map(str, res[::-1]))
# # print(binary_string_1)
# # print(len(binary_string_1))

# result = [0 for i in range(33)]
# result[:32] = res
# result[32] = carry[32]
# print(result)

# # print(carry.reverse())
# # print(res.reverse())

# # for i in range(n//2) :
# #     print(reversed_lists[i])
# binary_string = ''.join(map(str, result[::-1]))
# print(binary_string)
# print(len(binary_string))
# str_send = binary_string[:16]
# print(str_send,len(str_send))

# # binary_string = "0" +binary_string[1:]
# # index = binary_string.find('1')
# # print(index)  
# # result_1 = binary_string[index:]+'0'*(index)
# # print(result_1,len(result_1))
# # result = result_1[0:16]






   
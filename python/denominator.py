def right_shift_string(string, shift_amount):
   
# Right shift by 4 bits
    shifted_string = '0' * shift_amount +string

# Fill remaining places with 0 to make it a 30-bit string
    shifted_string = shifted_string + '0' * (30 - len(shifted_string))
    return shifted_string


def binary_to_decimal_den(binary_data):
    # Split the binary string into integer and fractional parts
    print("Binary :",binary_data)
    binary_data=str(binary_data)
    integer_part = int(binary_data[:15], 2)
    fractional_part = int(binary_data[15:], 2)

    # Calculate the decimal value
    decimal_value = integer_part + fractional_part / (2 ** 15)

    return decimal_value


def fractional_to_binary(fractional_number):
    # Separate the integer and fractional parts
    integer_part = int(fractional_number)
    fractional_part = fractional_number - integer_part

    # Convert the integer part to binary
    integer_binary = bin(integer_part)[2:]

    # Convert the fractional part to binary
    fractional_binary = ""
    while len(integer_binary) + len(fractional_binary) < 32:
        fractional_part *= 2
        bit = int(fractional_part)
        fractional_binary += str(bit)
        fractional_part -= bit

    # Pad with zeros if needed
    remaining_bits = 32 - len(integer_binary) - len(fractional_binary)
    fractional_binary += '0' * remaining_bits

    # Combine integer and fractional parts
    binary_equivalent = integer_binary + fractional_binary

    # Find the position of the decimal point
    decimal_position = len(integer_binary)

    decimal_position_2=format(decimal_position, '05b')
    
    return binary_equivalent, decimal_position_2



def denominator(exp,N):


        
    # Find the highest exponent among exp1, exp2, exp3, exp4, exp5
    highest = max(int(element[:5], 2) for element in exp)
    print("Highest:",highest)
    exp_temp = [""]*N
    exp_int=[""]*N
    # Adjust exponents based on the highest exponent
    for i in  range (N):
        shift=15-int(exp[i][:5],2)
        print(shift)
        exp_temp[i] = right_shift_string(exp[i][5:],shift) if ((highest > int(exp[i][0:5], 2))) else (15-int(exp[i][0:5], 2))*'0'+exp[i][5:]+(int(exp[i][0:5],2)-1)*'0'
        exp_int[i]=binary_to_decimal_den(exp_temp[i])
        
    den = sum(float(x) for x in exp_int)

    Den,pos=fractional_to_binary(den)

    print("denominator",str(pos),Den)


    return str(pos),Den



# exp = [
#     '11110100000000111000',
#     '01101000000111000000',
#     '10100100001111111100',
#     '00100111111111000000',
#     '00010000000001111100'
# ]
# pos,Den = denominator(exp,5)
# print("pos,Den:",pos, Den)

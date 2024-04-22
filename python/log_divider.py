def binary_to_decimal(binary_data):
    # Split the binary string into integer and fractional parts
    integer_part = int(binary_data[:1], 2)
    fractional_part = int(binary_data[1:], 2)

    # Calculate the decimal value
    decimal_value = integer_part + fractional_part / (2 ** (len(binary_data)-1))

    return decimal_value


def fractional_to_binary(fractional_number):
    # Separate the integer and fractional parts
    integer_part = int(fractional_number)
    fractional_part = fractional_number - integer_part

    # Convert the integer part to binary
    integer_binary = bin(integer_part)[2:]

    # Convert the fractional part to binary
    fractional_binary = ""
    while len(integer_binary) + len(fractional_binary) < 8:
        fractional_part *= 2
        bit = int(fractional_part)
        fractional_binary += str(bit)
        fractional_part -= bit

    # Pad with zeros if needed
    remaining_bits = 8 - len(integer_binary) - len(fractional_binary)
    fractional_binary += '0' * remaining_bits

    # Combine integer and fractional parts
    binary_equivalent = integer_binary + fractional_binary

    # Find the position of the decimal point
    
    return binary_equivalent




def log_divider(pos_nu, pos_de, num, den, LOD_nu, LOD_de):
    # Convert binary strings to integers
    pos_nu = int(pos_nu, 2)
    pos_de = int(pos_de, 2)
    num = int(num, 2)
    den = int(den, 2)
    LOD_nu = int(LOD_nu, 2)
    LOD_de = int(LOD_de, 2)
    
    # Calculate pos_n
    pos_n = pos_nu - 8
    print("pos_n:",pos_n)
    
    # Calculate LOD_n and LOD_d
    LOD_n = 64 - LOD_nu
    LOD_d = 32 - LOD_de
    # print("LOD_n:",LOD_n)
    # print("LOD_d:",LOD_d)
    # Calculate s1 and s2
    s1 = pos_n + (32 - LOD_n) if pos_nu > 8 else (64 - LOD_n)
    s2 = pos_de - LOD_d
    # print("s1:",s1)
    # print("s2:",s2)

    
    # Calculate num_temp and den_temp
    num_temp = num << (LOD_n - 1)
    den_temp = den << (LOD_d - 1)
    # print("num_temp",bin(num_temp)[2:])
    # print("den_temp",bin(den_temp)[2:])
    
    # # Extract k1 and k2
    # k1 = (num_temp >> 32) & ((1 << 32) - 1)
    # k2 = den_temp & ((1 << 32) - 1)
    # print("k1:",k1)
    # print("k2:",k2)
    # Calculate quo_1 and quo_2 with 33 bits
    # quo_1 = [0] * 33
    # quo_2 = [0] * 33

    quo_1 = s1-s2
    quo_2_int= (binary_to_decimal(str(bin(num_temp)[2:]))-binary_to_decimal(str(bin(den_temp)[2:])))

    quo_temp = 2*quo_1 * (1+quo_2_int) if quo_2_int>0 else 2*(quo_1-1) * (2+quo_2_int)

    quo_low = fractional_to_binary(quo_temp)

    # print("quo_1",quo_1)
    # print("quo_2",quo_2_int)
    # for i in range(32):
    #     quo_1[i] = (s1 >> i) & 1
    #     quo_2[i] = (s2 >> i) & 1
    
    # Calculate quo_temp with maintaining bit-vector width
    # quo_temp = [0] * 33
    # carry = 0
    # for i in range(32):
    #     quo_temp[i] = (quo_1[i] + quo_2[i] + carry) % 2
    #     carry = (quo_1[i] + quo_2[i] + carry) // 2
    
    # # Convert quo_temp to an integer
    # quo_temp_int = sum(bit * (2 ** (32 - i)) for i, bit in enumerate(quo_temp))
    # print("quo_temp",quo_temp)
    # # Calculate quo_low
    # if quo_temp_int > 7:
    #     quo_low = 128
    # else:
    #     quo_low = 1 << quo_temp_int
    
    # # Convert quo_low to binary string
    # quo_low_bin = bin(quo_low)[2:]
    
    # # Pad with zeros to ensure 8 bits
    # quo_low_bin = quo_low_bin.zfill(8)
    
    return quo_low[:8]
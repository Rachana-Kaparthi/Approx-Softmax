from top_module import*
def real_to_binary(real_number):
    # Clamp real_number within the range [-10, 10]
    real_number = max(-10, min(10, real_number))
    
    # Convert real_number to binary string
    
    sign_bit = '1' if real_number < 0 else '0'  # Set sign bit to 1 for negative numbers
    integer_temp = bin(int(abs(real_number)))[2:]  # Convert integer part to binary with 4 bits
    integer_part = integer_temp.zfill(4)
    length = len(str(integer_temp))

    # Convert fractional part to binary with 11 bits
    fractional_part = bin(int(abs(real_number) * (2 ** 11)))[2+length:].zfill(11)

    # Combine sign bit, integer part, and fractional part to form the 16-bit binary string
    binary_string = sign_bit + integer_part + fractional_part

    return binary_string

def top(real_numbers):
    num_rows = len(real_numbers)
    num_columns = len(real_numbers[0]) if num_rows > 0 else 0
    binary = [[""] * num_columns for _ in range(num_rows)]    
    result = [[""] * num_columns for _ in range(num_rows)]
    # print(binary)
    for i in range(num_rows):
        for j in range(num_columns):
            binary[i][j] = real_to_binary(real_numbers[i][j])
    for i in range(num_rows):        
        result[i] = top_module(binary[i],num_columns)
    print(result)

    return result

real_numbers = [
    [-10, -5.565, 0, 3.14159, 1.75, 8.54],
    [5.98, -3.34, -5.565, 0, 3.14159, 1.75]
]
binary_representations = top(real_numbers)
# print(binary_representations)
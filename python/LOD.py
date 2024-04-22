def leading_one_detector64(binary_data):
    # Find the index of the first occurrence of '1'
    leading_one_position = 63 - (binary_data.find('1'))
    format(leading_one_position, '06b')
    # Return the position of the leading one
    return format(leading_one_position, '06b')

# # Example usage:
# binary_input = "0000100000000000000000000000000000000000000000000000000000001001"
# result = leading_one_detector64(binary_input)
# print("Position of leading one:", result)


def leading_one_detector32(binary_data):
    # Find the index of the first occurrence of '1'
    leading_one_position = 31 - (binary_data.find('1'))
    
    # Return the position of the leading one
    return format(leading_one_position, '05b')

# Example usage:
# binary_input = "00001000000000000000000000001001"
# result = leading_one_detector32(binary_input)
# print("Position of leading one:", result)



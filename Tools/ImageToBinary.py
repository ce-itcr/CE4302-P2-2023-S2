from PIL import Image
import numpy as np

def image_to_binary(image_path):
    """
    Convert an image to a binary representation.

    Args:
    image_path (str): The path to the image file.

    Returns:
    list: A list of binary strings, each representing a pixel in the image.
    """

    with Image.open(image_path) as img:

        img_gray = img.convert("L")
        img_array = np.array(img_gray)
        flat_array = img_array.flatten()
        binary_pixels = [format(pixel, '064b') for pixel in flat_array]

        return binary_pixels

import os

# Obtener la ruta del archivo .py actual
script_path = os.path.abspath(__file__)

# Obtener el directorio donde reside el archivo .py
script_directory = os.path.dirname(script_path)
example_image_path = os.path.join(script_directory, "..", "Images", "VectorImage.png")

binary_pixels = image_to_binary(example_image_path)
# binary_pixels[:10]  # Displaying the first 10 binary pixels for demonstration purposes


text_file_path = os.path.join(script_directory, "..", "ImagesTxt", "BN_Image_Test101888.txt")

# text_file_path = script_directory + '../ImagesTxt/BN_Image_Test.txt'
breakPoint = 101888
with open(text_file_path, 'w') as file:
    count = 0
    for binary_pixel in binary_pixels:
        if count <=  breakPoint:
            file.write(binary_pixel + '\n')
            count+=1
        else:
            break

# script_directory = os.path.dirname(os.path.abspath(__file__))
# pixels_per_file = 10240
# file_count = 0
# count = 0

# file_name = f"BN_Image_Test{file_count}.txt"
# text_file_path = os.path.join(script_directory, "..", "ImagesTxt", file_name)
# file = open(text_file_path, 'w')

# for binary_pixel in binary_pixels:
#     if count > 0 and count % pixels_per_file == 0:
#         file.close()  # Close the current file
#         file_count += 1
#         file_name = f"BN_Image_Test{file_count}.txt"
#         text_file_path = os.path.join(script_directory, "..", "ImagesTxt", file_name)
#         file = open(text_file_path, 'w')

#     file.write(binary_pixel + '\n')
#     count += 1

# file.close()

# lines_to_prepend = [
#     "// instance=/testbench/DUT/tess/dmem/RAM",
#     "// format=bin addressradix=h dataradix=b version=1.0 wordsperline=1 noaddress"
# ]

# with open(text_file_path, 'r') as file:
#     current_contents = file.readlines()

# with open(text_file_path, 'w') as file:
#     for line in lines_to_prepend:
#         file.write(line + '\n')
#     file.writelines(current_contents)

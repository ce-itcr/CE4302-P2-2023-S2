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
        binary_pixels = [format(pixel, '08b') for pixel in flat_array]

        return binary_pixels

example_image_path = "../Images/VectorImage.jpg" 
binary_pixels = image_to_binary(example_image_path)
# binary_pixels[:10]  # Displaying the first 10 binary pixels for demonstration purposes

text_file_path = '../ImagesTxt/BN_Image_Test.txt'

with open(text_file_path, 'w') as file:
    for binary_pixel in binary_pixels:
        file.write(binary_pixel + '\n')

lines_to_prepend = [
    "// instance=/testbench/DUT/tess/dmem/RAM",
    "// format=bin addressradix=h dataradix=b version=1.0 wordsperline=1 noaddress"
]

with open(text_file_path, 'r') as file:
    current_contents = file.readlines()

with open(text_file_path, 'w') as file:
    for line in lines_to_prepend:
        file.write(line + '\n')
    file.writelines(current_contents)

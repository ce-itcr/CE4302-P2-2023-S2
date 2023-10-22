def create_image_file(file_name, n, m):
    '''
    Function to create a text file containing 8-bit values representing pixels.
    '''
    import random
    with open(file_name, 'w') as file:
        for _ in range(n):
            row = [str(255) for _ in range(m)]  # Generate random 8-bit decimal values
            line = ",".join(row) + "\n"  # Join values with commas and add a newline character
            file.write(line)

def draw_round_dot(x, y, dot_radius, file_name):
    '''
    Function to create a dot using vectorization techniques.
    '''
    import numpy as np
    # Load the data from the file into a NumPy array
    data = np.loadtxt(file_name, delimiter=',', dtype=int)

    n, m = data.shape  # Get the dimensions of the array

    # Ensure the specified coordinates are within bounds
    if x < 0 or x >= m or y < 0 or y >= n:
        print("Error: Coordinates are out of bounds.")
        return

    # Create a grid of coordinates
    i, j = np.ogrid[:n, :m]
    
    # Calculate the squared distance from the center
    distance_squared = (i - y) ** 2 + (j - x) ** 2
    
    # Use vector operations to update the data
    data[distance_squared <= dot_radius ** 2] = 0

    # Save the updated data back to the file
    np.savetxt(file_name, data, delimiter=',', fmt='%d')

def val_v(x, y):
	if x[0] < 0 or x[0] >= m or x[1] < 0 or x[1] >= m or y[0] < 0 or y[0] >= n or y[1] < 0 or y[1] >= n:
		print("1")
		return True
	if x[2] < 0 or x[2] >= m or x[3] < 0 or x[3] >= m or y[2] < 0 or y[2] >= n or y[3] < 0 or y[3] >= n:
		print("2")
		return True
	return False

def abs_v(x, y):
	abs_v_res = [0, 0, 0, 0]

	abs_v_res[0] = abs(x[1] - x[0])
	abs_v_res[1] = abs(x[3] - x[2])

	abs_v_res[2] = abs(y[1] - y[0])
	abs_v_res[3] = abs(y[3] - y[2])
	return abs_v_res

def dir_v(x, y):
	dir_v_res = [0, 0, 0, 0]
	dir_v_res[0] = 1 if x[0] < x[1] else -1
	dir_v_res[1] = 1 if x[2] < x[3] else -1

	dir_v_res[2] = 1 if y[0] < y[1] else -1
	dir_v_res[3] = 1 if y[2] < y[3] else -1
	return dir_v_res

def draw_bresenham_line(x, y, file_name):
    '''
    Function to draw a line using the bresenham method. This can be used for non horizontal and vertical lines.
    '''
    import numpy as np
	# Load the data from the file into a NumPy array
    data = np.loadtxt(file_name, delimiter=',', dtype=int)

    n, m = data.shape  # Get the dimensions of the array

    # Ensure the specified coordinates are within bounds
    if val_v(x, y):
        print(x)
        print(y)
        print("Error: Coordinates in vector are out of bounds.")
        return

    # Calculate differences and direction for x and y
    dxy = abs_v(x, y)
    sxy = dir_v(x, y)

    # Initialize error
    error1 = dxy[0] - dxy[2]
    error2 = dxy[1] - dxy[3]

    # Initialize loop variables
    x0 = x[0]
    x1 = x[2]
    y0 = y[0]
    y1 = y[2]


    break_loop_0 = False
    break_loop_1 = False
    # Simplified loop unrolling
    while True:
        # Set the pixel at (x, y) to 0
        data[y0, x0] = 0
        data[y1, x1] = 0

        if break_loop_0 and break_loop_1:
            break
        if x0 == x[1] and y0 == y[1] and (not break_loop_0):
            break_loop_0 = True
        if x1 == x[3] and y1 == y[3] and (not break_loop_1):
            break_loop_1 = True

        if not break_loop_0:
            e2 = 2 * error1
            if e2 > -(dxy[2]):
                error1 -= dxy[2]
                x0 += sxy[0]
            if e2 < dxy[0]:
                error1 += dxy[0]
                y0 += sxy[2]

        if not break_loop_1:
            e2 = 2 * error2
            if e2 > -(dxy[3]):
                error2 -= dxy[3]
                x1 += sxy[1]
            if e2 < dxy[1]:
                error2 += dxy[1]
                y1 += sxy[3]

    # Save the updated data back to the file
    np.savetxt(file_name, data, delimiter=',', fmt='%d')

def draw_horizontal_line(x1, x2, y, file_name):
    '''
    Function to draw a horizontal line.
    '''
    import numpy as np
    # Load the data from the file into a NumPy array
    data = np.loadtxt(file_name, delimiter=',', dtype=int)

    n, m = data.shape  # Get the dimensions of the array

    # Calculate the number of full 4-element vectors
    full_vectors = (x2 - x1 + 1) // 4

    # Use NumPy slicing for vectorized operations
    if full_vectors > 0:
        data[y, x1:x1 + full_vectors * 4] = 0

    # Save the updated data back to the file
    np.savetxt(file_name, data, delimiter=',', fmt='%d')

def draw_vertical_line(x, y1, y2, file_name):
    '''
    Function to draw a vertical line.
    '''
    import numpy as np
    # Load the data from the file into a NumPy array
    data = np.loadtxt(file_name, delimiter=',', dtype=int)

    n, m = data.shape  # Get the dimensions of the array

    # Calculate the number of full 4-element vectors
    full_vectors = (y2 - y1 + 1) // 4

    # Use NumPy slicing for vectorized operations
    if full_vectors > 0:
        data[y1:y1 + full_vectors * 4, x] = 0

    # Save the updated data back to the file
    np.savetxt(file_name, data, delimiter=',', fmt='%d')

def create_image(file_name, output_image_name, n, m):
    '''
    Function to create an image from the text file containing the pixels.
    '''
    from PIL import Image
    with open(file_name, 'r') as file:
        content = file.read()
    
    values = content.split('\n')[:-1]  # Split content into rows and remove the empty last row

    if len(values) != n:
        print("Error: Number of rows in the file does not match 'n'")
        return

    pixel_data = []
    for row in values:
        row_values = row.split(',')
        if len(row_values) != m:
            print(f"Error: Row {len(pixel_data) + 1} does not contain {m} values.")
            return

        pixel_row = [(int(value), int(value), int(value)) for value in row_values]  # Assuming grayscale (R = G = B)
        pixel_data.extend(pixel_row)

    image = Image.new('RGB', (m, n))
    image.putdata(pixel_data)
    image.save(output_image_name)

# Example usage:
file_name = "image.txt"
output_image_name = "figure.png"
n = 480  # Number of rows
m = 640  # Number of values per row
create_image_file(file_name, n, m)

# Triangle 1
draw_round_dot(60, 160, 5, file_name)
draw_round_dot(110, 60, 5, file_name)
draw_round_dot(160, 160, 5, file_name)
draw_bresenham_line((60, 110, 160, 110), (160, 60, 160, 60), file_name)

# Triangle 2
draw_round_dot(360, 110, 5, file_name)
draw_round_dot(410, 10, 5, file_name)
draw_round_dot(460, 110, 5, file_name)
draw_bresenham_line((360, 410, 460, 410), (110, 10, 110, 10), file_name)

# Lines between triangle
draw_bresenham_line((60, 360, 160, 460), (160, 110, 160, 110), file_name)
draw_bresenham_line((110, 410, 110, 410), (60, 10, 60, 10), file_name)

# Bottom line 1
draw_round_dot(60, 360, 5, file_name)
draw_round_dot(160, 360, 5, file_name)
draw_horizontal_line(60, 160, 360, file_name)

# Bottom line 2
draw_round_dot(360, 310, 5, file_name)
draw_round_dot(460, 310, 5, file_name)
draw_horizontal_line(360, 460, 310, file_name)

# Lines between bottom line
draw_bresenham_line((60, 360, 160, 460), (360, 310, 360, 310), file_name)

# Lines between upper triangles and bottom line
draw_vertical_line(60, 160, 360, file_name)
draw_vertical_line(160, 160, 360, file_name)

draw_vertical_line(360, 110, 310, file_name)
draw_vertical_line(460, 110, 310, file_name)

# Create the image file
create_image(file_name, output_image_name, n, m)
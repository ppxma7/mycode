from psychopy import visual, core, event
from PIL import Image
import numpy as np
import pandas as pd
import random
import scipy.ndimage
import time


# Define the desired width and height for the images
image_width = 600
image_height = 400
# Create a window to display the images
win = visual.Window(size=(800, 600), units='pix')

# Read image file paths from multiple CSV files into a list of Pandas DataFrames
csv_files = [
    "/Users/ppzma/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_brand_green.csv",
    "/Users/ppzma/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_brand_gold.csv",
    "/Users/ppzma/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_unbrand_green.csv",
    "/Users/ppzma/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_brand_red.csv",
    "/Users/ppzma/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_unbrand_gold.csv",
    "/Users/ppzma/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_unbrand_red.csv",
    "/Users/ppzma/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_brand_green.csv",
    "/Users/ppzma/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_brand_gold.csv",
    "/Users/ppzma/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_unbrand_green.csv",
    "/Users/ppzma/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_brand_red.csv",
    "/Users/ppzma/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_unbrand_gold.csv",
    "/Users/ppzma/Documents/MATLAB/nottingham/michael/zespri_code/zespri_brand/zespri_unbrand_red.csv"
]

# Set the random seed for pseudorandomization
random_seed = 1234  # Change this seed for different pseudorandomization


# Wait for the key '5' before starting the experiment
waiting_text = visual.TextStim(win, text="Waiting for a trigger", height=30, color='white')
waiting_text.draw()
win.flip()
event.waitKeys(keyList=['5'])

# Set the random seed
random.seed(random_seed)

# Shuffle the CSV file paths pseudorandomly
random.shuffle(csv_files)

# Print the order of CSV files for this subject
print("Order of CSV files:")
for i, csv_file in enumerate(csv_files):
    print(f"Subject {i+1}: {csv_file}")


# Set the duration of image display and fixation cross
image_duration = 1.6  # Duration of image display in seconds
fixation_cross_duration = 0.4  # Duration of fixation cross in seconds
sigma = 1  # Degree of Gaussian blurring
# Set the target duration for the block
block_target_duration = 32.0  # Target duration for each block in seconds
between_block_dur = 3.0

for csv_file in csv_files:
    fixation_cross = visual.TextStim(win, text='+', color='white', height=30)
    fixation_cross.draw()
    win.flip()

    # Read the CSV file
    #start_time = time.time()
    load_clock = core.Clock()
    data = pd.read_csv(csv_file)

    # Shuffle the DataFrame randomly
    data_shuffled = data.sample(frac=1).reset_index(drop=True)

    

    # Load normal and scrambled images for the current block
    images = []
    scrambled_images = []
    for _, row in data_shuffled.iterrows():
        # Get the image file path from the 'image_path' column
        image_file = row['image_path']

        # Load the original image using PIL
        image = Image.open(image_file)

        # Resize the image while preserving aspect ratio
        image.thumbnail((image_width, image_height))

        # Convert the image to a NumPy array
        image_array = np.array(image)

        # Normalize the pixel values to the range [0, 1]
        image_array = image_array.astype(float) / 255.0

        # Flip the image array vertically (if needed)
        image_array = np.flip(image_array, axis=0)

        # Append the image array to the list of images
        images.append(image_array)

        # Apply scrambling and blurring to the image array
        image_array_copy = image_array.copy()

        # Split the image array into color channels (R, G, B)
        r, g, b = image_array_copy[:, :, 0], image_array_copy[:, :, 1], image_array_copy[:, :, 2]

        # Flatten the color channels
        r_flattened = r.flatten()
        g_flattened = g.flatten()
        b_flattened = b.flatten()

        # Shuffle the pixel values within each color channel independently
        random.shuffle(r_flattened)
        random.shuffle(g_flattened)
        random.shuffle(b_flattened)

        # Reshape the shuffled pixel values back into the original shape
        r_shuffled = r_flattened.reshape(r.shape)
        g_shuffled = g_flattened.reshape(g.shape)
        b_shuffled = b_flattened.reshape(b.shape)

        # Combine the shuffled color channels into a single image
        shuffled_image = np.dstack((r_shuffled, g_shuffled, b_shuffled))

        # Apply Gaussian blur to the shuffled image
        #blurred_image = scipy.ndimage.gaussian_filter(shuffled_image, sigma=sigma)

        # Append the blurred image to the list of scrambled images
        #scrambled_images.append(blurred_image)
        scrambled_images.append(shuffled_image)
        
    #loading_time = time.time() - start_time
    #print(f"Loaded {csv_file} and scrambled in {loading_time:.2f} seconds")
    elapsed_load_time = load_clock.getTime()
    print(f"Load time took {elapsed_load_time:.2f} seconds")
    
    if elapsed_load_time < between_block_dur:
        remaining_time = between_block_dur - elapsed_load_time
        core.wait(remaining_time)
        print(f"I have waited an extra {remaining_time:.2f} seconds")
    
    #block_time = time.time()
    # Create a clock for precise timing
    block_clock = core.Clock()
    # Iterate over the shuffled DataFrame for the current block
    for _, row in data_shuffled.iterrows():
        # Get the index for the current row
        index = row.name

        # Get the image for the current index
        image = images[index]

        # Create PsychoPy ImageStim object for the image
        image_stim = visual.ImageStim(
            win,
            image=image,
            units="pix",
            size=(image.shape[1], image.shape[0]),
            colorSpace="rgb1"
        )

        # Display the image for the specified duration
        image_stim.draw()
        win.flip()
        core.wait(image_duration)
        #core.wait(display_time)

        # Display the fixation cross for the specified duration
        fixation_cross = visual.TextStim(win, text='+', color='white', height=30)
        fixation_cross.draw()
        win.flip()
        core.wait(fixation_cross_duration)
        #core.wait(display_time)


        # Check for key press to quit the experiment
        keys = event.getKeys()
        if 'q' in keys:
            break
    if 'q' in keys:
        break

    # Iterate over the shuffled DataFrame for the current block (scrambled images)
    for _, row in data_shuffled.iterrows():
        # Get the index for the current row
        index = row.name

        # Get the blurred image for the current index
        scrambled_image = scrambled_images[index]

        # Create PsychoPy ImageStim object for the scrambled image
        scrambled_stim = visual.ImageStim(
            win,
            image=scrambled_image,
            units="pix",
            size=(scrambled_image.shape[1], scrambled_image.shape[0]),
            colorSpace="rgb1"
        )

        # Display the scrambled image for the specified duration
        scrambled_stim.draw()
        win.flip()
        core.wait(image_duration)

        # Calculate the remaining time in the block
        remaining_block_time = block_target_duration - block_clock.getTime()

        # Adjust the image display time if remaining_time is less than fixation_cross_duration
        display_time = min(remaining_block_time, fixation_cross_duration)
        #print(f"Display time is {display_time:.2f} seconds")

        # Display the fixation cross for the specified duration
        fixation_cross = visual.TextStim(win, text='+', color='white', height=30)
        fixation_cross.draw()
        win.flip()
        #core.wait(fixation_cross_duration)
        core.wait(display_time)

        # Check for key press to quit the experiment
        keys = event.getKeys()
        if 'q' in keys:
            break

        # Update the remaining time in the block
        #remaining_block_time = block_target_duration - block_clock.getTime()
        
        #if remaining_block_time <= 0:
        #    print(f"Remaining time is {remaining_block_time:.2f} seconds")
        #    break
        #break

    if 'q' in keys:
        break
        
    #block_loading_time = time.time() - block_time
    #print(f"Block time took {block_loading_time:.2f} seconds")

    # Calculate the elapsed time for the block
    elapsed_time = block_clock.getTime()
    print(f"Block time took {elapsed_time:.2f} seconds")


# Clean up
win.close()
core.quit()
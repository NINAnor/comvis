import glob
import os
import shutil

# List the files
all_files = glob.glob("/data/R/Prosjekter/Birchmoth/IMG_Viltkamera_Polmak/Viltkamera13_Sept17-Aug18/**/*md_v5a.0.0.pt.jpg", recursive=True)

# Set the destination directory
destination_directory = "/data/R/Prosjekter/Birchmoth/IMG_Viltkamera_Polmak/Training images/CROPS"

# Check if destination directory exists. If not, create it.
if not os.path.exists(destination_directory):
    os.makedirs(destination_directory)

for file_path in all_files:
    # Extract parent folder name
    parent_folder = file_path.split("/")[-3]
    
    # Create new filename with prefix
    new_file_name = parent_folder + "_" + file_path.split("/")[-1]
    
    # Create new file path in the original location
    new_file_path_original = os.path.join("/".join(file_path.split("/")[:-1]), new_file_name)
    
    # Rename the file in its original location
    os.rename(file_path, new_file_path_original)
    
    # Create new file path in the destination folder
    new_file_path_destination = os.path.join(destination_directory, new_file_name)
    
    # Copy the file to the destination folder
    shutil.copy2(new_file_path_original, new_file_path_destination)
#!/usr/bin/env python3

import os
import glob
import json


if __name__ == "__main__":

    # specify the filename of the .txt file
    filename = "/home/benjamin.cretois/Code/run_megadetector_nina/jane_sats/sats_folders.txt"

    # create an empty list to store the JSON data
    json_data = []

    # read the list of paths from the .txt file
    with open(filename, "r") as f:
        paths = f.readlines()

    # loop through each path and load the JSON data
    for p in paths:
        # strip any trailing whitespace or newlines from the path
        p = p.strip()
        # Get the output.json file
        p = os.path.join("/data", p, "output.json")

        # open the JSON file and load the data
        with open(p, "r") as f:
            data = json.load(f)
            data = data['images']
            json_data.append(data)

    # write the final JSON data to a file
    with open("final.json", "w") as f:
        json.dump(json_data, f, indent = 1)

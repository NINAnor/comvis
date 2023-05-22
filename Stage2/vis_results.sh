#!/bin/bash

set -euo pipefail
set -x

# Setup the environment
cd ~/git/cameratraps

# Arguments
FOLDERS=$1

#conda activate cameratraps-detector

export PYTHONPATH="$HOME/git/cameratraps:$HOME/git/ai4eutils:$HOME/git/yolov5"

# Read the .txt file containing all the folders to be processed
readarray -t lines < $FOLDERS

# Loop through the lines
for line in "${lines[@]}"
do
    # Parse the lines properly
    line="$(tr -d $'\r' <<< $line)"
    
    # Make a directory that will conain the annotated pics
    mkdir -p $line/PICS_WITH_BB

    # Run the script
    python visualization/visualize_detector_output.py \
        "$line/output.json" \
        "$line/PICS_WITH_BB" \
        -i $line
done

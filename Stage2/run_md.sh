#!/bin/bash

set -euo pipefail
set -x

# Argument
FOLDERS=$1

# Setup the environment
cd ~/git/cameratraps

#conda activate cameratraps-detector

export PYTHONPATH="$HOME/git/cameratraps:$HOME/git/ai4eutils:$HOME/git/yolov5"

readarray -t lines < $FOLDERS
for line in "${lines[@]}"
do
    line="$(tr -d $'\r' <<< $line)"
    echo $line
    python3 detection/run_detector_batch.py \
        "$HOME/git/megadetector/md_v5a.0.0.pt" \
        "$line" \
        "$line/output.json" \
        --recursive \
        --checkpoint_frequency 5000
done

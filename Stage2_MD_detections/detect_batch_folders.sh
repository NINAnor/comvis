#!/bin/bash

set -euo pipefail

# Read the input file
TXT_FILE="$1"

# Read the file line by line
while read -r line
do

  echo "Processing folder: $line"

  docker run \
      --rm \
      --gpus all \
      -v "$line":/data \
      comvis \
      python3 MegaDetector/detection/run_detector_batch.py \
          "./megadetector/md_v5a.0.0.pt" \
          /data \
          "/data/detections.json" \
          --recursive \
          --checkpoint_frequency 5000

done < "$TXT_FILE"
#!/bin/bash

set -euo pipefail

# Read the input file
TXT_FILE="$1"

# Read the file line by line
while read -r line
do

  echo "Processing folder: $line"

  mkdir -p "$line/CROPS"

    docker run \
        --rm \
        --gpus all \
        -v "$line":/data \
        comvis \
        python3 MegaDetector/classification/crop_detections.py \
            /data/detections.json \
            /data/crops \
            --images-dir /data \
            --threshold 0.8 \
            --save-full-images --square-crops

done < "$TXT_FILE"
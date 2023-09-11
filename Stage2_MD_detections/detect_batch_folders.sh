#!/bin/bash

set -euo pipefail

# Read the input file
TXT_FILE="$1"

# Read the file line by line
while read -r INPUT; do
  # Skip empty lines
  if [ -z "$INPUT" ]; then
    continue
  fi

  echo "Processing folder: $INPUT"

  exec docker run \
      --rm \
      --gpus all \
      -v "$INPUT":/data \
      comvis \
      python3 MegaDetector/detection/run_detector_batch.py \
          "./megadetector/md_v5a.0.0.pt" \
          /data \
          "/data/detections.json" \
          --recursive \
          --checkpoint_frequency 5000

done < "$TXT_FILE"
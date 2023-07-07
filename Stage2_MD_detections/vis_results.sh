#!/bin/bash

set -euo pipefail

INPUT="$1"

mkdir -p $INPUT/PICS_WITH_BB

exec docker run \
    --rm \
    --gpus all \
    -v "$INPUT":/data \
    comvis \
    python3 MegaDetector/md_visualization/visualize_detector_output.py \
        "/data/detections.json" \
        "/data/PICS_WITH_BB" \
        -i "/data"
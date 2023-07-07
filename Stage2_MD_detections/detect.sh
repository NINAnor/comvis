#!/bin/bash

set -euo pipefail

INPUT="$1"

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
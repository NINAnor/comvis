#!/bin/bash

set -euo pipefail

INPUT="$1"

mkdir -p "$INPUT/CROPS"

exec docker run \
    --rm \
    --gpus all \
    -v "$INPUT":/data \
    comvis \
    python3 MegaDetector/classification/crop_detections.py \
        /data/detections.json \
        /data/crops \
        --images-dir /data \
        --threshold 0.8 \
        --save-full-images --square-crops
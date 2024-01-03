#!/bin/bash

set -euo pipefail

BASEDIR="$1"

exec docker run \
    --rm \
    --gpus all \
    -v "$BASEDIR":/data \
    -v ./logs:/app/logs \
    --shm-size 20G \
    comvis \
    python3 Stage3_Custom_Classifier/train_classifier.py \
        /data/label_studio.csv \
        /data \
        --epochs 100 \
        --pretrained \
        --batch-size 64
#!/bin/bash

set -euo pipefail

BASEDIR="$1"

exec docker run \
    --rm \
    --gpus all \
    -v "$BASEDIR":/data \
    -v ./logs:/app/logs \
    comvis \
    python3 Stage3_Custom_Classifier/train_classifier.py \
        /data/label_studio.csv \
        /data/crops \
        --epochs 5 \
        --pretrained

# /data/Prosjekter3/823001_17_metodesats_analyse_23_04_jepsen/Megadetector_caseA/
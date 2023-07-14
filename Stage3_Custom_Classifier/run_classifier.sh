#!/bin/bash

set -euo pipefail

MODEL_PATH="$1"
CROPS_TO_PREDICT="$2"

exec docker run \
    --rm \
    --gpus all \
    -v "$MODEL_PATH":/model.pt \
    -v "$CROPS_TO_PREDICT":/crops \
    -v ./logs:/app/logs \
    comvis \
    python3 MegaDetector/classification/run_classifier.py \
        /model.pt \
        /crops \
        /app/logs/model_results.csv \
        --classifier-categories /app/logs/label_correspondance.json


# /home/benjamin.cretois/Code/ComVis/logs/ckpt_0_compiled.pt
# /data/Prosjekter3/823001_17_metodesats_analyse_23_04_jepsen/Megadetector_caseA/crops



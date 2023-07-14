#!/bin/bash

set -euo pipefail

CROPS_FOLDER="$1"
LABEL_STUDIO_FILE="$2"
BASEDIR="$(dirname $LABEL_STUDIO_FILE)"

mkdir -p "$BASEDIR/label_correspondance"

exec docker run \
    --rm \
    --gpus all \
    -v "$CROPS_FOLDER":/crops \
    -v "$LABEL_STUDIO_FILE":/label_studio_file.csv \
    -v $BASEDIR/label_correspondance:/label_correspondance \
    -v ./logs:/app/logs \
    comvis \
    python3 Stage3_Custom_Classifier/train_classifier.py \
        "/label_studio_file.csv" \
        "/crops" \
        --label_correspondance /label_correspondance \
        --epochs 5 \
        --pretrained

# /data/Prosjekter3/823001_17_metodesats_analyse_23_04_jepsen/Megadetector_caseA/crops
# /data/Prosjekter3/823001_17_metodesats_analyse_23_04_jepsen/Megadetector_caseA/label_studio.csv
# /data/Prosjekter3/823001_17_metodesats_analyse_23_04_jepsen/Megadetector_caseA/label_correspondance
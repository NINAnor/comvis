#!/bin/bash

set -euo pipefail

MODEL_PATH="$1"
CROPS_TO_PREDICT="$2"
OUTPUT_FOLDER="$3"

exec docker run \
    --rm \
    --gpus all \
    -v "$MODEL_PATH":/model.pt \
    -v "$CROPS_TO_PREDICT":/crops \
    -v "$OUTPUT_FOLDER":/output_folder\
    comvis \
    python3 MegaDetector/classification/run_classifier.py \
        /model.pt \
        /crops \
        /output_folder/model_results.csv


# /home/benjamin.cretois/Code/ComVis/Stage3_Custom_Classifier/logs/ckpt_5_compiled.pt
# /data/Prosjekter3/823001_17_metodesats_analyse_23_04_jepsen/Megadetector_caseA/crops
# /data/Prosjekter3/823001_17_metodesats_analyse_23_04_jepsen/Megadetector_caseA/OUTPUT/output.csv



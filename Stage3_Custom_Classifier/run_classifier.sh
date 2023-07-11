#!/bin/bash

set -euo pipefail

MODEL_PATH=
CROPS_TO_PREDICT=

exec docker run \
    --rm \
    --gpus all \
    -v "$MODEL_PATH":/model.pt \
    -v "$CROPS_TO_PREDICT":/crops \
    comvis \
    python3 classification/run_classifier.py \
        model.pt \
        crops

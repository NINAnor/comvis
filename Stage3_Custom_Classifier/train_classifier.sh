


# FROM https://github.com/agentmorris/MegaDetector/tree/main/classification

## !! LOOK BETTER AT THE INSTRUCTIONS !!

python train_classifier.py \
    $BASE_LOGDIR \
    /path/to/crops \
    --model-name efficientnet-b3 --pretrained \
    --label-weighted --weight-by-detection-conf /path/to/classifier-training/mdv4_1_isotonic_calibration.npz \
    --epochs 50 --batch-size 160 --lr 0.0001 \
    --logdir $BASE_LOGDIR --log-extreme-examples 3
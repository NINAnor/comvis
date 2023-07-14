# Stage 3. Species-level annotation and identification 

MegaDetector detects animals on pictures and does not classify into taxa. In most applications however, the taxon of the animal is needed (e.g. indexes of species richness, species abundance or occurrence). We will develop the pipeline by using the animal detections of MegaDetector for training a custom species classifier.

## Set up a LabelStudio project for labeling

Please refer to the [instructions on how to set up a LabelStudio projects].

Note that to be able to train a custom classifier, the scripts assume that the exported labelstudio results are exported as a `.csv` file

## Train the custom classifier

Once the crops have been properly labelled and that the labelstudio file have been exported it is possible to train the classifier model using `train_classifier.sh`.

The script takes 2 arguments: the path to the cropped pictures and the path to the exported labelstudio file. The script can be ran as follow:

```bash
./train_classifier.sh /PATH∕TO/CROPS /PATH/TO/LABELSTUDIO/FILE
```

This will result in the creation of a `./log` folder containing information relative to the model training (i.e. the `events.out` files) and the model itself (i.e. the `.pt` file). Note that to visualize the `events.out` files you need to download and use `tensorboard`.

## Run the custom classifier on your own images
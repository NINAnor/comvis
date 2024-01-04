# Stage 2: Image target filtering with MegaDetector

Removing empty camera trap pictures and annotating the  remaining  images  with  species  present  is  the  most  time-consuming  step  if  done  manually  but  can  be automatized using existing tools. MegaDetector, a machine learning model whose task is to detect animals on camera trap pictures, is now widely used in the conservation community and could provide a cost-efficient alternative to manual tagging. In stage 2 we construct an end-to-end pipeline using MegaDetector for  automatic  detection of  species of  camera  trap  pictures.

## How to use the folder

### Detection

#### For a single path:

To run `MegaDetector v.5` on the folders containing your images run `run_md.sh` as shown below. This will create a `detection.json` file containing all the detections made by `MegaDetector`.

```bash
./detect.sh /FOLDER/TO/ANALYSE
```

#### For multiple paths:

If you want to run `MegaDetector v.5` on multiple path:

- Create a `PATHS.txt` file containing all the paths to **the folders** need to be processed. 
- Run `detect_batch_folders.sh` in the following way:

```bash
./detect_batch_folders.sh PATHS.txt
```

### Cropping

To crop the detections (i.e. isolate the picture of the animal) run `crop_detections.sh`. The script will create a subfolder `CROPS` which contains the cropped detection. The cropped detection can then be used to train a custom classifier for your dataset (refer to Stage 3).

```bash
./crop_detections.sh /FOLDER/TO/ANALYSE
```

Or if you have a `PATHS.txt` file listing the folders to be processed run:

```bash
./crop_detections_batch.sh PATHS.txt
```

### Gather the crops in a single folder

You can gather all the crops into a single folder. This is especially useful if there was many folders to be processed (each one containing a `CROPS` folder). This will allow to add a single folder to LabelStudio 

### Visualize the detections 

**Optionally** you can visualize the detections by drawing the `bounding boxes` around the detected animals. To do so run `vis_results.sh`. This will create a subfolder `PICS_WITH_BBOX` containing a copy of the analysis images with the corresponding bounding boxes.

```bash
./vis_results.sh /FOLDER/TO/ANALYSE
```
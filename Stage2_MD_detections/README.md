# Stage 2: Image target filtering with MegaDetector

Removing empty camera trap pictures and annotating the  remaining  images  with  species  present  is  the  most  time-consuming  step  if  done  manually  but  can  be automatized using existing tools. MegaDetector, a machine learning model whose task is to detect animals on camera trap pictures, is now widely used in the conservation community and could provide a cost-efficient alternative to manual tagging. In stage 2 we construct an end-to-end pipeline using MegaDetector for  automatic  detection of  species of  camera  trap  pictures.

## How to use the folder

### Detection

To run `MegaDetector v.5` on the folders containing your images run `run_md.sh` as shown below. This will create a `detection.json` file containing all the detections made by `MegaDetector`.

```bash
./run_md.sh /FOLDER/TO/ANALYSE
```

### Cropping

To crop the detections (i.e. isolate the picture of the animal) run `crop_detections.sh`. The script will create a subfolder `CROPS` which contains the cropped detection. The cropped detection can then be used to train a custom classifier for your dataset (refer to Stage 3).

```bash
./crop_detecctions.sh /FOLDER/TO/ANALYSE
```

### Visualize the detections 

**Optionally** you can visualize the detections by drawing the `bounding boxes` around the detected animals. To do so run `vis_results.sh`. This will create a subfolder `PICS_WITH_BBOX` containing a copy of the analysis images with the corresponding bounding boxes.

```bash
./vis_results.sh /FOLDER/TO/ANALYSE
```
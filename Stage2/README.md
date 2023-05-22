# Stage 2: Image target filtering with MegaDetector

Removing empty camera trap pictures and annotating the  remaining  images  with  species  present  is  the  most  time-consuming  step  if  done  manually  but  can  be automatized using existing tools. MegaDetector, a machine learning model whose task is to detect animals on camera trap pictures, is now widely used in the conservation community and could provide a cost-efficient alternative to manual tagging. In stage 2 we construct an end-to-end pipeline using MegaDetector for  automatic  detection of  species of  camera  trap  pictures.

## How to use the folder

Write in a .txt document the folders containing all the images to be processed. The `.txt` file should look like:

```
/data/.../FolderA
/data/.../FolderB
/data/.../FolderC
```

To run `MegaDetector v.5` on the folders containing your images run `run_md.sh` as shown below. `/PATH/TO/MY_FOLDERS.txt` should be replaced with your `.txt` file. Note that in every folder the script will write an `output.json` contaning all the detections for that specific folder.

```bash
bash run_md.sh /PATH∕TO/MY_FOLDERS.txt
```

To visualise the detections run `vis_results.sh` as shown below. Note that for each folder analysed, the script will create a new folder `PICS_WITH_BB` containing a copied version of the analysed images with the bounding boxes surrounding the objects detected by `MegaDetector`.

```bash
bash vis_results.sh /PATH∕TO/MY_FOLDERS.txt
```
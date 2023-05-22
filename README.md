# ComVis: ComVis: a cost-effective end-to-end pipeline for processing camera trap pictures at NINA

## Project ambition

Camera traps are increasingly used to collect data addressing key questions in ecology and nature
management. In an appropriate study-design, they provide a non-invasive way of collecting data to infer
estimates of e.g. species’ distribution, abundance and phenology. Camera traps reduce observer
effects on the target species and provide an unmatched capacity for monitoring biodiversity at spatial-
temporal scales unachievable by human observation [5-8]. In addition, they drastically reduce the invasive
human footprint in the wider environment, requiring limited maintenance other than deployment and
retrieval. Sorting and labelling the large number of pictures collected by camera traps is nevertheless
challenging.

The state-of-the-art classifier MegaDetector has been successfully used to detect animals, humans and vehicles in camera trap pictures in a wide diversity of environments and can be used to create a pipeline for both discarding empty pictures and help with labelling the animals.

The overall ambition of the project is to initiate a more efficient use of state-of-art machine learning tools,
that will streamline the processing of camera-based monitoring data in NINA. We will achieve this by
providing an end-to-end pipeline for processing of camera trap data based on a combination of an established
model (MegaDetector) and customized classifiers trained on data from NINAs monitoring programs.


## Implementation

The project is organised in four consecutive stages, where stages 1-3 are focused on methodological developments and stage 4 on documentation and reproducibility of the developments.

### Stage 1: Image quality filtering
---

1. A trained classifier which separates images into two classes;
‘unusable’ and ‘usable’.
2. Performance statistics of the classifier.
3. A set of ‘usable’ images for each case for use in Stage 2.

### Stage 2: Image target filtering with MegaDetector

1. Deployment of MegaDetector on a HPC
2. A classification of the ‘usable’ sample for each case into the
four MegaDetector classes; ‘empty’, ‘animal’, ‘human’ and
‘vehicle’.
3. Performance statistics of the classifier.
4. Cropped image sections of all animal objects detected by
MegaDetector for use in Stage 3.

### Stage 3: Stage 3. Species-level annotation and identification

1. A trained classifier which classifies cropped image sections of
animal objects to species for selected cases.
2. Performance statistics of the classifier.

### Summary ComVis' workflow

<p align="center"><img src="Docs/comvis-workflow.png" alt="figure" width="400"/></p>

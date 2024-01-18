# Stage 1: Image quality filtering

All camera-based monitoring designs must handle a certain proportion of images of such low quality that further processing is impossible because the target object would not be visible even if it was within the camera frame. Unusable images need to be removed from the image sample prior to processing and this is currently a manual, time-consuming process.

## Estimating image quality using the variation of the Laplacian

It has been tried to figuring out automatically which images should be excluded. The most promising method is to detect the blur, by computing the Laplacian of the image with different kernel sizes, which highlights the regions of the image where there are rapid intensity change, and estimate the variance of such resulting matrix: the assumption is that low variance is often linked to a blurred or low quality image.

In order to confirm such assumption, a form is automatically generated so that humans can score the images, and the result can be compared with the previously computed values.

## Running the software

Assuming that the `INPUT` and the `OUTPUT` environmental variables have been set using the path of the desired input and output folder, Docker can be used to build and run the software:

```bash
docker build -t comvis-blurred .
docker build run --rm -v "$INPUT":/input:ro -v "$OUTPUT":/output comvis-blurred
```

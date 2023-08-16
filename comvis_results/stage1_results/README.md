# Stage 1 results

The first stage was to quality filter the images. We compared the results of an algorithm with scores given by the project participants. We selected 80 images (20 per projects) of various quality and asked the project participants to give it a score ranging from 1 to 5 defined as follow:

1. **Clearly un-useable**: The image quality is very low and objects will certainly go undetected.
2. **Likely un-useable**: The image quality is low and objects are likely to go undetected in all or most of the image frame.
3. **Likely useable**: The image quality is low, but objects are likely to be detected.
4. **Useable**: The image quality is high and objects are likely to be detected.
5. **Clearly useable**: The image quality is very high and objects are highly likely to be detected.

For some examples see [the guideline document](../../assets/Quality%20score.pdf).

Using a multivariate model we estimated whether an observer effect exists. Results are displayed by the figure below.

![](../../assets/Observer%20effects%20sameresolution.png)

We compared the size of the images and results from Laplace XXX (Francesco will know) to participants score to assess whether there is a correlation and estimate if a simple filtering algorithm can automatically filter out the bad quality pictures.

The figure below shows the correlation between the scores given by the participants (C1, C2, C3, C4 and C5) and the size of the image.

![](../../assets/probability%20for%20scores%20model1.png)

We can see that the images with a very small size (i.e. containing low amount of information) are unlikely to be given a high score while images with a larger size (i.e. containing more information) are likely to be given a high score.
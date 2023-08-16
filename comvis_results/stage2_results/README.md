# Stage 2 results

For each cases, we selected good quality pictures containing either no objects to be detected, a single animal and multiple animals  to run MegaDetector on different scenarios. We asked the project owners to check the detections made by MegaDetector so assess its performance. 

The images were labelled in `LabelStudio` using the following categories:

[SO-TP] Single object present - single object detected
[SO-TN] No object present – no object detected
[SO-FP] No object present, object(s) detected (i.e. the model detects one or more non-existing object)
[SO-FN] Single object present - no object detected (i.e. the model fails to detect the object)

[MO-TP] Multiple objects present - All objects detected
[MO-FP] Multiple objects present – detected > present (i.e. the model detects one or more non-existing objects)
[MO-FN] Multiple objects present - detected < present (i.e. the model fails to detect one or more objects)

We measured different metrics:

- precision_so; recall_so; accurracy_so and F1score_so were calculated for the pictures containing a single object only
- precision_mo; recall_mo and F1score_mo were calculated for the pictures containing multiple objects


Table of results:

| Case | precision_so | recall_so | accurracy_so | F1score_so | precision_mo | recall_mo | F1score_mo |
| caseC.csv | 1.0 | 0.45454545454545453 | 0.7857142857142857 | 0.625 | 1.0 | 0.00819672131147541 | 0.016260162601626018 | 
| caseD.csv | 1.0 | 0.7692307692307693 | 0.8343558282208589 | 0.8695652173913044 | 1.0 | 0.4864864864864865 | 0.6545454545454547 | 
| caseA.csv | 1.0 | 0.95 | 0.9636363636363636 | 0.9743589743589743 | 1.0 | 0.5945945945945946 | 0.7457627118644068 |
| caseB.csv | 1.0 | 0.9411764705882353 | 0.9620253164556962 | 0.9696969696969697 | 1.0 | 0.5365853658536586 | 0.6984126984126985 |
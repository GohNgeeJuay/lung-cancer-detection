# lung-cancer-detection
Lung cancer detection using Image Processing algorithms in MATLAB


This project is using MATLAB to implement image processing algorithms. The image processing toolbox is used frequently in the project. The segmentation algorithm is used based on: 
https://www.mathworks.com/help/images/marker-controlled-watershed-segmentation.html. 

The aim of the project is to come up with a system that can locate prospective regions or nodules that could be lung cancer using CT scan images. 

In each patient folder, the CT scan images are named as following:

pX_img1.dcm
pX_img2.dcm
...

Accompanying each CT scan, we have the ground truth:

pX_seg1.dcm
pX_seg2.dcm

Where X is the patient number.

These ground truth images are the correct lung cancer nodules for the corresponding CT scan image. It is suggested for you to put
all of these images in a single folder together with the source codes for each segmentation stage, so you can run everything together.

If you are only interested in running certain files, please put the corresponding files and images together. For example to run the 
watershed algorithms only on the first image, ensure that:
images: p1_img1.dcm, p1_seg1.cdm and 
source code: p1_img1watershed.mlx
functions: noduleExtraction.m, lungExtraction.m, falseTruePositives.m and markcontrwatershed.m files are together. 


For demonstration of different outputs/performance of the system , see the the demonstration folder.

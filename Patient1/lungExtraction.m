function [maskedImage] = lungExtraction(I,fill_strel,num_blobs)
%UNTITLED Summary of this function goes here
%  Function to extract the lungs only from the CT scan image. 
%  fill_strel = structuring elemt used in imclose. Normally
%  strel('disk',15) works.
% num_blobs is the number of white objects in the image after imclose.
% Usually lungs gets joined together, so there is only 1 blob. Might have
% to change to 2 for some cases. 
%Will show the segmented lungs.

%Reference: https://www.mathworks.com/matlabcentral/answers/284421-how-do-i-remove-the-background-from-this-binary-image
%Thresholding to select black spots
ThreshI = I < mean2(I);
%figure,subplot(2,2,1),imshow(ThreshI,[]);title('Thresholded Original image');

%remove stuff touching the border (ie keep the lungs only)
%J = imclearborder(I) suppresses structures in image I that are lighter than their surroundings and that are connected to the image border.
ThreshI = imclearborder(ThreshI);
%subplot(2,2,2),imshow(ThreshI,[]);title('Binary image after imclearborder');

%Because there is too much noise, need to fill in holes by morphological
%closing rather than imfill
SE = fill_strel;
ThreshI = imclose(ThreshI,SE);
%subplot(2,2,3),imshow(ThreshI,[]);title('Mask after imfill');

%Extract specified blobs
ThreshI = bwareafilt(ThreshI,num_blobs);
%subplot(2,2,4),imshow(ThreshI,[]);title('Binary image after bwareafilt');

maskedImage = I; % Initialize
maskedImage(~ThreshI) = 0;
%figure,imshow(maskedImage, []),title('Masked original image');
end


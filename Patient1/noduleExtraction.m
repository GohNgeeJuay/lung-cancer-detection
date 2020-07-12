function [nodules] = noduleExtraction(label,preprocessed_image)
%UNTITLED3 Summary of this function goes here
%   Will do masking to extract the locations not covered by background
%   markers and foreground markers (eg, the region of interests/suspicious
%   nodules). Will show the extracted nodules.

%Extract cancer locations
%figure,imshow(label,[])

%Get both foreground and background markers
backForeMarkers = label; % Initialize
backForeMarkers(label == 1) = 3;    %The background marker has pixel values = 1
backForeMarkers(label == 3) = 3;    %The foreground marker has pixel values = 3
%figure,imshow(labelChngBack,[])

%Fill in the empty holes in the background/foreground markers
backForeMarkersFilled = imfill(backForeMarkers,8,'holes');
%figure,imshow(labelChngBackFilled,[]);title('Thresholded Original image');

%get difference between the filled image and before filled. This will give
%the parts of lung not covered by the foreground (Region of interest)
mask = backForeMarkersFilled - backForeMarkers ;
%figure,imshow(mask,[])

%Removing the boundary of the lung by removing background marker and
%erosion
mask(label(label == 1)) = 0;
%figure,imshow(Idiff,[])

SE = strel('disk',3);
mask = imerode(mask,SE);
%figure,imshow(Idiff,[]);title('Thresholded Original Image');
%Idiff = imbinarize(Idiff);

%Use the mask above to get the ROI in the preprocessed image.
nodules = preprocessed_image;
nodules(~mask) = 0;
figure,imshow(nodules,[]),title('Suspicious nodules detected');
end


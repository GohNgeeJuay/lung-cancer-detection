function [labels] = markcontrwatershed(I,openclosestrel,cleanstrel)
%UNTITLED Summary of this function goes here
%{
This function is the entire marker controlled watershed based on:
https://www.mathworks.com/help/images/marker-controlled-watershed-segmentation.html.

All images except the final results are shown.
%}

%%%%%Step 1: Read in Color image and convert into grayscale(already done
%because CT scan are grayscale images)%%%%%%%%%

%%%%%%%%%%Step 2: Use gradient Magnitude as segmentation function%%%%%
I = double(I);
gmag = imgradient(I);
%figure,imshow(gmag,[])    
%title('Gradient Magnitude'

%%%%%%%%%Step 3: Mark the foreground objects%%%%%%%%%%
%Opening = erosion -> dilation
%Opening-by-reconstruction = erosion -> morphological reconstruction

%Below is opening. 
se = openclosestrel;    
Ie = imerode(I,se);
Iobr = imreconstruct(Ie,I);
%imshow(Iobr,[])
%title('Opening-by-Reconstruction')
%Closing-by-reconstruction after opening-by-reconstruction
Iobrd = imdilate(Iobr,se);
Iobrcbr = imreconstruct(imcomplement(Iobrd),imcomplement(Iobr));
Iobrcbr = imcomplement(Iobrcbr);
%imshow(Iobrcbr,[])
%title('Opening-Closing by Reconstruction')

%calculate regional max of previous step to get good foreground markers
fgm = imregionalmax(Iobrcbr);
%imshow(fgm,[])
%title('Regional Maxima of Opening-Closing by Reconstruction')
%For visual purposes, overlay foreground markers onto image
%fgMark = labeloverlay(I,fgm);
%imshow(fgMark,[])
%title('Regional Maxima Superimposed on Original Image')
%Foreground markers very close to object's edges. Clean the markers and
%shrink a bit. Done by closing followed by erosion.
se2 = cleanstrel;    
fgm2 = imclose(fgm,se2);
fgm3 = imerode(fgm2,se2);
%remove isolated pixels. Done by using bwareaopen which removes all blobs that have fewer than a certain number of pixels.
fgm4 = bwareaopen(fgm3,20);
I3 = labeloverlay(I,fgm4);
%imshow(I3,[])
%title('Modified Regional Maxima Superimposed on Original Image')

%%%%%%%%%%%Step 4: Compute background markers%%%%%%%%%
%Mark the background by thresholding
bw = imbinarize(Iobrcbr);
%imshow(bw,[])
%title('Thresholded Opening-Closing by Reconstruction')
%Don't want background markers to be too close to edges of objects we want
%to segment. 'Thin' the background by computing "skeleton by influence zones",
%or foreground of bw. This can be done by computing the watershed transform of the distance transform of bw, and then looking for 
%the watershed ridge lines (DL == 0) of the result.
D = bwdist(bw);
DL = watershed(D);
bgm = DL == 0;
%imshow(bgm,[])
%title('Watershed Ridge Lines')

%%%%%%%%%%%%Step 5 : Compute watershed%%%%%%%%%%%%%%
%Here you can use imimposemin to modify the gradient magnitude image so that its only regional minima occur at foreground and background marker pixels.
gmag2 = imimposemin(gmag, bgm | fgm4);
L = watershed(gmag2);

%%%%%%%%%%%Step 6: Visualize results%%%%%%%%%%%%%%%%%
%One visualization technique is to superimpose the foreground markers, background markers, and segmented object boundaries on the original image. 
%You can use dilation as needed to make certain aspects, such as the object boundaries, more visible. Object boundaries are located where L == 0. The binary foreground and background markers are scaled to different integer values so that they are assigned different labels.
labels = imdilate(L==0,ones(3,3)) + 2*bgm + 3*fgm4;
I4 = labeloverlay(I,labels);
figure,imshow(I4,[])
title('Markers and Object Boundaries Superimposed on Original Image')


%Another useful visualization technique is to display the label matrix as a color image. Label matrices, such as those produced by watershed and bwlabel, can be converted to truecolor images for visualization purposes by using label2rgb.
Lrgb = label2rgb(L,'jet','w','shuffle');
imshow(Lrgb,[])
title('Colored Watershed Label Matrix')
%You can use transparency to superimpose this pseudo-color label matrix on top of the original intensity image.
%figure
%imshow(I)
%hold on
%himage = imshow(Lrgb);
%himage.AlphaData = 0.3;
%title('Colored Labels Superimposed Transparently on Original Image')

%Same as the first except image preprocessed more obvious
figure
imshow(I,[])
hold on
himage = imshow(I4);
himage.AlphaData = 0.7;
title('Colored Labels Superimposed Transparently on Original Image')

end


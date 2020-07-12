function [truePosRatio,falsePosRatio] = falseTruePositives(nodules,truth)
%UNTITLED2 Summary of this function goes here
%   This function will give the true positives as a ratio of the
%   actual lung cancer nodules. False positives will be given also as a
%   ratio but its the factor of how many times more suspicious regions detected 
%   compared to the actual region. 
%   Example: True positive = 0.4. Means 40% of the correct regions/nodules
%   were detected.
%   False positives = 3.0. Means there is 3 times the area of the dectected
%   wrong region compared to the area of the correct regions.

%Get percentage correct of suspicious regions based on cancer location of
%ground truth
%do thresholding on nodules
nodulesThresh = nodules;
nodulesThresh(nodules < 0 | nodules > 0) = 1;
nodulesThresh(nodules == 0) = 0;
nodulesThresh = cast(nodulesThresh,'logical');
%imshow(nodulesThresh,[]);

groundTruth = truth;
groundTruth = imbinarize(groundTruth);
%figure,imshow(groundTruth,[]),title('Cancer location');

%Difference is using summation. But same thing in practice. 0 = correct
%false negatives. 1 = False positives. 2 = True Positives
diff = nodulesThresh + groundTruth;
%figure,imshow(diff,[]),title('Difference');

%Number of unique values for diff
c = unique(diff);

%True positives
truePos = diff;
truePos(diff == 1) = 0;
%figure,imshow(truePos,[]);
unique(truePos);
%get number of truePos
numTruePos = sum(truePos(:) == 2);
%ratio based on ground truth
truePosRatio = numTruePos / sum(groundTruth(:) == 1); 

%False positives
falsePos = diff;
falsePos(diff == 2) = 0;
%figure,imshow(falsePos,[]);
unique(falsePos);
%get number of falsePos
numFalsePos = sum(falsePos(:) == 1);
falsePosRatio = numFalsePos / sum(groundTruth(:) == 1) ;
end


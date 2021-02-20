% Extract descriptors.
%
% Input:
%   img           - the gray scale image
%   keypoints     - detected keypoints in a 2 x q matrix
%   
% Output:
%   keypoints     - 2 x q' matrix
%   descriptors   - w x q' matrix, stores for each keypoint a
%                   descriptor. w is the size of the image patch,
%                   represented as vector
function [keypoints, descriptors] = extractDescriptors(img, keypoints)
% filter out keypoints near border
border = 5; % define the 'width' of border

filter_k = [];
[w, h] = size(img);
num_k = size(keypoints, 2);
for i=1:num_k
    if keypoints(1, i)>=border && keypoints(1,i)<= w-border && keypoints(2, i)>=border && keypoints(2,i)<= h-border
        filter_k = [filter_k keypoints(:,i)];
    end
end
keypoints = filter_k;
% extract patches
descriptors = extractPatches(img, keypoints, 9);
 
end
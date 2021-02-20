% =========================================================================
% Feature extraction and matching
% =========================================================================
clear
addpath helpers

%don't forget to initialize VLFeat
disp('initialize VLFeat')
run('../vlfeat/vlfeat-0.9.21/toolbox/vl_setup')
%Load images
imgName1 = 'images/ladybug_Rectified_0768x1024_00000064_Cam0.png'; % Try with some different pairs
imgName2 = 'images/ladybug_Rectified_0768x1024_00000080_Cam0.png';
% imgName1 = 'images/rect1.jpg'; % Try with some different pairs
% imgName2 = 'images/rect2.jpg';
% imgName1 = 'images/pumpkin1.JPG';
% imgName2 = 'images/pumpkin2.JPG';

img1 = single(rgb2gray(imread(imgName1)));
img2 = single(rgb2gray(imread(imgName2)));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);
[matches, scores] = vl_ubcmatch(da, db);

x1s = [fa(1:2, matches(1,:)); ones(1,size(matches,2))];
x2s = [fb(1:2, matches(2,:)); ones(1,size(matches,2))];

%show matches
clf
showFeatureMatches(img1, x1s(1:2,:), img2, x2s(1:2,:), 1);


%%
% =========================================================================
% 8-point RANSAC
% =========================================================================

threshold = 5;

% TODO: implement ransac8pF
[inliers, F] = ransac8pF(x1s, x2s, threshold);

showFeatureMatches(img1, x1s(1:2, inliers), img2, x2s(1:2, inliers), 1);

%%
% =========================================================================
% 8-point Adaptive RANSAC
% =========================================================================
threshold = 5;
[inliers_adp, F_adp, sample_count, e, p] = ransac8pF_adaptive(x1s, x2s, threshold);
showFeatureMatches(img1, x1s(1:2, inliers_adp), img2, x2s(1:2, inliers_adp), 1);
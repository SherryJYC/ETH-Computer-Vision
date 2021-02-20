% =========================================================================
% Exercise 8
% =========================================================================
clear all;
% Initialize VLFeat (http://www.vlfeat.org/)
run('./vlfeat-0.9.21/toolbox/vl_setup')
%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];

%Load images path
imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.004.pgm';

thresh = 0.0001; % threshold for ransac fundamental matrix
thresh_6 = 0.05; % threshold for 6-point DLT to get projective matrix

% load images
img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);

%don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches, scores] = vl_ubcmatch(da, db);

%showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 20);
% convert into homogeneous coordinates
xa = makehomogeneous(fa(1:2, matches(1,:)));
xb = makehomogeneous(fb(1:2, matches(2,:)));
% Compute essential matrix and projection matrices and triangulate matched points

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices

% use ransac to extract F and inliers

[F, inliers] = ransacfitfundmatrix(xa, xb, thresh);

% get outlier index
outliers = setdiff(1:size(matches,2),inliers);

% get inliers and outliers
inlier_a = xa(:,inliers);
inlier_b = xb(:,inliers);

outlier_a = xa(:,outliers);
outlier_b = xb(:,outliers);

% show inliers and outliers
showFeatureMatches(img1, inlier_a(1:2, :), img2, inlier_b(1:2, :), 20);
showFeatureMatches(img1, outlier_a(1:2, :), img2, outlier_b(1:2, :), 21);

% draw epipolar lines and epipoles in image pair
figure(1);
imshow(img1, []); 
hold on;
plot(inlier_a(1,:), inlier_a(2,:), '*r');
for i = 1:size(inlier_a,2)
    drawEpipolarLines(F'*inlier_b(:,i), img1); 
    hold on;
end

figure(2);
imshow(img2, []); 
hold on;
plot(inlier_b(1,:), inlier_b(2,:), '*r');
for i = 1:size(inlier_b,2)
    drawEpipolarLines(F*inlier_a(:,i), img2); 
    hold on;
end

% compute projection matrix
E = K'*F*K;

x1_calibrated = K \ inlier_a;
x2_calibrated = K \ inlier_b;

Ps{1} = eye(4);
Ps{2} = decomposeE(E, x1_calibrated, x2_calibrated);

%triangulate the inlier matches with the computed projection matrix
[X{1}, ~] = linearTriangulation(Ps{1}, x1_calibrated, Ps{2}, x2_calibrated);

%% Add an addtional view of the scene 
imagenames = ["../data/house.001.pgm"; "../data/house.002.pgm"; ...
    "../data/house.003.pgm"];

% get inliers from image 1 (a)
inlier_fa = fa(:,matches(1,inliers));
inlier_da = da(:,matches(1,inliers));

for i=1:3

% add image 3
imgName3 = imagenames(i);
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);

%match against the features from image 1 that where triangulated

% match image 3 with image 1
[matches3,~] = vl_ubcmatch(inlier_da, dc);

% convert to homogenous coordinates
xa_3 = makehomogeneous(inlier_fa(1:2, matches3(1,:)));
xc = makehomogeneous(fc(1:2, matches3(2,:)));

xc_calibrated = K \ xc;
xa_calibrated = K \ xa_3;

%run 6-point ransac based on 3d-2d pair
[Ps{i+2}, inlier3] = ransacfitprojmatrix(xc_calibrated, X{1}(:,matches3(1,:)), thresh_6);
outlier3 = setdiff(1:size(matches3,2),inlier3);
if (det(Ps{i+2}(1:3,1:3)) < 0 )
    Ps{i+2}(1:3,1:3) = -Ps{i+2}(1:3,1:3);
    Ps{i+2}(1:3, 4) = -Ps{i+2}(1:3, 4);
end
% show inliers and outliers
showInOutFeatureMatches(img1, xa_3(1:2, inlier3), xa_3(1:2, outlier3), ...
    img3, xc(1:2, inlier3), xc(1:2, outlier3), 21);
%triangulate the inlier matches with the computed projection matrix
[X{i+1}, ~] = linearTriangulation(Ps{1}, xa_calibrated(:,inlier3), ...
                              Ps{i+2}, xc_calibrated(:,inlier3));
end

%% Plot stuff

fig = 10;
figure(fig);

%use plot3 to plot the triangulated 3D points
colors = ["r."; "g."; "b."; "c."];
for i=1:4
    disp(i)
    plot3(X{i}(1,:),X{i}(2,:),X{i}(3,:),colors(i)); hold on;
end

%draw cameras
drawCameras(Ps, fig);

%% check plot one by one
% plot3(X{1}(1,:),X{1}(2,:),X{1}(3,:),'r.'); hold on;
% plot3(X{4}(1,:),X{4}(2,:),X{4}(3,:),'k.'); hold on;

%% Dense reconstruction (same as exerices 6)
disp('start dense reconstruction part...')
% load images
imgNameL = '../data/house.002.pgm';
imgNameR = '../data/house.003.pgm';

imgL = single(imread(imgNameL));
imgR = single(imread(imgNameR));

figure(1);
subplot(121); imshow(imgL, []);
subplot(122); imshow(imgR, []);

% rectify images
PL = K * Ps{4}(1:3,:);
PR = K * Ps{5}(1:3,:);

[imgRectL, imgRectR, Hleft, Hright, maskL, maskR] = ...
    getRectifiedImages(imgL, imgR);

% get disparity map 
dispRange = -40:40;
wsize = 30;
dispStereoL = ...
    stereoDisparity(imgRectL,imgRectR, dispRange, wsize);
dispStereoR = ...
    stereoDisparity(imgRectR, imgRectL, dispRange, wsize);

figure(1);
subplot(121); imshow(dispStereoL, [dispRange(1) dispRange(end)]);
subplot(122); imshow(dispStereoR, [dispRange(1) dispRange(end)]);

thresh = 8;

maskLRcheck = leftRightCheck(dispStereoL, dispStereoR, thresh);
maskRLcheck = leftRightCheck(dispStereoR, dispStereoL, thresh);

maskStereoL = double(maskL).*maskLRcheck;
maskStereoR = double(maskR).*maskRLcheck;

figure(2);
subplot(121); imshow(maskStereoL);
subplot(122); imshow(maskStereoR);

dispStereoL = double(dispStereoL);
dispStereoR = double(dispStereoR);
scale = 1;

S = [scale 0 0; 0 scale 0; 0 0 1];

% For each pixel (x,y), compute the corresponding 3D point 
% use S for computing the rescaled points with the projection 
% matrices PL PR
% ... same for other winner-takes-all
[coords2 ~] = ...
    generatePointCloudFromDisps(dispStereoL, Hleft, Hright, S*PL, S*PR);

imwrite(imgRectL, 'imgRectL.png');
imwrite(imgRectR, 'imgRectR.png');

% Use meshlab to open generated textured model, i.e. modelGC.obj
% ... same for other winner-takes-all, i.e. modelStereo.obj
generateObjFile('modelStereo', 'imgRectL.png', ...
    coords2, maskStereoL.*maskStereoR);








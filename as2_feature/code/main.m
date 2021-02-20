close all;

%%
% 1 - Feature detection

IMG_NAME1 = 'images/blocks.jpg';
IMG_NAME2 = 'images/house.jpg';

% Read images.
img1 = im2double(imread(IMG_NAME1));
img2 = im2double(imread(IMG_NAME2));

% Extract Harris corners.
sigma = 2; % .5, 1, 2
k = 0.04; % [4e-2, 6e-2]
thresh = 1e-5; % [1e-6, 1e-5, 1e-4]
[corners1, C1] = extractHarris(img1, sigma, k, thresh);
[corners2, C2] = extractHarris(img2, sigma, k, thresh);

% Plot images with Harris corners.
plotImageWithKeypoints(img1, corners1, 10);
plotImageWithKeypoints(img2, corners2, 11);
%% experiment with different choise of sigma, k and thresh
% exp = zeros(12, 3);
% exp(1:4,1) = 0.5;
% exp(5:9,1) = 1;
% exp(9:12,1) = 2;
% exp(1:2, 2) = 4e-2;
% exp(3:4, 2) = 6e-2;
% exp(5:6, 2) = 4e-2;
% exp(7:8, 2) = 6e-2;
% exp(9:10, 2) = 4e-2;
% exp(11:12, 2) = 6e-2;
% exp(1, 3) = 1e-5;
% exp(2, 3) = 1e-4;
% exp(3, 3) = 1e-5;
% exp(4, 3) = 1e-4;
% exp(5, 3) = 1e-5;
% exp(6, 3) = 1e-4;
% exp(7, 3) = 1e-5;
% exp(8, 3) = 1e-4;
% exp(9, 3) = 1e-5;
% exp(10, 3) = 1e-4;
% exp(11, 3) = 1e-5;
% exp(12, 3) = 1e-4;
% 
% figure(1)
% for i = 1:12
%     subplot(3,4,i)
%     [corners1, C1] = extractHarris(img1, exp(i,1), exp(i,2), exp(i,3));
%     imshow(img1, []);
%     hold on;
%     plot(corners1(2, :), corners1(1, :), '+r');
%     hold off;
%     title( sprintf('s = %s, k = %s, t = %s',...
%         string(exp(i,1)), string(exp(i,2)), string(exp(i,3))))
%     grid
% end
% %% 
% 
% figure(2)
% for i = 1:12
%     subplot(3,4,i)
%     [corners2, C2] = extractHarris(img2,exp(i,1), exp(i,2), exp(i,3));
%     imshow(img2, []);
%     hold on;
%     plot(corners2(2, :), corners2(1, :), '+r');
%     hold off;
%     title( sprintf('s = %s, k = %s, t = %s',...
%         string(exp(i,1)), string(exp(i,2)), string(exp(i,3))))
%     grid
% end

%%
% 2 - Feature description and matching

IMG_NAME1 = 'images/I1.jpg';
IMG_NAME2 = 'images/I2.jpg';

% Read images.
img1 = im2double(imread(IMG_NAME1));
img2 = im2double(imread(IMG_NAME2));

% Convert to grayscale.
img1 = rgb2gray(img1);
img2 = rgb2gray(img2);

% Extract Harris corners.
[corners1, C1] = extractHarris(img1, sigma, k, thresh);
[corners2, C2] = extractHarris(img2, sigma, k, thresh);

% Plot images with Harris corners.
plotImageWithKeypoints(img1, corners1, 20);
plotImageWithKeypoints(img2, corners2, 21);

% Extract descriptors.
[corners1, descr1] = extractDescriptors(img1, corners1);
[corners2, descr2] = extractDescriptors(img2, corners2);

% Match the descriptors - one way nearest neighbors.
matches_ow = matchDescriptors(descr1, descr2, 'one-way');

% Plot the matches.
plotMatches(img1, corners1(:, matches_ow(1, :)), img2, corners2(:, matches_ow(2, :)), 22);


% Match the descriptors - mutual nearest neighbors.
matches_mutual = matchDescriptors(descr1, descr2, 'mutual');

% Plot the matches.
plotMatches(img1, corners1(:, matches_mutual(1, :)), img2, corners2(:, matches_mutual(2, :)), 23);

% Match the descriptors - ratio test.
matches_ratio = matchDescriptors(descr1, descr2, 'ratio');

% Plot the matches.
plotMatches(img1, corners1(:, matches_ratio(1, :)), img2, corners2(:, matches_ratio(2, :)), 24);

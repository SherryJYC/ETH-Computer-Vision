% show feature matches between two images
%
% Input:
%   img1        - n x m color image 
%   corner1     - 2 x k matrix, holding keypoint coordinates of first image
%   corner11     - 2 x k matrix, holding keypoint coordinates of first image

%   img2        - n x m color image 
%   corner2     - 2 x k matrix, holding keypoint coordinates of second image
%   corner21     - 2 x k matrix, holding keypoint coordinates of second image

%   fig         - figure id
function showInOutFeatureMatches(img1, corner1, corner11, img2, corner2,corner21, fig)
    [sx, sy, sz] = size(img1);
    img = [img1, img2];
    
    corner2 = corner2 + repmat([sy, 0]', [1, size(corner2, 2)]);
    corner21 = corner21 + repmat([sy, 0]', [1, size(corner21, 2)]);
    
    figure(fig), imshow(img, []);    
    % show inliers
    hold on, plot(corner1(1,:), corner1(2,:), '+b');
    hold on, plot(corner2(1,:), corner2(2,:), '+b');    
    hold on, plot([corner1(1,:); corner2(1,:)], [corner1(2,:); corner2(2,:)], 'b');   
    % show outliers
    hold on, plot(corner11(1,:), corner11(2,:), '+r');
    hold on, plot(corner21(1,:), corner21(2,:), '+r');    
    hold on, plot([corner11(1,:); corner21(1,:)], [corner11(2,:); corner21(2,:)], 'r');   
end
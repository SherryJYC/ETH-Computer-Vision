% Extract Harris corners.
%
% Input:
%   img           - n x m gray scale image
%   sigma         - smoothing Gaussian sigma
%                   suggested values: .5, 1, 2
%   k             - Harris response function constant
%                   suggested interval: [4e-2, 6e-2]
%   thresh        - scalar value to threshold corner strength
%                   suggested interval: [1e-6, 1e-4]
%   
% Output:
%   corners       - 2 x q matrix storing the keypoint positions
%   C             - n x m gray scale image storing the corner strength
function [corners, C] = extractHarris(img, sigma, k, thresh)

% Compute image gradient
Ix = conv2(img,0.5*[1 ,0, -1], 'same');
Iy = conv2(img,0.5*[1 ,0, -1].', 'same');

% Compute local auto-correlation matrix
Ixx = imgaussfilt(Ix.*Ix, sigma);
Ixy = imgaussfilt(Ix.*Iy, sigma);
Iyy = imgaussfilt(Iy.*Iy, sigma);

% Harris response function
C = zeros(size(img));
C_t = zeros(size(img));
s1 = size(img, 1);
s2 = size(img, 2);

for i=1:s1-1
    for j=1:s2-1
        % current M matrix
        M = [Ixx(i, j), Ixy(i, j); Ixy(i, j), Iyy(i,j)];
        C(i,j) = det(M) - k*((trace(M))^2);
        % Use thresh to get final keypoints
        if C(i,j) > thresh
            C_t(i,j) = C(i,j);
        end
    end
end

% also ensure its local maxima in 3x3 region
idx = imregionalmax(C_t,8); 
[row, col] = find(idx);
corners = [row.'; col.'];


end
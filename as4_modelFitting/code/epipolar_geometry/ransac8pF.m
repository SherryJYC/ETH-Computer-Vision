% Compute the fundamental matrix using the eight point algorithm and RANSAC
% Input
%   x1, x2 	  Point correspondences 3xN
%   threshold     RANSAC threshold
%
% Output
%   best_inliers  Boolean inlier mask for the best model
%   best_F        Best fundamental matrix
%
function [best_inliers, best_F] = ransac8pF(x1, x2, threshold)

iter = 1000;

num_pts = size(x1, 2); % Total number of correspondences
best_num_inliers = 0; best_inliers = [];
best_F = 0; best_mean_dist = 0;

for i=1:iter
    % Randomly select 8 points and estimate the fundamental matrix using these.
    random_idx = randperm(num_pts);
    random_idx = random_idx(1:8);
    x1_select = x1(:,random_idx);
    x2_select = x2(:,random_idx);
    % Compute the error.
    [Fh, F] = fundamentalMatrix(x1_select, x2_select);
    % Compute the inliers with errors smaller than the threshold.
    dist1 = distPointsLines(x1, Fh.'*x2);
    dist2 = distPointsLines(x2, Fh*x1);
    dist = (dist1+dist2)./2;
    
    inlier_ok = dist<threshold;
    inlier_num = sum(inlier_ok); 
        
    % Update the number of inliers and fitting model if the current model
    % is better.
    if inlier_num > best_num_inliers
        best_num_inliers = inlier_num;
        best_F = Fh;
        best_inliers = find(dist<threshold);
        
        dist_inlier = dist(inlier_ok);
        best_mean_dist = mean(dist_inlier);
    end
end

end



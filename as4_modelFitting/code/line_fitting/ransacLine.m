function [best_k, best_b] = ransacLine(data, iter, threshold)
% data: a 2xn dataset with n data points
% iter: the number of iterations
% threshold: the threshold of the distances between points and the fitting line

num_pts = size(data, 2); % Total number of points
best_num_inliers = 0;   % Best fitting line with largest number of inliers
best_k = 0; best_b = 0;     % parameters for best fitting line

for i=1:iter
    % Randomly select 2 points and fit line to these
    % Tip: Matlab command randperm / randsample is useful here
    random_idx = randperm(num_pts);
    pt1 = data(:,random_idx(1));
    pt2 = data(:,random_idx(2));
    % Model is y = k*x + b. You can ignore vertical lines for the purpose
    % of simplicity.
    % compute slope ((delta y/delta x))
    k = (pt2(2)-pt1(2))/(pt2(1)-pt1(1));
    % compute intercept
    b = pt1(2)-k*pt1(1);
    
    % Compute the distances between all points with the fitting line
    dist = distPointsLines(data,k, b);
        
    % Compute the inliers with distances smaller than the threshold
    inlier_ok = dist<threshold;
    inlier_num = sum(inlier_ok); 

    % Update the number of inliers and fitting model if the current model
    % is better.
    if inlier_num > best_num_inliers
        best_num_inliers = inlier_num;
        best_k = k;
        best_b = b;
%         inliers = data(:,find(dist<threshold));
    end
end


end

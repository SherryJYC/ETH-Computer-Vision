function peak = find_peak(X, xl, r)
%FIND_PEAK 
% X: data matrix, LXn (L: No.pixels, n: No.feature)
% xl: current pixel
% r: radius for region of interest

L = size(X, 1);
shift_thresh = 1;
current_shift = 2;
current_x = xl;

while current_shift>shift_thresh
    % get points in region
    x_repeat = repmat(current_x, [L,1]);
    dist = sqrt(sum((X - x_repeat).^2, 2));
    x_interest = X(dist<r, :);
    % get mean point and shift
    center = mean(x_interest, 1);
    current_shift = norm(current_x-center);
    % update current point
    current_x = center;
end

peak = center;
end


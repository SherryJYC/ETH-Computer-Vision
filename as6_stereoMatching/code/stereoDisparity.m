function disp = stereoDisparity(img1, img2, dispRange)

% dispRange: range of possible disparity values
% --> not all values need to be checked

img1 = double(img1);
img2 = double(img2);

wsize = 10;

filter = fspecial('average',wsize);

best_dist_mat = ones(size(img1))*realmax;
disp = realmax;
for d = dispRange
    % shift image and compute squared distance
    img_diff = (img1 - shiftImage(img2,d)).^2;
    
    % compute distance in window
    dist_mat = conv2(img_diff,filter,'same');
    
    % update distance mat by winner-takes-all rule
    winner = dist_mat < best_dist_mat;
    loser = dist_mat >=best_dist_mat;
    
    disp = d.*winner + disp.*loser;
    best_dist_mat = dist_mat.*winner + best_dist_mat.*loser;
    
end

end
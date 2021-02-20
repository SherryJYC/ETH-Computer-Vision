function diffs = diffsGC(img1, img2, dispRange)

% get data costs for graph cut
diffs = zeros(size(img1,1),size(img1,2),size(dispRange,2)); % mxnxr

wsize = 10;
filter = fspecial('average',wsize);

for d=dispRange
    % shift image and compute squared distance
    img_diff = (img1 - shiftImage(img2,d)).^2;
    
    %Convolve with box filter
    diffs(:,:,d-dispRange(1)+1) = conv2(img_diff,filter,'same');
end

end
function hist = color_histogram(xMin,yMin,xMax,yMax,frame,hist_bin)
%COLOR_HISTOGRAM Summary of this function goes here
% calculate the normalized histogram of RGB colors occurring within 
% the bounding box defined by [xMin, xMax] × [yMin, yMax] in current frame

% % avoid index out of frame
% xMin = round(max(1,xMin));
% yMin = round(max(1,yMin));
% xMax = round(min(xMax,size(frame,2)));
% yMax = round(min(yMax,size(frame,1)));
% 
% % get R, G, B channels
% R = frame(yMin:yMax,xMin:xMax,1);
% G = frame(yMin:yMax,xMin:xMax,2);
% B = frame(yMin:yMax,xMin:xMax,3);
% 
% % generate histgram for each channel
% [histR, ~] = imhist(R, hist_bin);
% [histG, ~] = imhist(G, hist_bin);
% [histB, ~] = imhist(B, hist_bin);
% 
% % get normalized histgram
% hist = [histR; histG; histB];
% hist = hist/sum(hist);
%cut the bbx if the bbx go out of the image
xMin = round(max(1,xMin));
yMin = round(max(1,yMin));
xMax = round(min(xMax,size(frame,2)));
yMax = round(min(yMax,size(frame,1)));

%divide rgb channel seperately
frame_r = frame(yMin:yMax, xMin:xMax, 1 );
frame_g = frame(yMin:yMax, xMin:xMax, 2 );
frame_b = frame(yMin:yMax, xMin:xMax, 3 );

%generate histogram
hist_r = imhist(frame_r,hist_bin) ;
hist_g = imhist(frame_g,hist_bin) ;
hist_b = imhist(frame_b,hist_bin) ;

hist = [hist_r ; hist_g ; hist_b] ;
% noramlization 
hist = hist/sum(hist);

end


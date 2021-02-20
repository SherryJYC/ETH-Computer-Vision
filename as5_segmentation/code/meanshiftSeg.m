function [map peak] = meanshiftSeg(img)
img = double(img);
w = size(img, 1);
h = size(img,2);
L = w*h;
X = [reshape(img(:,:,1),L,1),reshape(img(:,:,2),L,1),reshape(img(:,:,3),L,1)];

% define radius
r = 30;
peaks = [];
map = zeros(size(img(:,:,1)));

for i=1:L
    % get peak for current pixel
    current_peak = find_peak(X, X(i,:), r);
    % compare with previous peaks
    if i==1
        peaks = [peaks; current_peak];
        map(i)=size(peaks, 1);
    else
        % check if needed to merge peak
        current_peak_repeat = repmat(current_peak, size(peaks,1),1);
        dist = sqrt(sum((peaks - current_peak_repeat).^2, 2));
        
        idx = find(dist<r/2, 1);
        % if no need to merge
        if isempty(idx)
            peaks = [peaks; current_peak];
            map(i)=size(peaks, 1);
        % if merge
        else
            [closest_dist, closest_peak] = min(dist);          
            map(i) = closest_peak;
        end
    end
end

peak = peaks;
end
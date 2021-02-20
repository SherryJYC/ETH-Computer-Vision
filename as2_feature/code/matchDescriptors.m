% Match descriptors.
%
% Input:
%   descr1        - k x q descriptor of first image
%   descr2        - k x q' descriptor of second image
%   matching      - matching type ('one-way', 'mutual', 'ratio')
%   
% Output:
%   matches       - 2 x m matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2, matching)
    distances = ssd(descr1, descr2);
    % row is index for 1, col is index for 2
    % for each row (1), find min along col(2)
    [m, idx] = min(distances, [], 2);
    matches1 = zeros(2, size(descr1,2));
    matches1(1,:) = 1:size(descr1,2);
    matches1(2,:) = idx;
 
    if strcmp(matching, 'one-way')
        matches = matches1;
        
    elseif strcmp(matching, 'mutual')
        [m, idx2] = min(distances, [], 1);
        matches2 = zeros(2, size(descr2,2));
        matches2(1,:) = 1:size(descr2,2);
        matches2(2,:) = idx2;
        
        matches = [];
        for i=1:size(matches1, 2)
            key2 = matches1(2,i); % index for keypoint in img2
            if matches2(2,key2) == i
                matches = [matches; i, key2];
            end
        end
        matches = matches.';
        
    elseif strcmp(matching, 'ratio')
        mindist2 = mink(distances, 2, 2);
        thresh = 0.5;
        ratios = mindist2(:,1)./mindist2(:,2);
        index = ratios < thresh;
        matches = matches1(:,index);
     
    else
        error('Unknown matching type.');
    end
end

function distances = ssd(descr1, descr2)
    descr1 = descr1.'; % first axis is about number of keypoints
    descr2 = descr2.'; % first axis is about number of keypoints
    
    distances = pdist2(descr1,descr2);
    %distance(i,j) corresponds to the pairwise distance between observation 
    % i in descr1 and observation j in descr2.
end